FROM php:7.3-fpm
RUN mkdir /var/run/wfido && chown www-data:www-data /var/run/wfido && mkdir /var/log/php-fpm && chown www-data:www-data /var/log/php-fpm
RUN docker-php-ext-install mysqli pdo pdo_mysql
VOLUME ["/var/run/wfido"]
USER www-data
CMD chown www-data:www-data /var/run/wfido && chown www-data:www-data /var/www/vhosts/wfido/
CMD ["php-fpm"]