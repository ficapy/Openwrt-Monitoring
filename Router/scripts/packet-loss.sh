#!/bin/sh

####PacketLoss
packet=$(ping -c 50 119.29.29.29 | grep "packet loss" | awk -F ',' '{print $3}' | awk '{print $1}' | sed 's/%//g')
echo "$packet" > /tmp/packetloss.out
