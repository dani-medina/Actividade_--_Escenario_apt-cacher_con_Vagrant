#!/bin/sh

if ! ip a | grep 192.168 > /dev/null; then
	ip a add (IP DA REDE DA TUA CASA)/24 dev eth1 && ip l set dev eth1 up 
fi
