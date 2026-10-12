#!/bin/sh

# Stolen from: https://forum.manjaro.org/t/root-tip-utility-script-get-lan-ip-address/100603

for nic in $(ip a | grep ' state UP' | cut -d' ' -f2 | cut -d':' -f1); do
    ipshow=$(ip a show "$nic" 2> /dev/null)
    if [ $? == 0 ]; then
        ip=$(echo "$ipshow" | grep 'inet ' | head -n 4 | awk '{ print $2 }' | cut -d/ -f1)
        echo -e "$ip \t $nic"
    fi
done

