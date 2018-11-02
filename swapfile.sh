#!/usr/bin/env bash


sysmem0="$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')"
sysmem="$((sysmem / 1000))"
if [ $sysmem -lt 1000 ]; then
    sysmem="'0.'$((sysmem0 / 1000))"
fi

echo "Available memory: ${sysmem} KB"
echo "Would you like to create a swapfile (~/{x}g.swap)? (y/n) "
read make_swap
if [ "$make_swap" == "y" ]; then
    echo "How large of a swapfile would you like?"
    echo "Please enter as an integer, in GB (at least 1) : "
    read swap_size
    swapfile="~/${swap_size}g.swap"
    swapoff -a
    fallocate -l ${swap_size}g "$swapfile"
    chmod 600 "$swapfile"
    mkswap "$swapfile"
    swapon "$swapfile"
fi
