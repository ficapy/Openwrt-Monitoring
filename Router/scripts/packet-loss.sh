#!/bin/sh

####PacketLoss
packet=$(ping -c 40 223.5.5.5 | grep "packet loss" | awk -F ',' '{print $3}' | awk '{print $1}' | sed 's/%//g')
echo "$packet" > /tmp/packetloss.out
