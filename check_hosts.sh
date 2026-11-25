#!/bin/bash

while read -r ip host rest; do
    # Ignora liniile goale si comentariile
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    # Ignora adresele IPv6 si localhost
    if [[ "$ip" == *:* || "$ip" == "127.0.0.1" || "$ip" == "127.0.1.1" ]]; then
        continue
    fi

    if [ -n "$host" ]; then
        if nslookup "$host" | grep -q "Address: $ip"; then
            echo "Bogus IP for $host in /etc/hosts! (Valid)"
        else
            echo "Bogus IP for $host in /etc/hosts! (Invalid: $ip)"
        fi
    fi
done < /etc/hosts
