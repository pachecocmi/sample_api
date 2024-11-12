FROM php:8.2-apache

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
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd
RUN a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy only the composer files first
COPY composer.json composer.lock ./

# Install dependencies without scripts
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application
COPY . .

# Run composer scripts and generate autoloader
RUN composer dump-autoload --optimize

# Configure Apache DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html/storage -type d -exec chmod 775 {} \; && \
    find /var/www/html/storage -type f -exec chmod 664 {} \; && \
    chmod -R 775 /var/www/html/bootstrap/cache && \
    chmod -R 775 /var/www/html/storage && \
    chown -R www-data:www-data /var/www/html/storage && \
    chown -R www-data:www-data /var/www/html/bootstrap/cache

# Create the bootstrap/cache directory if it doesn't exist
RUN mkdir -p /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html/bootstrap/cache

# Additional storage directory setup
RUN mkdir -p /var/www/html/storage/framework/{sessions,views,cache} && \
    mkdir -p /var/www/html/storage/logs && \
    chown -R www-data:www-data /var/www/html/storage/framework && \
    chown -R www-data:www-data /var/www/html/storage/logs

# Make sure the apache user has the right permissions
RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]