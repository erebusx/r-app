#!/bin/sh
BASE_URL='https://raw.githubusercontent.com/erebusx/r-app/ipshare/ipshare'
WORK_DIR='/tmp/ipshare'
SAVE_DIR='/etc/ipshare'
CONF_DIR='/etc/config'
CONF_FILE="$CONF_DIR/ipshare"
EXEC_BIN="$WORK_DIR/ipshare"

export LD_LIBRARY_PATH=/lib:$WORK_DIR

logging()
{
  echo $1
  logger -t "【ipshare】" "$1"
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
    UPFLAG=0
  fi
  
  if [ "$UPFLAG" != "0" ]; then
    echo "downloading files"
    $EXEC_BIN stop
    sleep 2
    killall -9 ipshare 2>/dev/null >/dev/null
    rm -rf $WORK_DIR
    mkdir -p $WORK_DIR
    cd $WORK_DIR
    #wget_download libcurl.so.4     $BASE_URL/lib/libcurl.so.4
    #wget_download libmbedcrypto.so.0     $BASE_URL/lib/libmbedcrypto.so.0
    #wget_download libmbedtls.so.9 $BASE_URL/lib/libmbedtls.so.9
    #wget_download libmbedx509.so.0     $BASE_URL/lib/libmbedx509.so.0
    #wget_download libpolarssl.so.7     $BASE_URL/lib/libpolarssl.so.7
    #wget_download libpthread.so.0     $BASE_URL/lib/libpthread.so.0
    #wget_download ipshare       $BASE_URL/bin/ipshare
    wget_download bin.tar.gz  $CDN_BASE/bin.tar.gz
    tar zxvf bin.tar.gz
    rm -f bin.tar.gz
  fi
  
  echo "update myself"
  wget_download /tmp/ipshare_openwrt.sh https://raw.githubusercontent.com/erebusx/r-app/ipshare/ipshare/ipshare_openwrt.sh
  if [ -f "/tmp/ipshare_openwrt.sh" ]; then
    sed -i s%^WORK_DIR=.*%WORK_DIR=\"$WORK_DIR\"% /tmp/ipshare_openwrt.sh
    sed -i s%^SAVE_DIR=.*%SAVE_DIR=\"$SAVE_DIR\"% /tmp/ipshare_openwrt.sh
    sed -i s%^USERNAME=.*%USERNAME=\"$USERNAME\"% /tmp/ipshare_openwrt.sh
    mkdir -p $SAVE_DIR
    mv -f /tmp/ipshare_openwrt.sh $SAVE_DIR/ipshare_openwrt.sh
    chmod +x $SAVE_DIR/ipshare_openwrt.sh
  fi
}

start()
{
  check_update
  if ps|grep -w "ipshare start"|grep -v grep 2>/dev/null >/dev/null; then
    echo "ipshare is Running"
  else
    logging "starting 17ce"
    $EXEC_BIN start
  fi
}

stop()
{
  if [ -f "$EXEC_BIN" ]; then
    logging "stoping 17ce"
    $EXEC_BIN stop
  fi
}

restart()
{
  check_update
  logging "restarting 17ce"
  $EXEC_BIN restart
}
