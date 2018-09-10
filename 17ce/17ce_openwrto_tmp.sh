#!/bin/sh
rm -f /etc/17ce/17ce_openwrt_ins.sh
wget --no-check-certificate -O /etc/17ce/17ce_openwrt_ins.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_openwrto.sh 2>/dev/null  >/dev/null
chmod +x /etc/17ce/17ce_openwrt_ins.sh
rm -f /etc/17ce/17ce_openwrt_tmp.sh

