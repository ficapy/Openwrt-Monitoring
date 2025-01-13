#!/bin/sh

while read time mac ip name bs; do
    ping -W1 -c1 "$ip" &>/dev/null && echo device=$name mac=$mac ip=$ip status=online || echo device=$name mac=$mac ip=$ip status=offline
done < /tmp/dhcp.leases > /tmp/device-status.tmp

cp /tmp/device-status.tmp /tmp/device-status.out
