FROM php:8.2-apache

RUN docker-php-ext-install pdo pdo_mysql
RUN a2enmod rewrite

COPY . /var/www/html/

# Usamos p*blico con asterisco para evitar problemas con la tilde en Linux
RUN sed -i 's|/var/www/html|/var/www/html/p*blico|g' /etc/apache2/sites-available/000-default.conf
RUN echo "DirectoryIndex app.php" >> /etc/apache2/apache2.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
