#!/bin/sh
BASE_URL="https://raw.githubusercontent.com/erebusx/r-app/master/17ce"
# http://www.17ce.com/api/17ce_route_client_new.php
UPDATE_URL="$BASE_URL/17ce_version.php"
#TEMP_FILE="/tmp/update.txt"
#UPDATE_FILE="/tmp/update.tgz"
WORK_DIR="/tmp/17ce"
SAVE_DIR="/etc/17ce"
USERNAME="40089975@qq.com"
EXEC_BIN="$WORK_DIR/17ce_v3"
export LD_LIBRARY_PATH=/lib:$WORK_DIR
logging()
{
  echo $1
  logger -t "【17ce】" "$1"
}
wait_for_network(){
  echo "waiting for network..."
  sleep 2
  echo "waiting for network......"
}
wget_download()
{
  echo $2
  wget -q --no-check-certificate -O $1 $2 
  chmod +x $1
}

check_update()
{
  UPFLAG=1
  if [ ! -f "$EXEC_BIN" ]; then
    echo "$EXEC_BIN not found"
  else
    VERSION=`$EXEC_BIN -v`
    TEMPSTR=`curl -k -m 10 $UPDATE_URL 2>/dev/null  || wget -q --no-check-certificate -O - $UPDATE_URL 2>/dev/null`
    TVER=`echo $TEMPSTR|awk '{print $1}'`
    #TURL=`echo $TEMPSTR|awk '{print $2}'`
    logging "current version:$VERSION, newest:$TVER"
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
    #wget_download 17ce_v3      $BASE_URL/bin/17ce_v3
    #wget_download conf.json    $BASE_URL/bin/conf.json
    ##wget_download ld-uClibc.so.1   $BASE_URL/lib/ld-uClibc.so.1
    #wget_download libc.so      $BASE_URL/lib/libc.so
    #wget_download libcurl.so.4   $BASE_URL/lib/libcurl.so.4
    #wget_download libstdc++.so.6   $BASE_URL/lib/libstdc
    ##wget_download libpolarssl.so.7    $BASE_URL/lib/libpolarssl.so.7
    ##wget_download libpthread.so.0    $BASE_URL/lib/libpthread.so.0
    wget_download bin.tar.gz  $BASE_URL/bin.tar.gz
    wget_download lib.tar.gz  $BASE_URL/lib.tar.gz
    tar zxvf bin.tar.gz
    tar zxvf lib.tar.gz
    rm -f bin.tar.gz
    rm -f lib.tar.gz
  fi
  
  echo "update myself"
  wget_download /tmp/17ce_openwrt.sh $BASE_URL/17ce_openwrt.sh
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
    logging "account : $USERNAME"
    $EXEC_BIN -u "$USERNAME"    
  fi     
}

start
