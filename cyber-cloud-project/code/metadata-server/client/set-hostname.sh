#!/bin/bash
my_ip$(hostname -I | awk '{print $1}')
curl 192.168.128.12:8069/hostname?ip=$my_ip -o /etc/hostname
