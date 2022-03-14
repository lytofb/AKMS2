#!/bin/bash

ip=$(hostname -I | cut -d ' ' -f 1)
project=$HOME'/AKMS2'
sudo mount -t nfs -o nolock $ip:$project /mnt
