#!/bin/sh
## Install RDP Remote Desktop on Debian or Ubuntu based system with sudo
## source: https://operavps.com/linux-vps-with-gui-and-rdp/

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

echo -e "$Yellow \n Do you use Gnome desktop? (y/N): $Color_Off"
read -e gnome

if [ "$gnome" == "y" || "$gnome" == "Y"] 
then
    #Nothing
else
        sudo apt install gnome-session gdm3 -y
fi

sudo apt-get install xrdp -y
sudo ufw allow 3389/tcp
cat > /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf << EOF
polkit.addRule(function(action, subject) {
if ((action.id == “org.freedesktop.color-manager.create-device” || action.id == “org.freedesktop.color-manager.create-profile” || action.id == “org.freedesktop.color-manager.delete-device” || action.id == “org.freedesktop.color-manager.delete-profile” || action.id == “org.freedesktop.color-manager.modify-device” || action.id == “org.freedesktop.color-manager.modify-profile”) && subject.isInGroup(“{group}”))
{
return polkit.Result.YES;
}
});
EOF
sudo /etc/init.d/xrdp restart
echo -e "$Green \n Installation finished. $Color_Off"
