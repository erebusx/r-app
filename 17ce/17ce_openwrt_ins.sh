#!/bin/sh
echo "installing 17ce"
if [ $# == 1 ]; then
	echo "17CE账号：$1"	
	sleep 2
else
	echo "Usage: ./17ce_openwrt_ins.sh xxx@xxx.com #xxx@xxx.com改成您的账户"
	exit 1
fi
echo 
echo "by 17CE"
rm -rf /etc/17ce
rm -rf /tmp/17ce
rm -rf 17ce*
killall -9 17ce_v3 2>/dev/null  >/dev/null
cd /tmp
wget --no-check-certificate -O /tmp/17ce_openwrt.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_openwrt.sh 2>/dev/null  >/dev/null
if [ -f "/tmp/17ce_openwrt.sh" ]; then
  mkdir -p /etc/17ce
  mv -f /tmp/17ce_openwrt.sh /etc/17ce/17ce_openwrt.sh
  chmod +x /etc/17ce/17ce_openwrt.sh
  sh /etc/17ce/17ce_openwrt.sh
fi