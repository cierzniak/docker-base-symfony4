################################################################################
# TARGET IMAGE                                                                 #
# Available targets: prod, dev                                                 #
################################################################################
ARG TARGET=prod

################################################################################
# PHP VERSION                                                                  #
# Check Docker Hub for available versions of fpm-alpine image                  #
################################################################################
ARG PHP_VERSION=7.4

################################################################################
# BASE IMAGE                                                                   #
# Here you should setup PHP environment for production and development         #
################################################################################
FROM php:${PHP_VERSION}-fpm-alpine AS base
RUN apk add --no-cache bash \
 && docker-php-ext-configure opcache --enable-opcache \
 && docker-php-ext-install -j "$(nproc)" pdo_mysql opcache

################################################################################
# VENDORS                                                                      #
################################################################################
FROM base AS vendors
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN apk add --no-cache zip git \
 && wget -O - https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /app/
COPY composer.json composer.lock symfony.lock /app/
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-cache

################################################################################
# DEVELOPMENT TOOLS                                                            #
# Here you should add all tools (Composer included)                            #
################################################################################
FROM vendors AS dev
RUN apk add --no-cache ${PHPIZE_DEPS} \
 && pecl install xdebug \
 && docker-php-ext-enable xdebug

################################################################################
# PRODUCTION CODE                                                              #
################################################################################
FROM base AS prod
COPY --from=vendors /app/vendor/ /app/vendor/
WORKDIR /app/
COPY . /app/
ENV APP_ENV prod
RUN php /app/bin/console cache:clear

################################################################################
# APP IMAGE                                                                    #
################################################################################
FROM ${TARGET}
RUN apk add --no-cache nginx && mkdir -p /run/nginx
COPY _misc/docker/app/config.nginx /etc/nginx/conf.d/default.conf
COPY _misc/docker/app/entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    /usr/local/bin/wait-for-it
RUN chmod +x /usr/local/bin/*

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm"]
