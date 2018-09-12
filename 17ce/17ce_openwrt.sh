#!/bin/sh
# Copyight (C) www.17ce.com

CDN_BASE="https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce"
# http://www.17ce.com/api/17ce_route_client_new.php
UPDATE_URL="$CDN_BASE/17ce_version.php"
#TEMP_FILE="/tmp/update.txt"
#UPDATE_FILE="/tmp/update.tgz"
WORK_DIR="/tmp/17ce"
SAVE_DIR="/etc/17ce"
USERNAME="$1"
export LD_LIBRARY_PATH=/lib:$WORK_DIR
logging()
{
  logger -t "【17ce】" "$1"
}
wait_for_network(){
  echo "waiting for network..."
  sleep 2
  echo "waiting for network......"
}
wget_install()
{
  echo $2
  wget -q --no-check-certificate -O $1 $2 
  chmod +x $1
}

check_update()
{
  UPFLAG=1
  MAINEXEC="$WORK_DIR/17ce_v3"
  if [ ! -f "$MAINEXEC" ]; then
    echo "$MAINEXEC not found"
  else
    VERSION=`$MAINEXEC -v`
    TEMPSTR=`curl -k -m 10 $UPDATE_URL 2>/dev/null  || wget -q --no-check-certificate -O - $UPDATE_URL 2>/dev/null`
    TVER=`echo $TEMPSTR|awk '{print $1}'`
    #TURL=`echo $TEMPSTR|awk '{print $2}'`
    echo "current version:$VERSION, newest:$TVER"
    if [ "$VERSION" == "$TVER" ]; then
      UPFLAG=0
    fi
  fi
  
  if [ "$UPFLAG" != "0" ]; then
    echo "downloading files"
    killall -9 17ce_v3 2>/dev/null  >/dev/null
    rm -rf $WORK_DIR
    mkdir -p $WORK_DIR
    cd $WORK_DIR
    #wget_install 17ce_v3      $CDN_BASE/bin/17ce_v3
    #wget_install conf.json    $CDN_BASE/bin/conf.json
    ##wget_install ld-uClibc.so.1   $CDN_BASE/lib/ld-uClibc.so.1
    #wget_install libc.so      $CDN_BASE/lib/libc.so
    #wget_install libcurl.so.4   $CDN_BASE/lib/libcurl.so.4
    #wget_install libstdc++.so.6   $CDN_BASE/lib/libstdc
    ##wget_install libpolarssl.so.7    $CDN_BASE/lib/libpolarssl.so.7
    ##wget_install libpthread.so.0    $CDN_BASE/lib/libpthread.so.0
    wget_install bin.tar.gz  $CDN_BASE/bin.tar.gz
    wget_install lib.tar.gz  $CDN_BASE/lib.tar.gz
    tar zxvf bin.tar.gz
    tar zxvf lib.tar.gz
    rm -f bin.tar.gz
    rm -f lib.tar.gz
  fi
  
  echo "update myself"
  wget -q --no-check-certificate -O /tmp/17ce_openwrt.sh $CDN_BASE/17ce_openwrt.sh
  if [ -f "/tmp/17ce_openwrt.sh" ]; then
    sed -i s%^WORK_DIR=.*%WORK_DIR=\"$WORK_DIR\"% /tmp/17ce_openwrt.sh
    sed -i s%^SAVE_DIR=.*%SAVE_DIR=\"$SAVE_DIR\"% /tmp/17ce_openwrt.sh
    sed -i s%^USERNAME=.*%USERNAME=\"$USERNAME\"% /tmp/17ce_openwrt.sh
    mkdir -p $SAVE_DIR
    mv -f /tmp/17ce_openwrt.sh $SAVE_DIR/17ce_openwrt.sh
    chmod +x $SAVE_DIR/17ce_openwrt.sh
  fi
}
start()
{
  wait_for_network
  check_update      
  if ps|grep -w "17ce_v3"|grep -v grep 2>/dev/null >/dev/null; then
    echo "17ce is Running"
  	MEM=`ps|grep 17ce_v3|grep -v grep|awk '{print $3}'`
    if [ "$MEM" -gt 35000 ]; then
      echo "mem out: $MEM"
      /etc/init.d/17ce* restart
    else
      echo "mem ok"
      LOGSIZE=`ls $WORK_DIR/17ce_v3.log -l| awk '{print $5}'`
      if [ "$LOGSIZE" -gt 1000000 ]; then
        echo "log size out: $LOGSIZE"
        /etc/init.d/17ce* restart
      else
        echo "log size ok"
      fi
    fi
  else
    echo "starting 17ce"
    sleep 2
    logging "17ce account：$USERNAME"
    $WORK_DIR/17ce_v3 -u "$USERNAME"    
  fi     
}

start
