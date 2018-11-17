#!/bin/sh
BASE_URL="https://raw.githubusercontent.com/erebusx/r-app/master/frp"
WORK_DIR="/tmp/frpc"
SAVE_DIR="/etc/frpc"
EXEC_BIN="$WORK_DIR/frpc"
export LD_LIBRARY_PATH=/lib:$WORK_DIR
logging()
{
  echo $1
  logger -t "【frpc】" "$1"
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
    killall -9 frpc 2>/dev/null  >/dev/null
    rm -rf $WORK_DIR
    mkdir -p $WORK_DIR
	cd $WORK_DIR
	wget_download frpc.gz $BASE_URL/frpc.gz
	gunzip frpc.gz
	chmod +x frpc
  fi
  if [ ! -f "$WORK_DIR/myfrpc.ini" ]; then
	cp $SAVE_DIR/myfrpc.ini $WORK_DIR/myfrpc.ini
  fi
}

start()
{
  check_exec
  cd $WORK_DIR
  if ps|grep -w "frpc -c"|grep -v grep 2>/dev/null >/dev/null; then
    logging "frpc is Running"
  else
    logging "starting frpc"
    sleep 2
    ./frpc -c ./myfrpc.ini &
  fi     
}

stop()
{
  logging "stopping frpc"
  sleep 2
  killall -9 frpc
}

restart()
{
  logging "restarting frpc"
  sleep 2
  stop
  sleep 2
  start
}

$*
