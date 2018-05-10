#!/bin/bash

cd /root/devel
git clone https://github.com/kosfango/wfido.git
cp  /root/devel/wfido/hpt/filter.pl  /usr/local/fido/lib/filter.pl
sed -i 's/# hptperlfile \/home\/username\/fido\/lib\/hptfunctions.pl/hptperlfile \/usr\/local\/fido\/lib\/filter.pl/g' /usr/local/fido/etc/config
sed -i 's/\/home\/fidonet\/var\/fidonet\/xml\/$random_string.xml/\/usr\/local\/fido\/var\/xml\/$random_string.xml/g' /usr/local/fido/lib/filter.pl

cat <<EOF >> /etc/yum.repos.d/mariadb.repo
# MariaDB 10.2 CentOS repository list - created 2018-04-04 10:49 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

EOF

yum update -y && yum install MariaDB-client perl-Digest-MD5 perl-DBD-MySQL perl-Test-Simple.noarch -y 
cd /root/devel/wfido/dependencies
tar -xvzf /root/devel/wfido/dependencies/FTN-Pkt-1.02.tar.gz
cd /root/devel/wfido/dependencies/FTN-Pkt-1.02
perl Makefile.PL && make && make test && make install

sed -i 's/require Exporter;/use Exporter;/g' /usr/local/share/perl5/FTN/Pkt.pm

ln -s /var/run/mysqld/mysqld.sock /var/lib/mysql/mysql.sock

mkdir -p /usr/local/fido/var/xml/archive


mysql -u root -ppassword -e "set global sql_mode='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';"
mysql -u root -ppassword < /root/devel/wfido/dump_install.sql

mkdir -p /var/www/vhosts/wfido && useradd nginx
cp -R /root/devel/wfido/htdocs/* /var/www/vhosts/wfido/
cp -R /root/devel/wfido/scripts/* /usr/local/fido/lib/


#sed -i 's/use Digest::Perl::MD5/use Digest::MD5/g' /usr/local/fido/lib/xml2sql.pl
#sed -i 's/\$sql_host="127.0.0.1";/\$sql_sock="\/var\/lib\/mysql\/mysql.sock";/g' /usr/local/fido/lib/xml2sql.pl
#sed -i 's/host=\$sql_host"/mysql_socket=\$sql_sock"/g' /usr/local/fido/lib/xml2sql.pl

#sed -i 's/\$sql_host="127.0.0.1";/\$sql_sock="\/var\/lib\/mysql\/mysql.sock";/g' /usr/local/fido/lib/sql2pkt.pl
#sed -i 's/host=\$sql_host"/mysql_socket=\$sql_sock"/g' /usr/local/fido/lib/sql2pkt.pl


