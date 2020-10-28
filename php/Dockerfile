FROM php:7.3-fpm
RUN mkdir /var/run/wfido && chown www-data:www-data /var/run/wfido && mkdir /var/log/php-fpm && chown www-data:www-data /var/log/php-fpm
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
        libmcrypt-dev \
        libpng-dev \
        libjpeg-dev \
        libpng-dev
RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring
VOLUME ["/var/run/wfido"]
USER www-data
CMD chown www-data:www-data /var/run/wfido && chown www-data:www-data /var/www/vhosts/wfido/
CMD ["php-fpm"]