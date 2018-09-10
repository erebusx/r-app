#!/bin/sh
rm -f /etc/storage/17ce/17ce_padavan_ins.sh
wget --no-check-certificate -O /etc/storage/17ce/17ce_padavan_ins.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_padavano.sh 2>/dev/null  >/dev/null
chmod +x /etc/storage/17ce/17ce_padavan_ins.sh
rm -f /etc/storage/17ce/17ce_padavan_tmp.sh