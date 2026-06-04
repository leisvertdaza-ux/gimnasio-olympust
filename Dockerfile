FROM php:8.2-apache

# 1. Instalar dependencias del sistema y Composer (necesario para Laravel)
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

# 5. INSTALAR VENDOR: Ejecutar Composer para crear la carpeta que falta
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 6. Apuntar Apache directamente a la carpeta 'public'
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# 7. Asignar los permisos correctos a las carpetas de Laravel
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
