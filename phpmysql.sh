#!/bin/sh

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

echo -e "$Cyan \n Installing PHP & Requirements $Color_Off"
sudo apt-get install libapache2-mod-php7.4 php php-cli php-common php-curl php-dev php-gd php-pear php-imagick php-mysql php-xsl -y
sed -i "s/;error_log = php_errors.log/error_log = php_errors.log/g" /etc/php/7.4/apache2/php.ini
sudo a2enmod php7.4
systemctl restart apache2

echo -e "$Cyan \n Installing MySQL $Color_Off"
sudo apt-get install mysql-server mysql-client -y
sudo dpkg-reconfigure mysql-server
sudo mysql_secure_installation
mysql --version

