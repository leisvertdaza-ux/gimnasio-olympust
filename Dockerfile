FROM php:8.2-apache

# 1. Instalar dependencias del sistema y Composer
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 2. Instalar extensiones de PHP indispensables
RUN docker-php-ext-install pdo pdo_mysql

# 3. Habilitar el módulo de reescritura de Apache
RUN a2enmod rewrite

# 4. Copiar todos los archivos del proyecto al servidor
COPY . /var/www/html/

# 5. Instalar dependencias con Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 6. CREAR LA BASE DE DATOS FÍSICA SI NO EXISTE
RUN mkdir -p /var/www/html/database && touch /var/www/html/database/database.sqlite

# 7. Apuntar Apache directamente a la carpeta 'public'
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# 8. Otorgar los permisos correctos a Apache y a la base de datos
RUN chown -R www-data:www-data /var/www/html && chmod -R 775 /var/www/html/storage /var/www/html/database

EXPOSE 80
