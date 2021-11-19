
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

echo "Do you wish to install a Desktop Environment?\n1: Yes\n2: No"

read de  # Reads your input, stores it into de var

if [ $de -eq 1 ]
then
	echo "Choose your DE\n1. Gnome\n2. KDE\n3. XFCE" # These are my favs if you want to add more you are more than free to do so.. (lazydev)
	
	read de # Reads user input again for DE choice

	if [ $de -eq 1 ]
	then
		echo "Installing Gnome Desktop...\n" # Installs GNOME 
		sudo pacman -S gnome
	
	
	elif [ $de -eq 2 ]
	then
		echo "Installing KDE Desktop...\n" # Installs KDE
		sudo pacman -S plasma
	
	elif [ $de -eq 3 ]
	then
		echo "Installing XFCE desktop...\n" # Installs XFCE4
		sudo pacman -S xfce4
	
	else
		echo "Returning...\n"
	fi

else
	echo "Proceeding without DE installation"
fi

# Now installing my needed software and some drivers, modify this according to your likings OR system..
# Note that most bluetooth, mainstream drivers come pre-installed in most DE so if it's not installed in yours, just go ahead and add those too..

# ~pacman ----------
sudo pacman -S mesa lib32-vulkan-radeon lib32-vulkan-mesa-layers lib32-opencl-mesa lib32-mesa-vdpau lib32-mesa lib32-glu vulkan-mesa-layers opencl-mesa alacritty glu qbittorrent python pavucontrol zsh ntfs-3g obs-studio vlc lutris gparted steam bitwarden git kdenlive virtualbox plex-media-server --noconfirm
# ~pacman ----------

# ~yay --------
yay -S discord spotify sublime-text brave --noconfirm
# ~yay --------

echo "\n\nSoftware Installation completed!\nIf anything failed to install, please try manually!\nPress enter to restart.."

read x

sudo reboot

# end 
