#!/bin/sh
## Install AMP
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
echo -e "$Cyan \n Updating System.. $Color_Off"
sudo apt-get update -y && sudo apt-get upgrade -y

echo -e "$Cyan \n Installing Apache2 $Color_Off"
#sudo apt-get install apache2 apache2-doc apache2-mpm-prefork apache2-utils libexpat1 ssl-cert -y
sudo apt-get install -y apache2 apache2-utils ssl-cert
## TWEAKS and Settings
# Permissions
echo -e "$Cyan \n Permissions for /var/www/html $Color_Off"
sudo chown -R www-data:www-data /var/www/html/
echo -e "$Green \n Permissions have been set $Color_Off"
# Enabling Mod Rewrite, required for WordPress permalinks and .htaccess files
echo -e "$Cyan \n Enabling Modules $Color_Off"
sudo a2enmod rewrite
#OPENSSL and generate certificate
echo -e "$Cyan  \n Install OpenSSL and generate certificate $Color_Off"
sudo apt-get install openssl -y
#sudo apt install build-essential checkinstall zlib1g-dev -y
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/default-ssl.key -out /etc/ssl/certs/default-ssl.crt

if [ -d "/etc/apache2/ssl" ] 
then
    echo -e "Directory exists: /etc/apache2/ssl"
else
        mkdir /etc/apache2/ssl
fi

echo -e "$Yellow \n Please, insert domain of installation: $Color_Off"
read -e defdom
cat > /etc/apache2/sites-available/default-ssl.conf << EOF
#<IfModule mod_ssl.c>
#LoadModule ssl_module modules/mod_ssl.so
#Listen 443

<VirtualHost *:80> 
  ServerName localhost
#  ServerAlias w.example.com
#  Redirect / https://
EOF
echo "Redirect / https://$defdom" >> /etc/apache2/sites-available/default-ssl.conf
cat >> /etc/apache2/sites-available/default-ssl.conf <<EOF
</VirtualHost>

<VirtualHost *:443>
#        ServerAdmin webmaster@localhost
#        ServerName 
EOF
echo "ServerName $defdom" >> /etc/apache2/sites-available/default-ssl.conf
cat >> /etc/apache2/sites-available/default-ssl.conf <<EOF
        SSLEngine on
#        SSLCertificateFile /etc/ssl/certs/default.pem
        SSLCertificateFile /etc/ssl/certs/default-ssl.crt
	SSLCertificateKeyFile /etc/ssl/private/default-ssl.key
	DocumentRoot /var/www
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOF
sudo ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

echo -e "$Cyan \n Enabling SSL on Apache $Color_Off"
sudo a2ensite default-ssl
sudo a2enmod ssl
sudo a2enmod rewrite

# Restart Apache
echo -e "$Cyan \n Restarting Apache $Color_Off"
sudo apachectl configtest
sudo service apache2 restart
#sudo service apache2 status
curl -k https://localhost
cat /etc/hostname
ls /etc/apache2/sites-enabled
cat /etc/apache2/sites-enabled/default-ssl.conf
