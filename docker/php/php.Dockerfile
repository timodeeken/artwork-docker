FROM php:8.2-fpm-bullseye
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN sed -i 's/bullseye\/updates/bullseye-security/g' /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y  \
    multitail  \
    zlib1g-dev \
    gnupg \
    ca-certificates \
    libicu-dev \
    g++  \
    libpq-dev  \
    libssl-dev  \
    htop  \
    wget \
    nano \
    git \
    unzip \
    libxml2-dev \
    libpng-dev \
    libxslt-dev \
    imagemagick\
    libmagickwand-dev \
    ldap-utils \
    libldb-dev \
    libldap2-dev \
    gettext  \
    libzip-dev  \
    locales  \
    locales-all \
    python3 \
    python3-pip \
    libc-client-dev \
    libkrb5-dev \
     libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-install gettext  \
    && docker-php-ext-install dom  \
    && docker-php-ext-install intl   \
    && docker-php-ext-install ldap   \
    && docker-php-ext-install zip   \
    && docker-php-ext-install simplexml    \
    && docker-php-ext-install sysvsem    \
    && docker-php-ext-install pcntl     \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli  \
    && docker-php-ext-install sockets  \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && pecl install redis imagick && docker-php-ext-enable redis imagick

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap

RUN pip3 install yacron

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/zz-custom-php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN git clone https://github.com/artwork-software/artwork.git .

RUN composer install
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update && apt-get install -y nodejs

COPY ./docker/php/schedule.yaml /var/www/html/schedule.yaml

RUN npm install
#first dev because soketi will not run without
RUN npm run --cache /tmp/ dev
RUN npm run --cache /tmp/ prod

RUN chown -R www-data:www-data /var/www/html

