FROM php:8.2-apache

# Instalar extensiones necesarias para bases de datos
RUN docker-php-ext-install pdo pdo_mysql

# Habilitar el módulo rewrite de Apache
RUN a2enmod rewrite

# Copiar todos tus archivos dentro del servidor
COPY . /var/www/html/

# BUSCAR Y MOVER EL ARCHIVO PRINCIPAL:
# Este comando busca app.php de forma automática y lo copia como index.php en la raíz
RUN find /var/www/html -name "app.php" -exec cp {} /var/www/html/index.php \;

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
