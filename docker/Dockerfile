FROM php:8.2-apache

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql

# Enable rewrite
RUN a2enmod rewrite

# ✅ Fix Apache config properly
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Set Laravel public folder
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

#RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

#changing in k8s 
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf


COPY . .

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer install

RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 storage bootstrap/cache


EXPOSE 80
