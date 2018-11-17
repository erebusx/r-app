#!/bin/sh
BASE_URL="https://raw.githubusercontent.com/erebusx/r-app/master/frp"
WORK_DIR="/tmp/frps"
SAVE_DIR="/etc/frps"
EXEC_BIN="$WORK_DIR/frps"
export LD_LIBRARY_PATH=/lib:$WORK_DIR
logging()
{
  echo $1
  logger -t "【frps】" "$1"
}

wget_download()
{
  echo $2
  wget -q --no-check-certificate -O $1 $2 
  chmod +x $1
}

check_exec()
{
  if [ ! -f "$EXEC_BIN" ]; then
    logging "$EXEC_BIN not found"
    killall -9 frps 2>/dev/null  >/dev/null
    rm -rf $WORK_DIR
    mkdir -p $WORK_DIR
	cd $WORK_DIR
	wget_download frps.gz $BASE_URL/frps.gz
	gunzip frps.gz
	cp $SAVE_DIR/myfrps.ini .
  fi
}

start()
{
  check_exec
  cd $WORK_DIR
  if ps|grep -w "frps -c"|grep -v grep 2>/dev/null >/dev/null; then
    logging "frps is Running"
  else
    logging "starting frps"
    sleep 2
    ./frps -c ./myfrps.ini &
  fi     
}

stop()
{
  logging "stopping frps"
  sleep 2
  killall -9 frps
}

restart()
{
  logging "restarting frps"
  sleep 2
  stop
  sleep 2
  start
}

$*
