
Required
=============
- docker :)
- Docker Network (docker network create public, docker network create nginx)
- traefik (external network:public)

Install
=============
- repo clone
- .env.dist file rename .env
- .env file change parameters
- First install: make ssl-start-mac (Mac Os)
- First install: make ssl-start (Other Os)
- /etc/hosts files add (domain, pma.domain, me.domain...)


Make commands
=============
- make build (docker-compose build --no-cache)
- make start (docker-compose up -d)
- make stop (docker-compose stop)
- make down (docker-compose down)
- make restart (docker-compose stop && docker-compose build up -d)
- make ssl-start (Ssl certificate add trustRoot and make restart)
- make ssl-start-mac (For macos Ssl certificate add trustRoot and make restart)
- make ssl-refresh (Delete old ssl certificate and ssl-start command)
- make clear (bash clear)
- make php (docker-compose exec php bash)
- make nginx (docker-compose exec nginx bash)


Urls and Options 
=============
PhpMyAdmin :  pma.domain
Mongo, MongoExpress rabbitmq, languagetool add docker-compose-mongo.yml 
RabbitMQ interface :  ra.domain
MongoExpress interface : me.domain

Infos
=============
#### Docker Image
- Php-fpm: Debian
- Nginx: Alpine

#### Php-fpm Applications
- openssl 
- vim 
- nano 
- supervisor 
- procps 
- screen  
- curl 
- git 
- zip 
- htop
- sudo
- node
- npm
- yarn
- puppeteer
- composer
- Symfony Cli (sample: symfony new my_project_name --full)

#### Php extensions
- bcmath
- bz2
- calendar
- exif
- gd
- intl
- ldap
- memcached
- mysqli
- opcache
- pdo_mysql
- pdo_pgsql
- pgsql
- redis
- soap
- xsl
- zip
- sockets
- apcu
- imap
- imagick
- mongodb
- amqp
- xdebug

#### Bash alias
`docker-compose exec php bash`
- ls (ls --color=auto)
- ll ('ls --color=auto -alF)
- la ('ls --color=auto -A)
- l (ls --color=auto -CF')
- ci (composer install)
- sf (php bin/console)
- sfr (php bin/console debug:router)