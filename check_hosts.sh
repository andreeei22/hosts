#!/bin/bash

verifica_ip() {
    local host="$1"
    local ip="$2"
    local dns_server="$3"

    if nslookup "$host" "$dns_server" 2>/dev/null | grep -q "Address: $ip"; then
        echo "[OK] $host -> $ip este valid (verificat cu DNS $dns_server)"
        return 0
    else
        echo "[EROARE] $host -> $ip NU este valid conform DNS $dns_server"
        return 1
    fi
}

DNS_SERVER="${1:-8.8.8.8}"

while read -r ip host rest; do
    [[ -z "$ip" || "$ip" == \#* ]] && continue
    [[ "$ip" == *:* || "$ip" == "127.0.0.1" || "$ip" == "127.0.1.1" ]] && continue

    if [ -n "$host" ]; then
        verifica_ip "$host" "$ip" "$DNS_SERVER"
    fi
done < /etc/hosts
