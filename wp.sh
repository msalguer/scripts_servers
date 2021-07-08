#!/bin/sh
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

# Install Wordpress
echo -e "$Cyan \n Installing Wordpress...$Color_Off"
sudo apt-get install wget
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
rm /var/www/index.html 2> /dev/null
cd wordpress
cp -r ** /var/www
cd ..
rm -r wordpress
rm latest.tar.gz

#echo "Hostname/Domain:"
#read -e hostdom
echo -e "$Yellow \n MySQL root password: $Color_Off"
read -e mysqlpass
echo -e "$Yellow \n Database Name: $Color_Off"
read -e dbname
echo -e "$Yellow \n Database User: $Color_Off"
read -e dbuser
echo -e "$Yellow \n Database Password: $Color_Off"
#read -s dbpass
read -e dbpass
#create wp config
cp /var/www/wp-config-sample.php /var/www/wp-config.php
#set database details with perl find and replace
echo -e "$Cyan \n Modify wp-config.php $Color_Off"
sed -i "s/database_name_here/$dbname/g" /var/www/wp-config.php
sed -i "s/username_here/$dbuser/g" /var/www/wp-config.php
sed -i "s/password_here/$dbpass/g" /var/www/wp-config.php

#create uploads folder and set permissions
echo -e "$Cyan \n Create folder uploads and set permissions...$Color_Off"
mkdir /var/www/wp-content 2> /dev/null
mkdir /var/www/wp-content/uploads 2> /dev/null
sudo chmod 777 /var/www/wp-content/uploads
find /var/www/. -type d -exec chmod 755 {} \;
find /var/www/. -type f -exec chmod 644 {} \;

#Create database and user in MySQL
echo -e "$Cyan \n Prepare SQL sentences for create database, user and permissions...$Color_Off"
sed -i "s/database_name_here/$dbname/" /var/www/wp-config.php
sed -i "s/password_here/$dbpass/g" /var/www/wp-config.php
cp -r wp.sql wp_modif.sql
sed -i "s/dbname_here/$dbname/g" wp_modif.sql
sed -i "s/username_here/$dbuser/g" wp_modif.sql
sed -i "s/pass_here/$dbpass/g" wp_modif.sql
mysql -u root -p$mysqlpass < wp_modif.sql
echo -e "$Cyan \n Finished. To finish installation visit: https://domain/wp-admin/install.php, and after, delete wp-admin/install.php file. $Color_Off"
