FROM php:8.2-apache

# Instalar extensiones necesarias para Laravel (PDO, MySQL, dependencias de string)
RUN docker-php-ext-install pdo pdo_mysql

# Habilitar el módulo de reescritura de Apache para las rutas de Laravel
RUN a2enmod rewrite

# Copiar todos los archivos del proyecto a la raíz del servidor Apache
COPY . /var/www/html/

# CONFIGURACIÓN CRUCIAL DE LARAVEL: 
# Apuntamos Apache directamente a la carpeta 'public' (estándar de Laravel)
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Darle los permisos correctos a Apache sobre las carpetas de Laravel
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
