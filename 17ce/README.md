#17ce for ��ë��padavan��

```
cd /tmp
rm  -rf 17ce_padavan_ins.sh
wget -O 17ce_padavan_ins.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_padavan_ins.sh
chmod +x 17ce_padavan_ins.sh
./17ce_padavan_ins.sh xxx    (xxx�ĳ������û���)
```

#17ce for Openwrt������PandoraBox��DreamBox��LEDE���ſ�·�ɱ���С��·�ɡ���·�ɡ���·�ɡ��Ѷ·�ɵȵȣ���

```
opkg update
opkg install wget
cd /tmp
rm  -rf 17ce_openwrt_ins.sh
wget --no-check-certificate -O 17ce_openwrt_ins.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_openwrt_ins.sh
chmod +x 17ce_openwrt_ins.sh
./17ce_openwrt_ins.sh xxx    (xxx�ĳ������û���)