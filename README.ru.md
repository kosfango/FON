# FIDONET-ONECLICK
# Экспериментальный проект для быстрого развертывания узла сети FIDONET+веб-интерфейс WFIDO, с использованием Docker и Docker-compose

Запустить скрипт main_script.sh и откинуться на спинку кресла!

Используемые порты:  

8080 - nginx  
3307 - mariadb  
24554 - binkd

Для автоматического получения почты добавьте в cron эти скрипты или запускайте руками:  

docker exec -ti fido_node sh -c /usr/local/fido/lib/poll.sh  
docker exec -ti fon_php-custom_1 php /var/www/vhosts/wfido/bin/fastlink.php

Ручной запуск тоссера:  

docker exec -ti fido_node sh -c /usr/local/fido/lib/toss.sh

Админский аккаунт для веб-интерфейса WFIDO, по умолчанию:  

login: 1  
password: PASSWORD

ТРЕБОВАНИЯ:

- Linux
- docker
- docker-compose
- Directory /opt/fido will be created automatically

ЧТО ВНУТРИ:

- Husky + Binkd (1 container)
- WFIDO on LEMP stack (3 containers)
