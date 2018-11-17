#!/bin/sh
WORK_DIR="/tmp/frps"
SAVE_DIR="/etc/frps"

init_conf()
{
  #echo -e "#!/bin/sh /etc/rc.common \n# Copyright (C) 17ce.com \nstart=99 \n$SAVE_DIR/17ce_openwrt_ins.sh $1 2>/dev/null  >/dev/null" >/etc/init.d/17ce_openwrt
  cat <<EOF > /etc/init.d/frps
#!/bin/sh /etc/rc.common
START=99
STOP=10

start() {
    $SAVE_DIR/frps.sh start
}

restart() {
    $SAVE_DIR/frps.sh restart
}

stop() {
    $SAVE_DIR/frps.sh stop
}
EOF
  chmod +x /etc/init.d/frps
  /etc/init.d/frps enable

  if [ ! -f "/etc/rc.d/S99frps" ]; then
    ln -s /etc/init.d/frps /etc/rc.d/S99frps
    ln -s /etc/init.d/frps /etc/rc.d/K10frps
  fi
  if [ ! -f "/etc/crontabs/root" ]; then
    touch /etc/crontabs/root
    chmod +x /etc/crontabs/root
  fi
  if grep -wq "frps.sh" /etc/crontabs/root; then
    echo "OK"
  else
    echo "0 */1 * * * $SAVE_DIR/frps.sh start &">>/etc/crontabs/root
  fi
}

install()
{
  echo "installing frps"
  rm -rf $SAVE_DIR
  rm -rf $WORK_DIR
  killall -9 frps 2>/dev/null  >/dev/null
  cd /tmp
  wget -q --no-check-certificate -O /tmp/frps.sh https://raw.githubusercontent.com/erebusx/r-app/master/frp/frps.sh
  if [ -f "/tmp/frps.sh" ]; then
    init_conf
    mkdir -p $SAVE_DIR
    mv -f /tmp/frps.sh $SAVE_DIR/frps.sh
    chmod +x $SAVE_DIR/frps.sh
  fi
  sleep 2
  echo "put your config named 'myfrps.ini' into $SAVE_DIR, then run '$SAVE_DIR/frps.sh start'"
}

uninstall()
{
  echo "uninstalling frps"
  killall -9 frps
  rm -rf $SAVE_DIR
  rm -rf $WORK_DIR
  rm -f /etc/rc.d/S99frps
  rm -f /etc/rc.d/K10frps
  rm -f /etc/init.d/frps
  if [ -f "/etc/crontabs/root" ]; then
    sed -i /frps.sh/d /etc/crontabs/root
  fi
  echo "done"
}

$*