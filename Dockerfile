FROM alpine:edge

# Install what we need
RUN apk --update add git \
    nginx \
    php5-fpm \
    php5-gd \
    php5-pdo_mysql \
    php5-openssl \
    php5-json \
    php5-exif \
    supervisor

# Install Sonerezh
RUN git clone --branch 1.1.1 --depth 1 https://github.com/Sonerezh/sonerezh.git /var/www/sonerezh && \
    chmod 775 -R /var/www/sonerezh

# Prepare volume
RUN mkdir /music /thumbnails && \
    ln -s /var/www/sonerezh/app/webroot/img/thumbnails /thumbnails

VOLUME /music
VOLUME /thumbnails

# Copy image configuration
RUN rm -f /etc/nginx/sites-enabled/default && \
    mkdir /run/nginx && \
    chmod -R 777 /var/www/sonerezh/app/tmp/* && \
    chmod 777 /var/www/sonerezh/app/Config && \
    chmod 777 /var/www/sonerezh/app/Config/core.php && \
    chmod 777 /thumbnails
COPY database.php /var/www/sonerezh/app/Config/database.php
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php5/php-fpm.conf
COPY supervisord.conf /etc/supervisord.conf
COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
