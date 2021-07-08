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

# Firewall ports
echo -e "$Cyan \n Open firewall ports...$Color_Off"
sudo ufw allow 'Apache Full'
sudo ufw allow ssh
sudo ufw delete allow 'Apache'
sudo ufw enable
sudo ufw status
