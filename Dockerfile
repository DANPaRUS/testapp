FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    curl \
    g++ \
    git \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libmagickwand-dev \
    libreadline-dev \
    libzip-dev \
    sudo \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

RUN docker-php-ext-install sockets

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-install pdo pdo_pgsql pgsql

RUN pecl install imagick
RUN docker-php-ext-enable imagick

RUN docker-php-ext-install zip

RUN echo "ServerName laravel-app.local" >> /etc/apache2/apache2.conf

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod rewrite headers

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer



#COPY --from=php:8.1-apache  /usr/local/etc/php/php.ini-development /var/www/html/.docker/php/custom.ini

#ARG SSH_PRIVATE_KEY
#RUN mkdir /root/.ssh/
#RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
#RUN chmod 600 /root/.ssh/*
#RUN ssh-keyscan github.com >> /root/.ssh/known_hosts


#RUN docker-php-ext-install mysql && docker-php-ext-enable mysql

#RUN docker-php-ext-install \
#    bcmath \
#    bz2 \
#    calendar \
#    iconv \
#    intl \
#    mbstring \
#    opcache \
#    pdo_mysql \
#    zip


#ARG uid
#RUN useradd -G www-data,root -u $uid -d /home/devuser devuser
#RUN mkdir -p /home/devuser/.composer && \
#    chown -R devuser:devuser /home/devuser

#RUN docker-php-ext-install composer && docker-php-ext-enable composer

#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
