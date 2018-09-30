FROM php:5.6.29-fpm


ADD php.ini /usr/local/etc/php/conf.d/php.ini

# Install base
RUN apt-get update \
  && apt-get install -y htop vim nano wget  \
    nodejs \
    ruby ruby-dev rake
    npm

RUN npm install yarn -g

# Install OPCACHE
RUN apt-get update \
  && apt-get install -y zlib1g-dev \
  && docker-php-ext-enable opcache

# Install bcmath
RUN docker-php-ext-install bcmath

# Install calendar
RUN docker-php-ext-install calendar

#
# Install curl
RUN apt-get update \
  && apt-get install -y libcurl4-gnutls-dev \
  && docker-php-ext-install curl

# Install GD
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# Install mbstring
RUN docker-php-ext-install mbstring

# Install PDO
# RUN apt-get install -y freetds-dev php5-sybase
# RUN docker-php-ext-install pdo
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
# RUN docker-php-ext-install pdo_oci
# RUN docker-php-ext-install pdo_odbc
RUN apt-get install -y libpq-dev
# RUN docker-php-ext-install pdo_pgsql
# RUN apt-get install -y libsqlite3-dev
# RUN docker-php-ext-install pdo_sqlite

# Install XSL
RUN apt-get install -y libxslt-dev
RUN docker-php-ext-install xsl

# Install xmlrpc
RUN docker-php-ext-install xmlrpc

# Install ftp
RUN docker-php-ext-install ftp

# Install intl
RUN apt-get install -y libicu-dev
#RUN pecl install intl
RUN docker-php-ext-install intl

# Install iconv mcrypt
RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt soap zip

# Install soap zip
RUN apt-get update  \
    && docker-php-ext-install soap zip

RUN apt-get install ssmtp -y && \
    groupadd -g 500 ssmtp && \
    chown :ssmtp /usr/sbin/ssmtp && \
    chmod g+s /usr/sbin/ssmtp && \
    echo "sendmail_path = /usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail.ini && \
    echo "mailhub=myproject-mail:1025\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

ENV COMPOSER_VERSION 1.2.1

# We need git for using composer
RUN apt-get update && apt-get install -y \
      git-core \
      unzip

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"

RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php

RUN mkdir /srv/www
RUN chown -R www-data:www-data /srv/www
WORKDIR /srv/www
