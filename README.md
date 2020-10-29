# FIDONET-ONECLICK
# Experimental project for automatically deployment of FIDONET software using Docker and Docker-compose

Run main_script.sh and enjoy!  

Ports usage:  
8080 - nginx  
3307 - mariadb  
24554 - binkd  

Edit your crontab or start this scripts manually:  

docker exec -ti fido_node sh -c /usr/local/fido/lib/poll.sh  
docker exec -ti fon_php-custom_1 php /var/www/vhosts/wfido/bin/fastlink.php

Manual tosser start:  

docker exec -ti fido_node sh -c /usr/local/fido/lib/toss.sh

Default admin credentials for web interface WFIDO:  

login: 1  
password: PASSWORD

REQUIREMENTS:

- Linux
- docker
- docker-compose
- Directory /opt/fido will be created automatically

INCLUDE:

- Husky + Binkd (1 container)
- WFIDO on LEMP stack (3 containers)