FROM php:8.2-apache

RUN docker-php-ext-install pdo pdo_mysql
RUN a2enmod rewrite

COPY . /var/www/html/

# Configuramos la carpeta y le decimos que busque app.php en lugar de index.php
RUN sed -i 's|/var/www/html|/var/www/html/público|g' /etc/apache2/sites-available/000-default.conf
RUN echo "DirectoryIndex app.php" >> /etc/apache2/apache2.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
