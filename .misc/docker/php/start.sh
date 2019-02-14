#!/usr/bin/env bash

composer install

wait-for-it mysql:3306 -t 600
#bin/console doctrine:schema:update --force --no-interaction
#bin/console doctrine:migrations:migrate --no-interaction

php-fpm
