#17ce for 老毛子padavan：

```
cd /tmp
rm  -rf 17ce_padavan_ins.sh
wget -O 17ce_padavan_ins.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_padavan_ins.sh
chmod +x 17ce_padavan_ins.sh
./17ce_padavan_ins.sh xxx    (xxx改成您的用户名)
```

#17ce for Openwrt（包含PandoraBox、DreamBox、LEDE、优酷路由宝、小米路由、新路由、极路由、斐讯路由等等）：

```
opkg update
opkg install wget
cd /tmp
rm  -rf 17ce_openwrt_ins.sh
wget --no-check-certificate -O 17ce_openwrt_ins.sh https://raw.githubusercontent.com/erebusx/r-app/17ce/17ce/17ce_openwrt_ins.sh
chmod +x 17ce_openwrt_ins.sh
./17ce_openwrt_ins.sh xxx    (xxx改成您的用户名)