#!/usr/bin/env bash

set -e

function get_database_host {
  proto="$(echo "$1" | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  url="${1/$proto/}"
  user="$(echo "$url" | grep @ | cut -d@ -f1)"
  echo "${url/$user@/}" | cut -d/ -f1
}

# Install Composer vendors in non-prod environments
if [[ ! -d vendor ]]; then
  composer install
fi
# Get DATABASE_URL variable from .env file if not setted before
if [[ -z "$DATABASE_URL" ]]; then
  source .env
fi

wait-for-it $(get_database_host "$DATABASE_URL") -t 60
#php bin/console doctrine:schema:update --force --no-interaction
#php bin/console doctrine:migrations:migrate --no-interaction

nginx
exec "$@"
