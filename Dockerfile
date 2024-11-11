FROM php:8.0-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files first
COPY composer.json composer.lock ./

# Set permissions for composer
RUN chown -R www-data:www-data .
USER www-data

# Install dependencies
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application code
USER root
COPY . .

# Set proper permissions
RUN chown -R www-data:www-data .

# Generate autoload files and optimize
USER www-data
RUN composer dump-autoload --optimize

# Switch back to root for Apache
USER root

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]