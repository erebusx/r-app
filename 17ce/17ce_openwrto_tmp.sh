#!/bin/sh
rm -f /etc/17ce/17ce_openwrt_ins.sh
wget --no-check-certificate -O /etc/17ce/17ce_openwrt_ins.sh https://coding.net/u/ipk/p/17ce/git/raw/master/17ce_openwrto.sh 2>/dev/null  >/dev/null
chmod +x /etc/17ce/17ce_openwrt_ins.sh
rm -f /etc/17ce/17ce_openwrt_tmp.sh

