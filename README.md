# Docker for Symfony project template

Template for Symfony projects with nginx, PHP and MySQL (MariaDB).

### Tech data

App is served on port 80, but Compose file hosts project on [port 8000](http://localhost:8000). PhpMyAdmin is served on [port 8001](http://localhost:8001).

Access to MySQL: `mysql://root:s3cret@database:3306/project` (put it in **/.env** file).

Remember to uncomment schema update or migrations in **/.misc/docker/app/entrypoint.sh**. You can also add own start commands to this file.

After each change in **/.misc/docker/** you have to rebuild docker images.
