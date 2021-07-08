#!/bin/sh
## Install MySQL5
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

# Update packages and Upgrade system
echo -e "$Cyan \n Installing MySQL5.7. Please, select Bionic version... $Color_Off"
sudo apt install wget -y
wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.12-1_all.deb
sudo apt-get update
sudo apt-cache policy mysql-server
sudo apt install -y mysql-client=5.7*-1ubuntu18.04 mysql-server=5.7*-1ubuntu18.04
sudo mysql_secure_installation
mysql --version
sudo service mysql status

