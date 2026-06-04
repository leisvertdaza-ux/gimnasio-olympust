FROM php:8.2-apache

# Instalar extensiones necesarias para bases de datos
RUN docker-php-ext-install pdo pdo_mysql

# Habilitar rutas amigables en Apache
RUN a2enmod rewrite

# Copiar todos tus archivos dentro del servidor virtual
COPY . /var/www/html/

# Configurar Apache para que apunte a tu carpeta pública
RUN sed -i 's|/var/www/html|/var/www/html/público|g' /etc/apache2/sites-available/000-default.conf

# Dar permisos de acceso al servidor
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
