#!/bin/sh

mkdir -p /opt/fido/etc/php
mkdir -p /opt/fido/etc/nginx
mkdir -p /opt/fido/data/tmp/in
mkdir -p /opt/fido/data/tmp/out
mkdir -p /opt/fido/data/lib
mkdir -p /opt/fido/data/etc
mkdir -p /opt/fido/mysql
mkdir -p /opt/fido/web
mkdir -p /opt/fido/var/run
mkdir -p /opt/fido/data/var/xml/archive
mkdir -p /opt/fido/data/inbound
mkdir -p /opt/fido/data/insecure
mkdir -p /opt/fido/data/outbound
mkdir -p /opt/fido/data/msg/dupe
mkdir -p /opt/fido/data/log

cp -R ./samples/binkd/* /opt/fido/etc/
cp -R ./samples/nginx/* /opt/fido/etc/nginx
cp -R ./samples/php-fpm/* /opt/fido/etc/php
cp -R ./samples/husky/* /opt/fido/data/etc

docker-compose -f ./docker-compose.yml up --build -d
docker exec -ti fido_node /root/devel/deploy.sh

#Entering variables
read -p 'Please enter your First Name: ' namevar
read -p 'Please enter your Second Name: ' surnamevar
read -p 'Please enter your Fidonet node address (4D format): ' nodeaddrrvar
read -p 'Please enter your station name: ' stnamevar
read -p 'Please enter location of your station (e.g.: Kostroma, Russia): ' locvar
read -p 'Please enter WFIDO domain name for your station: ' wfidovar
read -sp 'Please enter password for .1 point: ' passvar
echo " "

#Uplink
read -p 'Please enter uplink First Name: ' upnamevar
read -p 'Please enter uplink Second Name: ' upsurnamervar
read -p 'Please enter your uplink address 4D format: ' upnodeaddrrvar
read -p 'Please enter your uplink domain name or IP: ' upnodehostvar
read -sp 'Please enter password for your uplink: ' uppassvar
echo " "

#Editing fido config
sed -i "s/Sergey Anohin/$namevar $surnamevar/g" /opt/fido/data/etc/config
sed -i "s#2:5034\/17#$nodeaddrrvar#" /opt/fido/data/etc/config
sed -i "s/TEST Station/$stnamevar/g" /opt/fido/data/etc/config
sed -i "s/Kostroma, Russia/$locvar/g" /opt/fido/data/etc/config

#Editing links config
sed -i "s#2:5034\/17#$nodeaddrrvar#" /opt/fido/data/etc/links
sed -i "s#2:5034\/17.1#${nodeaddrrvar}.1#" /opt/fido/data/etc/links
sed -i "s/BOSS/$upnamevar $surnamevar/" /opt/fido/data/etc/links
sed -i "s#2:5034\/17.0@fidonet#${nodeaddrrvar}.0@fidonet#" /opt/fido/data/etc/links
sed -i "s#2:5034\/10#$upnodeaddrrvar#" /opt/fido/data/etc/links
sed -i "s/yourpassword/$uppassvar/g" /opt/fido/data/etc/links
sed -i "s/pointpassword/$passvar/g" /opt/fido/data/etc/links
sed -i "s#link Sergey Anokhin#link $namevar $surnamevar#" /opt/fido/data/etc/links

#Editing route config
sed -i "s#2:5034\/10#$upnodeaddrrvar#" /opt/fido/data/etc/route
sed -i "s#2:5034\/17.\*#${nodeaddrrvar}.\*#" /opt/fido/data/etc/route

#Editing binkdconfig
sed -i "s#2:5034\/17@fidonet#${nodeaddrrvar}@fidonet#" /opt/fido/etc/binkd.conf
sed -i "s/TEST Station/$stnamevar/g" /opt/fido/etc/binkd.conf
sed -i "s/Kostroma, Russia/$locvar/g" /opt/fido/etc/binkd.conf
sed -i "s#Sergey Anohin#${namevar} ${surnamervar}#" /opt/fido/etc/binkd.conf
sed -i "s#2:5034\/10@fidonet#${upnodeaddrrvar}@fidonet#" /opt/fido/etc/binkd.conf
sed -i "s/5034.ru/$upnodehostvar/g" /opt/fido/etc/binkd.conf
sed -i "s/bosspassword/$uppassvar/g" /opt/fido/etc/binkd.conf
sed -i "s#2:5034\/17.1@fidonet#${nodeaddrrvar}.1@fidonet#" /opt/fido/etc/binkd.conf
sed -i "s/yourpassword/$passvar/g" /opt/fido/etc/binkd.conf

#Edititng toss script
#sed -i "s/\/home\/fidonet\/bin\/sql2pkt.pl/\/opt\/fido\/data\/lib\/sql2pkt.pl/g" /opt/fido/data/lib/toss.sh
#sed -i "s/\/home\/fidonet\/bin\/hpt/\/opt\/fido\/data\/lib\/hpt/g" /opt/fido/data/lib/toss.sh
#sed -i "s/\/home\/fidonet\/bin\/xml2sql.pl/\/opt\/fido\/data\/lib\/xml2sql.pl/g" /opt/fido/data/lib/toss.sh
#sed -i "s/\/var\/www\/wfido\/bin\/fastlink.php/\/opt\/fido\/web\/bin\/fastlink.php/g" /opt/fido/data/lib/toss.sh

#Editing wfido vhost config file
sed -i "s/server_name wfido.net;/server_name ${wfidovar};/g" /opt/fido/etc/nginx/wfido.conf

#Web interface
mv /opt/fido/web/search_mysql.php /opt/fido/web/search.php

sed -i 's|$mywww="http://vds.lushnikov.net/wfido";|$mywww="http://'${wfidovar}'";|g' /opt/fido/web/config.php
sed -i 's|$adminmail="max@lushnikov.net";|$adminmail="support@'${wfidovar}'";|g' /opt/fido/web/config.php
sed -i 's/$webroot=.*/$webroot="";/g' /opt/fido/web/config.php
sed -i 's|$mynode="2:5020/1519";|$mynode="'${nodeaddrrvar}'";|g' /opt/fido/web/config.php

sed -i 's/$sql_base=.*/$sql_base="wfido";/g' /opt/fido/web/config.php
sed -i 's/$sql_host=.*/$sql_host="\:\/var\/run\/mysqld\/mysqld\.sock";/g' /opt/fido/web/config.php
sed -i 's/$sql_user=.*/$sql_user="wfido";/g' /opt/fido/web/config.php
sed -i 's/$sql_pass=.*/$sql_pass="PASSWORD";/g' /opt/fido/web/config.php

#Editing perl scripts
sed -i "s#$inbound='/home/fidonet/var/fidonet/inbound/';#$inbound='/usr/local/fido/inbound/';#" /opt/fido/data/lib/sql2pkt.pl
sed -i "s#$mynode='2:5020/1519';#$mynode='"$nodeaddrrvar"';#g" /opt/fido/data/lib/sql2pkt.pl
sed -i "s#$my_tech_link='2:5020/1519';#$my_tech_link='"$nodeaddrrvar"';#g" /opt/fido/data/lib/sql2pkt.pl
sed -i 's#$sql_user="USER";#$sql_user="wfido";#g' /opt/fido/data/lib/sql2pkt.pl
sed -i 's#$sql_pass="PASS";#$sql_pass="PASSWORD";#g' /opt/fido/data/lib/sql2pkt.pl
sed -i 's#$xml_spool="/home/fidonet/var/fidonet/xml";#$xml_spool="/usr/local/fido/fido/xml";#g' /opt/fido/data/lib/xml2sql.pl
sed -i 's#$sql_user="USER";#$sql_user="wfido";#g' /opt/fido/data/lib/xml2sql.pl
sed -i 's#$sql_pass="PASS";#$sql_pass="PASSWORD";#g' /opt/fido/data/lib/xml2sql.pl

sed -i 's/use Digest::Perl::MD5/use Digest::MD5/g' /opt/fido/data/lib/xml2sql.pl
sed -i 's/\$sql_host="127.0.0.1";/\$sql_sock="\/var\/lib\/mysql\/mysql.sock";/g' /opt/fido/data/lib/xml2sql.pl
sed -i 's/host=\$sql_host"/mysql_socket=\$sql_sock"/g' /opt/fido/data/lib/xml2sql.pl
sed -i 's/\$sql_host="127.0.0.1";/\$sql_sock="\/var\/lib\/mysql\/mysql.sock";/g' /opt/fido/data/lib/sql2pkt.pl
sed -i 's/host=\$sql_host"/mysql_socket=\$sql_sock"/g' /opt/fido/data/lib/sql2pkt.pl


#Tossing script
cp ./samples/toss.sh /opt/fido/data/lib/toss.sh

docker restart fido_node