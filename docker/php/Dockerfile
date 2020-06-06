ARG PHP_VERSION=7.4

###########################################################################
# Build Container:
###########################################################################

FROM php:${PHP_VERSION}-fpm as php-fpm-build
ARG BACKEND_NGINX_PORT=8081 
ARG APP_GROUP_NAME="app"
ARG PHP_SOCKET_DIR=/socket
ARG PHP_SOCKET_FILE=app.sock

# Get gomplate (https://docs.gomplate.ca/)
COPY --from=hairyhenderson/gomplate:v2.5.0-slim /gomplate /bin/gomplate
COPY docker/php/php-fpm.d ./php-fpm.d

RUN /bin/gomplate --input-dir=./php-fpm.d --output-dir=/usr/local/etc/php-fpm.d

###########################################################################
# Base Image:
###########################################################################

FROM php:${PHP_VERSION}-fpm as php-fpm

# Socket settings and user add
ARG BACKEND_NGINX_PORT=8081 
ARG APP_GROUP_NAME="app"
ARG PHP_SOCKET_DIR=/socket
ARG PHP_SOCKET_FILE=app.sock
ARG APP_GROUP_NAME="app"
ARG APP_GROUP_ID=2001

RUN addgroup --gid ${APP_GROUP_ID} --system ${APP_GROUP_NAME}
RUN adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "$APP_GROUP_NAME" \
    --no-create-home \
    --uid "$APP_GROUP_ID" \
    "$APP_GROUP_NAME"

COPY --from=php-fpm-build /usr/local/etc/php-fpm.d /usr/local/etc/php-fpm.d

###########################################################################
# Language SETTINGS
###########################################################################

RUN apt-get update \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	&& update-locale LANG=en_US.UTF-8

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

###########################################################################
# TIMEZONE SETTINGS
###########################################################################

ARG TIMEZONE

RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini
RUN "date"

###########################################################################
# INSTALL APPLICATIONS AND PHP EXTENSIONS
###########################################################################

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      openssl \
      vim \
      nano \
      supervisor \
      procps \
      screen \
      curl \
      sudo \
      git \
      zip unzip \
      htop \
      sudo \
    && install-php-extensions \
      bcmath \
      bz2 \
      calendar \
      exif \
      gd \
      intl \
      ldap \
      memcached \
      mysqli \
      opcache \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      redis \
      soap \
      xsl \
      zip \
      sockets\
      apcu \
      imap \
      imagick \
      mongodb \
      amqp \
      xdebug\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

###########################################################################
# XDEBUG Settings
###########################################################################

RUN echo "xdebug.idekey = ${DOMAIN}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.default_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_autostart = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port = 9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_host = $(getent hosts docker.for.mac.localhost | awk '{ print $1 }')" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

###########################################################################
# Install Node, Yarn, Puppeteer
###########################################################################

ARG NODE_VERSION
RUN apt-get update && \
    sudo apt-get install -y --no-install-recommends gnupg && \
    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo bash - && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends nodejs && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends yarn;

RUN apt-get install -y nodejs gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget
RUN npm install --global --unsafe-perm puppeteer
RUN chmod -R o+rx /usr/lib/node_modules/puppeteer/.local-chromium

###########################################################################
# Composer and Packages
###########################################################################

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

# Install (composer plugin).
RUN composer global require hirak/prestissimo && \
    composer global require bamarni/symfony-console-autocomplete && \
    rm -rf ~/.composer/cache

# Install Symfony Cli.
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

###########################################################################
# Configuration
###########################################################################

# PATH updating
ENV PATH="$PATH:./vendor/bin:~/.composer/vendor/bin"
RUN sed -i 's#/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin#/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:./vendor/bin:~/.composer/vendor/bin#g' /etc/sudoers

# .bashrc updating

RUN echo 'eval "$(symfony-autocomplete)"' > ~/.bash_profile

RUN { \
        echo "alias ls='ls --color=auto'"; \
        echo "alias ll='ls --color=auto -alF'"; \
        echo "alias la='ls --color=auto -A'"; \
        echo "alias l='ls --color=auto -CF'"; \
    } >> ~/.bashrc

# Add Alias
RUN echo 'alias ci="composer install"' >> ~/.bashrc
RUN echo 'alias sf="php bin/console"' >> ~/.bashrc
RUN echo 'alias sfr="php bin/console debug:router"' >> ~/.bashrc

###########################################################################
# Finish
###########################################################################

ARG APP_CODE_DIR='/var/www/app'

WORKDIR ${APP_CODE_DIR}