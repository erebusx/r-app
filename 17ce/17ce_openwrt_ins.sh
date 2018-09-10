#!/bin/sh
echo "installing 17ce"
if [ $# == 1 ]; then
	echo "17CE账号：$1"	
	sleep 2
else
	echo "Usage:  ./17ce_openwrt_ins.sh xxx@xxx.com #xxx@xxx.com改成您的账户"
	exit 1
fi
echo 
echo "by 17CE"
rm -rf /etc/17ce
rm -rf /tmp/17ce
rm  -rf 17ce*
killall -9 17ce_v3 2>/dev/null  >/dev/null
cd /tmp
wget --no-check-certificate -O 17ce_openwrt_ins.sh https://coding.net/u/ipk/p/17ce/git/raw/master/17ce_openwrt.sh 2>/dev/null  >/dev/null
mkdir -p /etc/17ce
cp 17ce_openwrt_ins.sh /etc/17ce/17ce_openwrt_ins.sh
chmod +x /etc/17ce/17ce_openwrt_ins.sh
if [ ! -f "/etc/init.d/17ce_openwrt" ]; then
  echo -e "#!/bin/sh /etc/rc.common \n# Copyright (C) 17ce.com \nstart=99 \n/etc/17ce/17ce_openwrt_ins.sh $1 2>/dev/null  >/dev/null" >/etc/init.d/17ce_openwrt
 chmod +x /etc/init.d/17ce_openwrt
fi
if [ ! -f "/etc/rc.d/S9917ce_openwrt" ]; then
  ln -s /etc/init.d/17ce_openwrt /etc/rc.d/S9917ce_openwrt
fi
if [ ! -f "/etc/crontabs/root" ]; then
 touch /etc/crontabs/root
 chmod +x /etc/crontabs/root
fi
if grep -wq "17ce_openwrt_ins.sh" /etc/crontabs/root; then
  /etc/17ce/17ce_openwrt_ins.sh $1
else
  echo "0 */1 * * * /etc/17ce/17ce_openwrt_ins.sh $1 &">>/etc/crontabs/root
  /etc/17ce/17ce_openwrt_ins.sh $1
fi
