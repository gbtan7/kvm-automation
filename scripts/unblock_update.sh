#!/bin/sh
blocked_ips=" \
13.35.20.85 \
13.35.20.3 \
13.35.20.27 \
13.35.20.22 \
13.227.241.128 \
13.227.241.30 \
13.227.241.61 \
13.227.241.104 \
13.35.20.36 \
13.35.20.103 \
13.35.20.115 \
13.35.20.95 \
"
for ip in $blocked_ips
do
	echo "Unblocking $ip"
	/sbin/iptables -D INPUT -s ${ip} -j DROP
	/sbin/iptables -D OUTPUT -d ${ip} -j DROP
	/sbin/iptables -D FORWARD -d ${ip} -j DROP
done
