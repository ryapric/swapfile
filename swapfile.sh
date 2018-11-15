#!/usr/bin/env bash


if [ $EUID -ne 0 ]; then
    echo "Only root can interact with memory settings. Aborting." >&2
    exit 1
fi


sysmem0="$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')"
sysmem="$((sysmem / 1000))"
if [ $sysmem -lt 1000 ]; then
    sysmem="'0.'$((sysmem0 / 1000))"
fi


echo "Available memory: ${sysmem} KB"
echo "Would you like to create a swapfile (at /mnt/swapfile)? (y/n) "
read make_swap
if [ "$make_swap" == "y" ]; then
    echo "How large of a swapfile would you like?"
    echo "Please enter as an integer, in GB (at least 1) : "
    read swap_size
    swapfile="/mnt/swapfile"
    swapoff -a
    fallocate -l ${swap_size}g "$swapfile"
    chmod 600 "$swapfile"
    mkswap "$swapfile"
    swapon "$swapfile"
fi
