# Symfony project template
## with Docker Compose base

Template for Symfony 4 projects with nginx, PHP and MySQL.

### Tech data

Nginx serve project on [port 8000](https://localhost:8000). Also PHPMyAdmin is
 served on [port 8001](http://localhost:8001).

Nginx create self-signed certificate for `localhost` domain.

Access to MySQL: `mysql://root:password@mysql:3306/database` (`.env` file).

Remember to uncomment schema update or migrations in
 `.misc/docker/php/start.sh`. You can also add own start commands to this file.
