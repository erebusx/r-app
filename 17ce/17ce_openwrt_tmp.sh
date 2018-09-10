#!/bin/sh
wget --no-check-certificate -O /tmp/17ce_openwrt.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_openwrt.sh 2>/dev/null  >/dev/null
if [ -f "/tmp/17ce_openwrt.sh" ]; then
  rm -f /etc/17ce/17ce_openwrt.sh
  mv -f /tmp/17ce_openwrt.sh /etc/17ce/17ce_openwrt.sh
  chmod +x /etc/17ce/17ce_openwrt.sh
fi
rm -f /tmp/17ce_openwrt_tmp.sh

