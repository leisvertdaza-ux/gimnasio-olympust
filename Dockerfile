FROM php:8.2-apache

# Instalar extensiones necesarias para bases de datos
RUN docker-php-ext-install pdo pdo_mysql

# Habilitar el módulo rewrite de Apache
RUN a2enmod rewrite

# Copiar todos tus archivos dentro del servidor
COPY . /var/www/html/

# MOVER EL ARCHIVO PRINCIPAL A LA RAÍZ:
# Copiamos app.php desde la carpeta con tilde directamente a la raíz de Apache
RUN cp /var/www/html/p*blico/app.php /var/www/html/index.php 2>/dev/null || cp /var/www/html/p*blico/app.php /var/www/html/app.php

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
