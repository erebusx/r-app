#!/bin/sh
rm -f /etc/ipshare/ipshare_openwrt_ins.sh
wget --no-check-certificate -O /etc/ipshare/ipshare_openwrt_ins.sh https://raw.githubusercontent.com/erebusx/r-app/ipshare/ipshare/ipshare_openwrto.sh 2>/dev/null  >/dev/null
chmod +x /etc/ipshare/ipshare_openwrt_ins.sh
rm -f /etc/ipshare/ipshare_openwrt_tmp.sh
