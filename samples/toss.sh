#!/bin/sh

perl /usr/local/fido/lib/sql2pkt.pl
hpt toss afix
hpt pack
htick toss
#htick announce
htick ffix
htick scan
hpt scan

touch /tmp/flag_link
/usr/local/fido/lib/xml2sql.pl > /dev/null
rm /tmp/flag_link



