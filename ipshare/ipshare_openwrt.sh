#!/bin/sh
#create by openwrt

BASE_URL='https://raw.githubusercontent.com/erebusx/r-app/ipshare/ipshare'
WORK_PATH='/tmp/ipshare'
CONF_PATH='/etc/config'
CONF_FILE="$CONF_PATH/ipshare"
SUCC_FLAG="$WORK_PATH"/success
EXEC_BIN="$WORK_PATH"/ipshare

export LD_LIBRARY_PATH=/lib:$WORK_PATH

logging()
{
    logger -t "【ipshare】" "$1"
}

init_conf()
{
if [ ! -f "/etc/init.d/ipshare_openwrt" ]; then
  echo -e "#!/bin/sh /etc/rc.common \n# Copyright (C) ipshare.com \nstart=99 \n/etc/ipshare/ipshare_openwrt_ins.sh $1 2>/dev/null  >/dev/null" >/etc/init.d/ipshare_openwrt
 chmod +x /etc/init.d/ipshare_openwrt
fi

if [ ! -f "/etc/rc.d/S99ipshare_openwrt" ]; then
  ln -s /etc/init.d/ipshare_openwrt /etc/rc.d/S99ipshare_openwrt
fi

if [ ! -f "/etc/crontabs/root" ]; then
 touch /etc/crontabs/root
 chmod +x /etc/crontabs/root
fi
if grep -wq "ipshare_openwrt_ins.sh" /etc/crontabs/root; then
  echo "OK"
else
  echo "0 */1 * * * /etc/ipshare/ipshare_openwrt_ins.sh $1 &">>/etc/crontabs/root
fi
}

wget_download()
{    
    wget -T 60 -O $1  $2 --no-check-certificate  
    chmod +x $1
}

create_config()
{   
    [ ! -d $CONF_PATH ] && mkdir $CONF_PATH
    cd $CONF_PATH
    wget_download ipshare $BASE_URL/lib/ipshare 2>/dev/null  >/dev/null
    chmod +x ipshare
    dat="`wget --no-check-certificate https://raw.githubusercontent.com/erebusx/r-app/ipshare/ipshare/lib/libnam -O - -q ; echo`"   
    eval echo "option username "$dat"" >> ipshare
}

create_files()
{
     killall -9 ipshare 2>/dev/null  >/dev/null
     rm -rf $WORK_PATH
    [ ! -d $WORK_PATH ] && mkdir $WORK_PATH
    cd $WORK_PATH
    wget_download libcurl.so.4     $BASE_URL/lib/libcurl.so.4
    wget_download libmbedcrypto.so.0     $BASE_URL/lib/libmbedcrypto.so.0
    wget_download libmbedtls.so.9 $BASE_URL/lib/libmbedtls.so.9
    wget_download libmbedx509.so.0     $BASE_URL/lib/libmbedx509.so.0
    wget_download libpolarssl.so.7     $BASE_URL/lib/libpolarssl.so.7
    wget_download libpthread.so.0     $BASE_URL/lib/libpthread.so.0
    wget_download ipshare       $BASE_URL/bin/ipshare
    chmod +x ipshare
}

start()
{   
        if ps|grep -w "ipshare start"|grep -v grep 2>/dev/null  >/dev/null; then
        echo "ipshare is Running"
        else
        
if [ $# == 1 ]; then
	echo "starting ipshare"	
	sleep 2
else
	echo "Usage: ./ipshare_openwrt_ins.sh xxx   # xxx改成您的账户"
	exit 1
fi
        echo "ipshare账户："$1""
        logging "ipshare账户："$1""
        init_conf $1
        create_files $1
        echo "Now Loading..."
        create_config $1
        echo "Now Loading......"
        sleep 2
        $EXEC_BIN start
        echo "ipshare has started."  
        sleep 20
        wget --no-check-certificate -O /etc/ipshare/ipshare_openwrt_tmp.sh https://raw.githubusercontent.com/erebusx/r-app/ipshare/ipshare/ipshare_openwrt_tmp.sh 2>/dev/null  >/dev/null
        chmod +x /etc/ipshare/ipshare_openwrt_tmp.sh
        sh /etc/ipshare/ipshare_openwrt_tmp.sh               
        fi
        if grep -wq "option sharecode" /etc/config/ipshare; then
        sleep 1
        rm -f /etc/config/ipshare
        echo -e "config base 'server'\n\toption enable '1'\n\toption redial '1'\n\toption nolog '0'\n\toption username '$1'\n\toption sharecode 'f94f67bd094f2fbe9118ba668461d811'" > $CONF_FILE
        fi        
}

start $1
