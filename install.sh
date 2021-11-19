#!/bin/bash

# This script is made for my own personal usage and own personal preferences..
# You can freely modify and distribute according to your own likings and preferences
# Feel free to dig in !!! Don't be a stranger ;)

# Mind that this is working strictly and only for ARCH based systems..
# Don't try using this on any other flavor based systems ! ! ! (It won't work)

# !! NOTE IF YOU HAVE VANILLA ARCH YOUR MULTILIB REPOS ARE PROBABLY COMMENTED OUT! EDIT "/etc/pacman.conf" AND UNCOMMENT THE MULTILIB REPO ! ! !
# IT PROBABLY WON'T WORK WITHOUT MULTILIB UNCOMMENTED ~(!! many packages won't install !!)~

sudo pacman -Syu --noconfirm # Install updates first..
sudo pacman -S yay --noconfirm # Then we install yay AUR helper this will be needed for later use..

# Desktop environment prompt
# You can choose whether or not you want to install a DE (if none present)
# 1 = Install DE
# 2 = No DE install

# Also for this script to work it's better you have "base-devel,base" packages installed already!
# Just in-case you are using vanilla arch!

printf "\nDo you wish to install a Desktop Environment?\n1 = Yes\n2 = No\nInput: "

read de  # Reads your input, stores it into de var

if [ $de -eq 1 ]
then
	printf "\nChoose your DE\n1 = Gnome\n2 = Plasma\n3 = XFCE\nInput: " # These are my favs if you want to add more you are more than free to do so.. (lazydev)
	
	read de # Reads user input again for DE choice

	if [ $de -eq 1 ]
	then
		printf "\nInstalling Gnome Desktop...\n" # Installs GNOME DE
		sudo pacman -S gnome xorg xf86-video-vesa xf86-video-fbdev xf86-video-intel --noconfirm
		sudo systemctl enable gdm.service
	 
	
	elif [ $de -eq 2 ]
	then
		printf "\nInstalling Plasma Desktop...\n" # Installs Plasma DE
		sudo pacman -S plasma kde-applications plasma-wayland-session plasma-wayland-protocols xorg xf86-video-vesa xf86-video-fbdev xf86-video-intel --noconfirm
		sudo systemctl enable sddm.service
	elif [ $de -eq 3 ]
	then
		printf "\nInstalling XFCE desktop...\n" # Installs XFCE4 DE
		sudo pacman -S xfce4 xorg xf86-video-vesa xf86-video-fbdev xf86-video-intel --noconfirm
	
	else
		printf "\nReturning...\n"
	fi

else
	printf "\nProceeding without DE installation\n"
fi

# Now installing my needed software and some drivers, modify this according to your likings OR system..
# Note that most bluetooth, mainstream drivers come pre-installed in most DE so if it's not installed in yours, just go ahead and add those too..

# ~pacman ----------
sudo pacman -S mesa lib32-vulkan-radeon lib32-vulkan-mesa-layers lib32-opencl-mesa lib32-mesa-vdpau lib32-mesa lib32-glu vulkan-mesa-layers opencl-mesa alacritty glu qbittorrent python pavucontrol zsh ntfs-3g obs-studio vlc lutris gparted steam bitwarden git kdenlive virtualbox python-pip ufw pulseaudio --noconfirm
# ~pacman ----------

# ~yay --------
yay -S discord spotify sublime-text brave-bin timeshift plex-media-server --noconfirm 
# ~yay --------

# Enabling some services
sudo systemctl enable ufw
sudo ufw enable
sudo systemctl start ufw
sudo systemctl enable plexmediaserver.service
sudo systemctl start plexmediaserver.service
# Done enabling the services

#Opening ports for Plex
sudo ufw allow in 32400/tcp   ################################################################
sudo ufw allow out 32400/tcp  # Allowing Plex to be accessed from outside of the local network
sudo ufw allow in 32400/udp   # You can choose to disable this function through the plex GUI on localhost:32400/web
sudo ufw allow out 32400/udp  ################################################################
# Done opening the ports

# Titus Ultimate gaming guide - ref -> https://www.christitus.com/ultimate-linux-gaming-guide/ ~ Credits to Chris Titus

#Enable 32-bit libs
sudo dpkg --add-architecture i386 

# Some more AMD drivers
sudo pacman -S lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader -y

# Enabling ACO
echo 'RADV_PERFTEST=aco' | sudo tee -a /etc/environment

# Wine dependancies
sudo pacman -S wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader lutris -y

# Esync enable
ulimit -Hn

# GameMode - No CPU Throttling
# Arch - Dependancies
pacman -S meson systemd git dbus -y
cd
mkdir git
cd git
git clone https://github.com/FeralInteractive/gamemode.git
cd gamemode
./bootstrap.sh

# Auto-Install Project: ProtonUP ~Installs the latest proton version directly into your steam dir! Easy!
pip install protonup
echo "export PATH=$PATH:~/.local/bin" >> .bashrc
source .bashrc
protonup

# Doesn't automatically work for everyone, sometimes you will have to manually define your path/different path depending on where you installed steam.
# But if you followed exactly my config it should work straight out of the box !!!

# Now I will install the pulseaudio profile for my razer nari headset due to only outputing in MONO audio after fresh install..
# Comment this out if you don't have Razer Nari headsets!

cd
cd git
git clone https://github.com/denesb/razer-nari-pulseaudio-profile.git
cd razer-nari-pulseaudio-profile

# Script part that copies all the nescesary profiles and pastes into pulse-audio profiles.
sudo cp razer-nari-input.conf /usr/share/pulseaudio/alsa-mixer/paths/
sudo cp razer-nari-output-{game,chat}.conf /usr/share/pulseaudio/alsa-mixer/paths/
sudo cp razer-nari-usb-audio.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/
sudo cp 91-pulseaudio-razer-nari.rules /lib/udev/rules.d/

pulseaudio -k
pulseaudio --start
# Script end

printf "\nSoftware Installation completed!\n\nIf anything failed to install, please try manually!\n\nPress enter to restart(Recommended)...\n\nOr ctrl+c to end"

read x

sudo reboot

# END 
