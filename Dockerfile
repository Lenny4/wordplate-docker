# the different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG PHP_VERSION=8.2

# "php" stage
FROM wordpress:php${PHP_VERSION}-fpm-alpine AS wordpress_prod

COPY . /var/www/html

WORKDIR /var/www/html

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo_mysql

# prevent the reinstallation of vendors at every changes in the source code
RUN set -eux; \
	composer install --prefer-dist --no-dev --no-scripts --no-progress; \
	composer clear-cache

COPY ./docker/php/prod.ini /usr/local/etc/php/conf.d/custom.ini

FROM wordpress_prod AS wordpress_dev

RUN install-php-extensions xdebug-stable
