#!/bin/bash
DNS_SERVER="${1:-8.8.8.8}"
verifica_ip(){
 local host="$1"
 local ip="$2"
 local dns="$3"
 local resolved_ips
 resolved_ips=$(nslookup "$host" "$dns" 2>/dev/null | awk '/^Address: / {print $2}' )
 if echo "$resolved_ips" | grep -Fxq "$ip"; then
  echo "[OK] $host -> $ip (confirmat de dns $dns)"
 return 0
else
  echo "[EROARE] Bogus IP for $host: in /etc/hosts este $ip, DNS ($dns) returneaza ${resolved_ips:-nimic}"
   return 1
fi
}

while read -r ip host rest; do
 [[ -z "$ip" || "$ip" =~ ^# ]] && continue
 [[ "-ip" == "127.0.0.1" || "$ip" == "127.0.0.1" || "$ip" =~ : ]] && continue
 [[ -z "$host" ]] && continue
 verifica_ip "$host" "$ip" "$DNS_SERVER"
done < /etc/hosts
