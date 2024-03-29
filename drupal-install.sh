#!/bin/bash
#Début du scripte /  Made by © 2022-2023 Ethan Besson

# Update and upgrade the system
sudo apt-get update -y && sudo apt-get upgrade -y

# Install Apache2
sudo apt-get install apache2 -y

# Install unzip
sudo apt install unzip -y

# Enable and start Apache2
sudo systemctl enable apache2 && sudo systemctl start apache2

# Check Apache2 status
sudo systemctl --no-pager status apache2

# Install necessary packages for PHP
apt -y install lsb-release apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# Update the system again
sudo apt-get update -y

# Install PHP8.2 and necessary extensions
sudo apt-get install php8.2 php8.2-common php8.2-curl libapache2-mod-php php8.2-imap php8.2-redis php8.2-cli php8.2-snmp php8.2-xml php8.2-zip php8.2-mbstring php8.2-mysql php8.2-gd php-gd php-xml php-mysql php-mbstring -y

# Check PHP version
php -v

# Install MariaDB server
sudo apt-get install mariadb-server -y

# Start and enable MariaDB
sudo systemctl start mariadb && sudo systemctl enable mariadb

# Check MariaDB status
sudo systemctl --no-pager status mariadb

# Generate a random password
password=$(openssl rand -base64 32)

# Execute SQL commands
sudo mysql -u root -e "
CREATE USER 'drupal'@'localhost' IDENTIFIED BY '$password';
CREATE DATABASE drupal;
GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost';
FLUSH PRIVILEGES;
"

# Navigate to the /var/www/html directory
cd /var/www/html

# Download Drupal
wget https://ftp.drupal.org/files/projects/drupal-10.2.3.zip

# Unzip the downloaded file
unzip drupal-10.2.3.zip

# Rename the extracted directory
mv drupal-10.2.3/ drupal/

# Remove the downloaded zip file
rm drupal-10.2.3.zip

# Change the owner of the drupal directory
chown -R www-data:www-data drupal/

# Set the correct permissions for directories and files
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

# Navigate to the Apache sites-available directory
cd /etc/apache2/sites-available/

# Create a new configuration file
touch drupal.conf

# Get the public IP address
public_ip=$(curl -s ifconfig.me)

# Add content to the drupal.conf file
echo "<VirtualHost *:80>
ServerName $public_ip
DocumentRoot /var/www/html/drupal

<Directory /var/www/html/drupal>
AllowOverride All
</Directory>

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>" > drupal.conf

# Disable the default site
sudo a2dissite 000-default.conf

# Enable the rewrite module
sudo a2enmod rewrite

# Enable the drupal site
sudo a2ensite drupal.conf

# Test the Apache configuration
apachectl -t

# Restart Apache
sudo systemctl restart apache2

# Uncomment extensions in php.ini
sudo sed -i 's/;extension=gd/extension=gd/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/8.2/cli/php.ini

# Uncomment extensions in php.ini
sudo sed -i 's/;extension=gd/extension=gd/' /etc/php/8.2/apache2/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/8.2/apache2/php.ini

# Restart Apache
sudo systemctl restart apache2
clear

# Display a completion message
echo "Drupal installation completed successfully!"
echo "http://$public_ip"

# Print the information to a text file in the home directory
echo "Database name: drupal" > /home/debian/db_credentials.txt
echo "Database user: drupal" >> /home/debian/db_credentials.txt
echo "Database password: $password" >> /home/debian/db_credentials.txt

# Display the username and password at the end
echo "Database name: drupal"
echo "Database user: drupal"
echo "Database password: $password"
