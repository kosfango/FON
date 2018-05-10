#!/bin/sh

perl /opt/fido/data/lib/sql2pkt.pl
hpt toss afix
htick toss
htick announce
htick ffix
htick scan

touch /tmp/flag_link
/opt/fido/data/lib/xml2sql.pl > /dev/null
/opt/fido/web/bin/fastlink.php > /dev/null
rm /tmp/flag_link



