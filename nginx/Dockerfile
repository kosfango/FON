FROM nginx:latest
RUN usermod -a -G www-data nginx 
RUN mkdir -p /var/www/vhosts/wfido && chown -R nginx:nginx /var/www/vhosts/wfido