#!/bin/sh
## Install Moodle
#set -e
#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

# Update packages and Upgrade system
#echo -e "$Cyan \n Updating System.. $Color_Off"
#sudo apt-get update -y && sudo apt-get upgrade -y

# Download Moodle
echo -e "$Cyan \n Downloading Moodle stable 3.11 version... $Color_Off"
# Requires: PHP 7.3, MariaDB 10.2.29 or MySQL 5.7 or Postgres 9.6 or MSSQL 2017 or Oracle 11.2
sudo apt install git
git clone -b MOODLE_310_STABLE git://git.moodle.org/moodle.git
rm /var/www/index.html 2> /dev/null
mkdir /var/www 2> /dev/null
chown -R www-data:www-data /var/www

#rm -r /var/www/*
cd moodle
cp -r ** /var/www/
cd ..
rm -r moodle
#find /var/www/. -type d -exec chmod 755 {} \;
#find /var/www/. -type f -exec chmod 644 {} \;
#echo "max_input_vars = 3000" >> /etc/php/7.4/fpm/php.ini
#sudo service php7.4-fpm reload
sudo chown -R www-data:www-data /var/lib/nginx

echo -e "$Cyan \n Create database and user... $Color_Off"

echo -e "$Yellow \n MySQL root password: $Color_Off"
read -e mysqlpass
echo -e "$Yellow \n Database User: $Color_Off"
read -e dbuser
echo -e "$Yellow \n Database Password: $Color_Off"
read -e dbpass

cp -r moodle.sql moodle_modif.sql
sed -i "s/moodleuser/$dbuser/g" moodle_modif.sql
sed -i "s/yourpassword/$dbpass/g" moodle_modif.sql
mysql -u root -p$mysqlpass < moodle_modif.sql


echo -e "$Cyan \n Installing additional PHP configuration and packages for good works... $Color_Off"
sudo apt -y install php-xmlrpc php-soap

#sudo /usr/bin/php /var/www/admin/cli/install.php
echo -e "$Cyan \n OK. To finish installation,go to https://domain  $Color_Off"
