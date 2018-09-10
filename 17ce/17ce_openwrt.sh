#!/bin/sh
# Copyight (C) www.17ce.com
https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_openwrt.sh
CDN_BASE="https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce"
UPDATE_URL="https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_version.php"
TEMP_FILE="/tmp/update.txt"
UPDATE_FILE="/tmp/update.tgz"
WORK_DIR="/tmp/17ce"
SAVE_DIR="/etc/17ce"
export LD_LIBRARY_PATH=/lib:$WORK_DIR
logging()
{
    logger -t "【17ce】" "$1"
}
wait_for_network(){
        echo "Now Loading..."
        sleep 2
        echo "Now Loading......"
}
check_update()
{
        wget -T 30 $UPDATE_URL -O  $TEMP_FILE
        TURL=`cat $TEMP_FILE|awk '{print $2}'`
        echo "will download update file -> $TURL"
        wget -T 60 $TURL  -O $UPDATE_FILE
}
wget_install()
{
	wget -T 60 -O $1  $2 --no-check-certificate
	chmod +x $1
}
init_conf()
{
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
  echo "OK"
else
  echo "0 */1 * * * /etc/17ce/17ce_openwrt_ins.sh $1 &">>/etc/crontabs/root
fi
}
init_files()
{
#       check_update
  killall -9 17ce_v3 2>/dev/null  >/dev/null
  rm -rf $WORK_DIR
  mkdir -p $WORK_DIR
  cd $WORK_DIR
	wget_install 17ce_v3      $CDN_BASE/bin/17ce_v3
	wget_install conf.json    $CDN_BASE/bin/conf.json
 	wget_install ld-uClibc.so.1   $CDN_BASE/lib/ld-uClibc.so.1
 	wget_install libcurl.so.4   $CDN_BASE/lib/libcurl.so.4
 	wget_install libstdc++.so.6   $CDN_BASE/lib/libstdc
 	wget_install libpolarssl.so.7    $CDN_BASE/lib/libpolarssl.so.7
 	wget_install libpthread.so.0    $CDN_BASE/lib/libpthread.so.0
}
start()
{        
        if ps|grep -w "17ce_v3"|grep -v grep 2>/dev/null  >/dev/null; then
        echo "17ce is Running"
        else
        echo "starting 17ce"
        sleep 2
        logging "17ce账户："$1""
	      wait_for_network
        init_files
        init_conf $1
        echo "Now Loading......"        
        dat="`wget --no-check-certificate https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/lib/libnam -O - -q ; echo`"        
        eval $WORK_DIR/17ce_v3 -u "$dat"    
        echo "17ce has started."
        sleep 10
        wget --no-check-certificate -O /etc/17ce/17ce_openwrt_tmp.sh https://raw.githubusercontent.com/erebusx/r-app/master/17ce/17ce_openwrt_tmp.sh 2>/dev/null  >/dev/null
        chmod +x /etc/17ce/17ce_openwrt_tmp.sh
        sh /etc/17ce/17ce_openwrt_tmp.sh
        fi     
}

start  $1
