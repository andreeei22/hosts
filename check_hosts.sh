#!/bin/bash
cat /etc/hosts | while read -r ip name _; do
    if [[ ! "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || [ -z "$name" ]; then
        continue
    fi

    dns_ips=$(nslookup "$name" 8.8.8.8 2>/dev/null | awk '/^Address:/ && $2 !~ /#|:/ {print $2}')

    if [ -n "$dns_ips" ] && ! echo "$dns_ips" | grep -Fqw "$ip"; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done
