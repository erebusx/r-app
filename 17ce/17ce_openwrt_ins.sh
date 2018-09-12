#!/bin/sh
WORK_DIR="/tmp/17ce"
SAVE_DIR="/etc/17ce"

init_conf()
{
  #echo -e "#!/bin/sh /etc/rc.common \n# Copyright (C) 17ce.com \nstart=99 \n$SAVE_DIR/17ce_openwrt_ins.sh $1 2>/dev/null  >/dev/null" >/etc/init.d/17ce_openwrt
  cat <<EOF > /etc/init.d/17ce_openwrt
#!/bin/sh /etc/rc.common
# Copyright (C) 17ce.com
START=99
STOP=10

start()
{
    $SAVE_DIR/17ce_openwrt.sh
}

stop()
{
    killall -9 17ce_v3
    sleep 1
    echo "17ce Client has stoped."
}
EOF
  chmod +x /etc/init.d/17ce_openwrt

  if [ ! -f "/etc/rc.d/S9917ce_openwrt" ]; then
    ln -s /etc/init.d/17ce_openwrt /etc/rc.d/S9917ce_openwrt
    ln -s /etc/init.d/17ce_openwrt /etc/rc.d/K1017ce_openwrt
  fi
  if [ ! -f "/etc/crontabs/root" ]; then
    touch /etc/crontabs/root
    chmod +x /etc/crontabs/root
  fi
  sed -i /17ce_openwrt_ins.sh/d /etc/crontabs/root
  if grep -wq "17ce_openwrt.sh" /etc/crontabs/root; then
    echo "OK"
  else
    echo "0 */1 * * * $SAVE_DIR/17ce_openwrt.sh &">>/etc/crontabs/root
  fi
}

install()
{
  echo "installing 17ce"
  if [ $# == 1 ]; then
    echo "17CE account：$1"
    USERNAME="$1"    
    sleep 2
  else
    echo "Usage: ./17ce_openwrt_ins.sh install xxx@xxx.com"
    USERNAME="40089975@qq.com"
  fi
  echo 
  echo "by 17CE"
  rm -rf $SAVE_DIR
  rm -rf $WORK_DIR
  #rm -f 17ce*
  killall -9 17ce_v3 2>/dev/null  >/dev/null
  cd /tmp
  wget -q --no-check-certificate -O /tmp/17ce_openwrt.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_openwrt.sh
  if [ -f "/tmp/17ce_openwrt.sh" ]; then
    init_conf $1
    sed -i s%^WORK_DIR=.*%WORK_DIR=\"$WORK_DIR\"% /tmp/17ce_openwrt.sh
    sed -i s%^SAVE_DIR=.*%SAVE_DIR=\"$SAVE_DIR\"% /tmp/17ce_openwrt.sh
    sed -i s%^USERNAME=.*%USERNAME=\"$USERNAME\"% /tmp/17ce_openwrt.sh
    mkdir -p $SAVE_DIR
    mv -f /tmp/17ce_openwrt.sh $SAVE_DIR/17ce_openwrt.sh
    chmod +x $SAVE_DIR/17ce_openwrt.sh
    sh $SAVE_DIR/17ce_openwrt.sh
  fi
}

uninstall()
{
  echo "uninstalling 17ce"
  killall -9 17ce_v3
  rm -rf $SAVE_DIR
  rm -rf $WORK_DIR
  rm -rf 17ce*
  rm -f /etc/rc.d/S9917ce_openwrt
  rm -f /etc/rc.d/K1017ce_openwrt
  if [ -f "/etc/crontabs/root" ]; then
    sed -i /17ce_openwrt.*.sh/d /etc/crontabs/root
  fi
  echo "done"
}

$*