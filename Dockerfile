FROM php:8.3-apache

# Install Apache mods, SSH, and PHP extensions
RUN apt-get update && apt-get install -y \
    openssh-server \
    libzip-dev zip unzip \
    iputils-ping && \
    docker-php-ext-install pdo pdo_mysql zip \
    && a2enmod rewrite \
    && apt-get clean

# Create required SSH folder
RUN mkdir /var/run/sshd

# Set root password for SSH (CHANGE THIS!)
RUN echo 'root:rootpassword' | chpasswd

# Allow SSH password login
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php  # Clean up the installer

# Expose both web and SSH ports
EXPOSE 80 22

# Start SSH and Apache on container startup
CMD service ssh start && apache2-foreground