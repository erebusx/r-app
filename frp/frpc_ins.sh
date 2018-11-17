#!/bin/sh
WORK_DIR="/tmp/frpc"
SAVE_DIR="/etc/frpc"

init_conf()
{
  #echo -e "#!/bin/sh /etc/rc.common \n# Copyright (C) 17ce.com \nstart=99 \n$SAVE_DIR/17ce_openwrt_ins.sh $1 2>/dev/null  >/dev/null" >/etc/init.d/17ce_openwrt
  cat <<EOF > /etc/init.d/frpc
#!/bin/sh /etc/rc.common
START=99
STOP=10

start() {
    $SAVE_DIR/frpc.sh start
}

restart() {
    $SAVE_DIR/frpc.sh restart
}

stop() {
    $SAVE_DIR/frpc.sh stop
}
EOF
  chmod +x /etc/init.d/frpc
  /etc/init.d/frpc enable

  if [ ! -f "/etc/rc.d/S99frpc" ]; then
    ln -s /etc/init.d/frpc /etc/rc.d/S99frpc
    ln -s /etc/init.d/frpc /etc/rc.d/K10frpc
  fi
  if [ ! -f "/etc/crontabs/root" ]; then
    touch /etc/crontabs/root
    chmod +x /etc/crontabs/root
  fi
  if grep -wq "frpc.sh" /etc/crontabs/root; then
    echo "OK"
  else
    echo "0 */1 * * * $SAVE_DIR/frpc.sh start &">>/etc/crontabs/root
  fi
}

install()
{
  echo "installing frpc"
  rm -rf $SAVE_DIR
  rm -rf $WORK_DIR
  killall -9 frpc 2>/dev/null  >/dev/null
  cd /tmp
  wget -q --no-check-certificate -O /tmp/frpc.sh https://raw.githubusercontent.com/erebusx/r-app/master/frp/frpc.sh
  if [ -f "/tmp/frpc.sh" ]; then
    init_conf
    mkdir -p $SAVE_DIR
    mv -f /tmp/frpc.sh $SAVE_DIR/frpc.sh
    chmod +x $SAVE_DIR/frpc.sh
  fi
  sleep 2
  echo "put your config named 'myfrpc.ini' into $SAVE_DIR, then run '$SAVE_DIR/frpc.sh start'"
}

uninstall()
{
  echo "uninstalling frpc"
  killall -9 frpc
  rm -rf $SAVE_DIR
  rm -rf $WORK_DIR
  rm -f /etc/rc.d/S99frpc
  rm -f /etc/rc.d/K10frpc
  if [ -f "/etc/crontabs/root" ]; then
    sed -i /frpc.sh/d /etc/crontabs/root
  fi
  echo "done"
}

$*