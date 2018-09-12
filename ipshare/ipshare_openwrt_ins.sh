 #!/bin/sh
BASE_URL='https://raw.githubusercontent.com/erebusx/r-app/ipshare/ipshare'
WORK_DIR='/tmp/ipshare'
SAVE_DIR='/etc/ipshare'
CONF_DIR='/etc/config'
CONF_FILE="$CONF_DIR/ipshare"
export LD_LIBRARY_PATH=/lib:$WORK_DIR

init_conf()
{
  #echo -e "#!/bin/sh /etc/rc.common \n# Copyright (C) ipshare \nstart=99 \n/etc/ipshare/ipshare_openwrt_ins.sh $1 2>/dev/null  >/dev/null" >/etc/init.d/ipshare_openwrt
  cat <<EOF > /etc/init.d/ipshare_openwrt
#!/bin/sh /etc/rc.common
START=80
STOP=10

start() {
    $SAVE_DIR/ipshare_openwrt.sh start
}

restart() {
    $SAVE_DIR/ipshare_openwrt.sh restart
}

stop() {
    $SAVE_DIR/ipshare_openwrt.sh stop
}
EOF
  chmod +x /etc/init.d/ipshare_openwrt

  if [ ! -f "/etc/rc.d/S9917ce_openwrt" ]; then
    ln -s /etc/init.d/ipshare_openwrt /etc/rc.d/S99ipshare_openwrt
    ln -s /etc/init.d/ipshare_openwrt /etc/rc.d/K10ipshare_openwrt
  fi
  if [ ! -f "/etc/crontabs/root" ]; then
    touch /etc/crontabs/root
    chmod +x /etc/crontabs/root
  fi
  sed -i /ipshare_openwrt_ins.sh/d /etc/crontabs/root
  if grep -wq "ipshare_openwrt.sh" /etc/crontabs/root; then
    echo "OK"
  else
    echo "0 */1 * * * $SAVE_DIR/ipshare_openwrt.sh &">>/etc/crontabs/root
  fi

  mkdir -p $CONF_DIR
  cat <<EOF > $CONF_FILE
config base 'server'
        option enable '1'
        option username '$USERNAME'
EOF
}

install()
{
  echo "installing ipshare"
  if [ $# == 1 ]; then
    echo "ipshare account：$1"
    USERNAME="$1"
    sleep 2
  else
    echo "Usage: ipshare_openwrt_ins.sh install xxx"
    USERNAME="erebusx"
  fi

  rm -rf $SAVE_DIR
  rm -rf $WORK_DIR
  rm -f $CONF_FILE
  killall -9 17ce_v3 2>/dev/null >/dev/null
  cd /tmp
  wget -q --no-check-certificate -O /tmp/ipshare_openwrt.sh $BASE_URL/ipshare_openwrt.sh
  if [ -f "/tmp/ipshare_openwrt.sh" ]; then
    init_conf $USERNAME
    sed -i s%^WORK_DIR=.*%WORK_DIR=\"$WORK_DIR\"% /tmp/ipshare_openwrt.sh
    sed -i s%^SAVE_DIR=.*%SAVE_DIR=\"$SAVE_DIR\"% /tmp/ipshare_openwrt.sh
    #sed -i s%^USERNAME=.*%USERNAME=\"$USERNAME\"% /tmp/ipshare_openwrt.sh
    mkdir -p $SAVE_DIR
    mv -f /tmp/ipshare_openwrt.sh $SAVE_DIR/ipshare_openwrt.sh
    chmod +x $SAVE_DIR/ipshare_openwrt.sh
    sh $SAVE_DIR/ipshare_openwrt.sh start
  fi
}

uninstall()
{
  echo "uninstalling ipshare"
  killall -9 ipshare
  rm -rf $SAVE_DIR
  rm -rf $WORK_DIR
  rm -f $CONF_FILE
  rm -f /etc/init.d/ipshare_openwrt
  rm -f /etc/rc.d/S99ipshare_openwrt
  rm -f /etc/rc.d/K10ipshare_openwrt
  if [ -f "/etc/crontabs/root" ]; then
    sed -i /ipshare_openwrt.*.sh/d /etc/crontabs/root
  fi
  echo "done"
}

$*