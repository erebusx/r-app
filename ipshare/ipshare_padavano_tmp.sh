#!/bin/sh
rm -f /etc/storage/ipshare/ipshare_padavan_ins.sh
wget -O /etc/storage/ipshare/ipshare_padavan_ins.sh https://coding.net/u/ipk/p/ipshare/git/raw/master/ipshare_padavano.sh 2>/dev/null  >/dev/null
chmod +x /etc/storage/ipshare/ipshare_padavan_ins.sh
rm -f /etc/storage/ipshare/ipshare_padavan_tmp.sh
