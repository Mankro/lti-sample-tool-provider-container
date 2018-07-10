FROM php:7.2.5-apache-stretch
# FROM php:7-apache # alias that may point to the current latest version

# enable PDO MySQL that is used by the LTI TP Sample app
RUN docker-php-ext-install -j$(nproc) pdo_mysql

# xdebug for debugging
#RUN pecl install xdebug-2.6.0 \
#  && docker-php-ext-enable xdebug \
#  && echo "xdebug.remote_enable=on"     >> /usr/local/etc/php/conf.d/xdebug.ini \
#  && echo "xdebug.idekey=xdebug"        >> /usr/local/etc/php/conf.d/xdebug.ini


# Install the zip PHP extension (for composer)
RUN apt-get update -qqy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
        zlib1g-dev \
  && docker-php-ext-install zip \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*


# PHP code of the LTI Sample Tool Provider
# install git for downloading the repository and then uninstall git
RUN apt-get update -qqy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
        git-core \
  && cd /var/www/html/ \
  && git clone https://github.com/IMSGlobal/LTI-Sample-Tool-Provider-PHP.git \
  && mv LTI-Sample-Tool-Provider-PHP/src/* /var/www/html/ \
  && rm -rf LTI-Sample-Tool-Provider-PHP \
  && apt-get remove -qqy git \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# local configuration - copy the config.php file
COPY config.php /var/www/html/config.php


# install composer and then the dependencies of the project
RUN cd /var/www/html/ \
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified' . PHP_EOL; } else { echo 'Installer corrupt' . PHP_EOL; unlink('composer-setup.php'); exit(1); }" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && php composer.phar install

