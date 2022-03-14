#!/bin/bash

echo "How to use this file?"
echo "Please provide an IP address and directory."
echo -n "IP address: "
read ip
echo -n "Directory(/home/\$usename/...): "
read directory

sudo mount -t nfs $ip:$directory /mnt

echo "====== Below are your hardware information ======"
df -h
echo "====== End ======"



