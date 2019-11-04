FROM php:7.3-fpm

# 添加源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD sources.list /etc/apt/sources.list
RUN apt-get update \
        && apt-get install -y \
        vim\
        supervisor\
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev\
        openssl \
        libssl-dev \
        && docker-php-ext-install -j$(nproc) iconv json bcmath fileinfo mysqli pdo pdo_mysql xml ctype sockets\
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-mongodb-ssl \
        && docker-php-ext-install -j$(nproc) gd \
        # 更新pecl源
        && pecl channel-update https://pecl.php.net/channel.xml 


# phpredis
COPY redis-4.2.0.tgz /home
RUN pecl install /home/redis-4.2.0.tgz && \
        docker-php-ext-enable redis && \
        rm /home/redis-4.2.0.tgz

# xdebug
COPY xdebug-2.8.0beta1.tgz /home
RUN pecl install /home/xdebug-2.8.0beta1.tgz && \
        docker-php-ext-enable xdebug && \
        rm /home/xdebug-2.8.0beta1.tgz

# swoole
COPY swoole-4.4.2.tgz /home
RUN pecl install /home/swoole-4.4.2.tgz && \
        docker-php-ext-enable swoole && \
        rm /home/swoole-4.4.2.tgz

# mongodb
COPY mongodb-1.5.3.tgz /home
RUN pecl install /home/mongodb-1.5.3.tgz && \
        docker-php-ext-enable mongodb && \
        rm /home/mongodb-1.5.3.tgz

# opcache
RUN docker-php-ext-install opcache
#COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

#tideways
COPY php-xhprof-extension  /home/php-xhprof-extension
RUN     (\
        cd /home/php-xhprof-extension  \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
        ) \
        && docker-php-ext-enable tideways_xhprof \
        && rm -r /home/php-xhprof-extension

#php-cp
# COPY php-cp-master /home/php-cp-master

# RUN     (\
#         cd /home/php-cp-master \
#         && phpize && ./configure  &&   make clean && make  && make install \
#         )\
#         && docker-php-ext-enable connect_pool \
#         && mkdir -m 755 /var/log/php-connection-pool \
#         && chmod +x ./pool_server \
#         && cp ./pool_server /usr/local/bin/pool_server


# php配置文件
# ADD php.ini         /usr/local/etc/php/php.ini
# ADD php-fpm.conf    /usr/local/etc/php-fpm.conf
# ADD php-fpm.d    /usr/local/etc/php-fpm.d
# ADD conf.d       /usr/local/etc/php/conf.d
USER root

# 清理
RUN apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        rm /var/log/lastlog /var/log/faillog

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
#EXPOSE 9001