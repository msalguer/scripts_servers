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

echo -e "$Cyan \n Installing PHP7 from external repository & NGINX...  $Color_Off"
sudo apt -y install lsb-release apt-transport-https ca-certificates 
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update
sudo apt -y install php7.4
sudo apt-get -y install php7.4-{bcmath,bz2,intl,gd,mbstring,mysql,zip}

echo -e "$Cyan \n Disable Apache service, if proceed...  $Color_Off"
sudo systemctl disable --now apache2

echo -e "$Cyan \n Installing NGINX $Color_Off"
sudo apt-get -y install nginx php7.4-fpm


echo -e "$Cyan \n Preparing PHP-FPM and NGINX config files...  $Color_Off"
cp -r php-fmp-poold-www.conf /etc/php/7.4/fpm/pool.d/www.conf
cp -r default-enabled-nginx /etc/nginx/sites-enabled/default
cp -r default-enabled-nginx /etc/nginx/sites-available/default


echo -e "$Cyan \n Generating and configuring self-signed SSL cert...  $Color_Off"
#sudo openssl rsa -in  /etc/ssl/private/default-ssl.key -text > /etc/ssl/private/default-ssl.pem
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/default-ssl.key -out /etc/ssl/certs/default-ssl.crt
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

echo -e "$Cyan \n Reload PHP-FPM and NGINX services...  $Color_Off"
sudo systemctl reload php7.4-fpm
sudo systemctl reload nginx

echo -e "Installation finished. Please check on https://domain  $Color_Off"

