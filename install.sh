#!/usr/bin/env bash
# ===================================================================================== NOTES =============================================================================================

# BETA Release, this is not intended to work on 100% of the systems out there perfectly out of the box!! make sure you know what you're doing before...
# you modify the code.

# ================================================================================ DRIVER PACKAGES ========================================================================================

# !! Please don't change the variable names because you will break the script !!
# I highly advise against changing the packages unless you really know what you're doing ! 
# Changing packages won't break the installation so you can do so if you really must..

NVIDIA_DRIVERS=(nvidia libvdpau nvidia-settings nvidia-utils opencl-nvidia xf86-video-nouveau nvtop lib32-libvdpau lib32-nvidia-utils lib32-opencl-nvidia)
AMD_DRIVERS=(mesa lib32-glu lib32-mesa opencl-mesa vulkan-radeon lib32-opencl-mesa lib32-vulkan-radeon xf86-video-amdgpu lib32-opencl-mesa vulkan-icd-loader lib32-vulkan-icd-loader)
INTEL_DRIVERS=(libva-intel-driver vulkan-intel xf86-video-intel intel-compute-runtime intel-gmmlib intel-graphics-compiler intel-media-driver lib32-libva-intel-driver lib32-vulkan-intel)

GPUs=(AMD NVIDIA Intel VMware)
GPU=''

# ==================================================================================== <CODE> ==============================================================================================
install_driver () { # This function collects the GPU detection information gathered in < line(s) 157+ > and installs the driver package accordingly
                    # I Highly advise against editing the code within the function unless you really know what you're doing, you're on your own!!

    queue=() # This will queue the not-installed drivers and install them later.

    if [ "$1" == 'NVIDIA' ]
    then
        for driver in "${NVIDIA_DRIVERS[@]}" 
        do
	        if pacman -Qs "$driver" > /dev/null
	        then
  		        echo "The package $driver is already installed"
	        else
  		        echo "The package $driver is NOT installed"
  		        queue+=("$driver")
            fi
        done


    elif [ "$1" == 'AMD' ]
    then
        for driver in "${AMD_DRIVERS[@]}" 
        do
	        if pacman -Qs "$driver" > /dev/null
	        then
  		        echo "The package $driver is already installed"
	        else
  		        echo "The package $driver is NOT installed"
  		        queue+=("$driver")
            fi
        done

    elif [ "$1" == 'Intel' ]
    then
        for driver in "${INTEL_DRIVERS[@]}" 
        do
	        if pacman -Qs "$driver" > /dev/null
	        then
  		        echo "The package $driver is already installed"
	        else
  		        echo "The package $driver is NOT installed"
  		        queue+=("$driver")
            fi
        done
    fi

    # Makes sure there are drivers queued up before confirmation prompt
    if [ ! "${queue[0]}" == '' ]
    then
    	printf "\nProceed with driver installation? (Y/N)\ninput: "
	read -r confirm
    else
    	printf "\nAll drivers are already installed, skipping this part\n\n"
    fi


    if [ "$confirm" == 'Y' ] || [ "$confirm" == 'y' ] || [ "$confirm" == 'Yes' ] || [ "$confirm" == 'yes' ] || [ "$confirm" == 'YES' ]
    then
        # Installs the queued drivers
        printf "\nInstalling %s GPU Drivers\n" "$1"
        printf "\npackages queued -> %s" "${queue[@]}"
    fi
} #                             ==================================================== END OF FUNC ==================================================


# First let's make sure the end-user is running Arch / Arch based distro
if test -f "/etc/pacman.conf" 
then
    echo "Using Arch: Pass"
else
    printf "This script is specifically made for Arch based systems..\n
            Exiting Script~"
    exit
fi

# Creating GIT directory at the users Home folder where we will save and install all our git clones later.
if test -d "/home/$USER/git"
then
    printf "/home/%s/git directory found\n" "$USER"
else
    printf "Creating GIT directory at -> '/home/%s/git'\n" "$USER"
    mkdir /home/$USER/git
fi


# Enables multilib
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Install updates first.
sudo pacman -Syu --noconfirm 

# Installing YAY AUR Helper for later use.
if pacman -Qs yay > /dev/null
then
  echo "Yay is already installed.. Skipping"
else
  sudo pacman -S git --noconfirm
  cd /home/$USER/git || exit
  (
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si
  )
fi

# Installing MS clear type fonts for some software that require it.
if pacman -Qs ttf-ms-fonts > /dev/null
then
  echo "Microsoft Clear Type Fonts are already installed.. Skipping"
else
  sudo pacman -S git --noconfirm
  cd /home/$USER/git || exit
  (
  git clone https://aur.archlinux.org/ttf-ms-fonts.git
  cd ttf-ms-fonts || exit
  makepkg -si
  )
fi




# Desktop environment prompt
# You can choose whether or not you want to install a DE (if none present)
# 1 = Install DE
# 2 = No DE install

# Also for this script to work it's better you have "base-devel,base" packages installed already!
# Just in-case you are using vanilla arch!

printf "\nDo you wish to install a Desktop Environment?\n1 = Yes\n2 = No\nInput: "

read -r de  # Reads your input, stores it into de var

if [ "$de" -eq 1 ]
then
	printf "\nChoose your DE\n1 = Gnome\n2 = Plasma\n3 = XFCE\nInput: " # These are my favs if you want to add more you are more than free to do so.. (lazydev)
	
	read -r de # Reads user input again for DE choice

	case "$de" in

            1)
            printf "\nInstalling Gnome Desktop...\n" # Installs GNOME DE & some needed packages
            sudo pacman -S gnome xorg xorg-apps xorg-drivers xorg-server xorg-xkill xorg-xinit xterm xf86-video-vesa xf86-video-fbdev xf86-video-intel --noconfirm
            sudo systemctl enable gdm.service
            ;;
	
 	    2)
            printf "\nInstalling Plasma Desktop...\n" # Installs KDE Plasma DE & some needed packages
            sudo pacman -S plasma kde-applications plasma-wayland-session plasma-wayland-protocols xorg xorg-apps xorg-drivers xorg-server xorg-xkill xorg-xinit xterm xf86-video-vesa xf86-video-fbdev xf86-video-intel --noconfirm
            sudo systemctl enable sddm.service
            ;;
	
            3)
            printf "\nInstalling XFCE desktop...\n" # Installs XFCE4 DE & some needed packages
            sudo pacman -S xfce4 xorg xorg-apps xorg-drivers xorg-server xorg-xkill xorg-xinit xterm xf86-video-vesa xf86-video-fbdev xf86-video-intel sddm --noconfirm
            sudo systemctl enable sddm.service
            ;;
            
	    *)
            printf "Invalid input.."
            ;;
        esac

else
	printf "\nProceeding without DE installation\n"
fi


# This is the part where it autodetects your GPU and installs the driver packages.
# This returns information to the function in < Line 24 > and acts accordingly.

for gpu in "${GPUs[@]}" # Iterate through the GPU list mentioned above and find the GPU vendor for the driver installation.
do
    lspci -vnn | grep VGA | grep "$gpu" > /dev/null
    if [[ $? -eq 0 ]] && [ ! "$gpu" == 'VMware' ]
    then 
        printf "%s Graphics detected Is this correct? (Y/N)?\nInput: " "$gpu" # User has to confirm just to make sure..
        
        read -r GPU
        
        if [ "$GPU" == 'Y' ] || [ "$GPU" == 'y' ] || [ "$GPU" == 'Yes' ] || [ "$GPU" == 'yes' ]
        then
            GPU="$gpu" # Store users GPU for future use, better to have it in a variable.
            
            install_driver "$gpu"
        else
            printf "\nPlease select your GPU manually.\n
                  1 = AMD\n
                  2 = NVIDIA\n
                  3 = Intel\n
                  4 = Continue without driver installation\n
                  Input: "                                  # If it fails to detect the GPU you can always choose manually or skip this part.
            
            read -r GPU
            
            case $GPU in 
                1)
                    printf "\nYou chose AMD\n"
                    GPU="AMD"
                    install_driver "$GPU"
                    ;;
                2)
                    printf "\nYou chose Nvidia\n"
                    GPU="NVIDIA"
                    install_driver "$GPU"
                    ;;
                3)
                    printf "\nYou chose Intel\n"
                    GPU="INTEL"
                    install_driver "$GPU"
                    ;;
                *)
                    printf "\nGPU Drivers won't be installed.\n"
                    ;;
            esac
        fi
        break
    else
        continue
    fi
done

if [ $gpu == 'VMware' ]; then printf "Running this through a virtualized environment(?)\nSkipping driver installation..\n" ; fi

# You can add your own packages by typing the name of the package inside the '()' leave a space after each one. e.x (discord spotify ...) :)
# Note that most bluetooth, mainstream drivers come pre-installed in most DE or Distro's, if it's not in yours go ahead and add them.
# Conflicting packages will NOT be installed/removed by default, so don't worry about that.

software_list_pacman=('xdg-desktop-portal'
                      'xorg'
                      'xorg-server'
                      'xorg-apps'
                      'xorg-drivers'
                      'xorg-xkill'
                      'xorg-xinit'
                      'xterm'
                      'qt5-wayland'
                      'pipewire wine-staging'
                      'giflib'
                      'lib32-giflib'
                      'libpng'
                      'lib32-libpng'
                      'libldap'
                      'lib32-libldap'
                      'gnutls'
                      'lib32-gnutls'
                      'mpg123'
                      'lib32-mpg123'
                      'openal'
                      'lib32-openal'
                      'v4l-utils'
                      'lib32-v4l-utils'
                      'libpulse'
                      'lib32-libpulse'
                      'libgpg-error'
		              'mujs'
		              'webkit2gtk'
		              'qt5-webchannel'
                      'qt5-declarative'
                      'js78'
                      'jre11-openjdk'
                      'jre-openjdk-headless'
                      'jdk11-openjdk'
                      'java11-openjfx'
                      'java-runtime-common'
                      'java-environment-common'
                      'lib32-libgpg-error'
                      'alsa-plugins'
                      'lib32-alsa-plugins'
                      'alsa-lib'
                      'lib32-alsa-lib'
                      'libjpeg-turbo'
                      'lib32-libjpeg-turbo'
                      'sqlite'
                      'lib32-sqlite'
                      'libxcomposite'
                      'lib32-libxcomposite'
                      'libxinerama'
                      'lib32-libgcrypt'
                      'libgcrypt'
                      'lib32-libxinerama'
                      'ncurses'
                      'lib32-ncurses'
                      'opencl-icd-loader'
                      'lib32-opencl-icd-loader'
                      'libxslt'
                      'lib32-libxslt'
                      'libva'
                      'lib32-libva'
                      'gtk3'
                      'lib32-gtk3'
                      'gst-plugins-base-libs'
                      'lib32-gst-plugins-base-libs'
                      'meson'
                      'systemd'
                      'git'
                      'dbus'
                      'lib32-mesa'
                      'vulkan-icd-loader'
                      'lib32-vulkan-icd-loader'
                      'mesa'
                      'lib32-vulkan-mesa-layers'
                      'lib32-opencl-mesa'
                      'lib32-mesa-vdpau '
                      'lib32-glu'
                      'vulkan-mesa-layers'
                      'opencl-mesa'
                      'alacritty'
                      'glu'
                      'qbittorrent'
                      'python'
                      'pavucontrol'
                      'zsh'
                      'ntfs-3g'
                      'obs-studio'
                      'vlc'
                      'lutris'
                      'gparted'
                      'bitwarden'
                      'kdenlive'
                      'virtualbox'
                      'python-pip'
                      'ufw'
                      'pulseaudio'
                      'code'
                      'atom'
                      'gimp'
                      'nano'
		              'pulseaudio'
		              'pavucontrol'
                      )

software_list_yay=('discord'
                   'spotify'
                   'sublime-text'
                   'brave-bin'
                   'plex-media-server'
                   )

toInstall_pac=()
toInstall_yay=()

for package_pacman in "${software_list_pacman[@]}"; { # Checks if 'pacman' packages from the list are installed or not
	
	if pacman -Qs "$package_pacman" > /dev/null
	then
  		echo "The package $package_pacman is already installed"
	else
  		echo "The package $package_pacman is NOT installed"
  		toInstall_pac+=("$package_pacman")
	fi
}

for package_yay in "${software_list_yay[@]}"; { # Checks if 'yay' packages from the list are installed or not
	
	if pacman -Qs "$package_yay" > /dev/null
	then
  		echo "The package $package_yay is already installed"
	else
  		echo "The package $package_yay is NOT installed"
  		toInstall_yay+=("$package_yay")
	fi
}

if [ ! "${toInstall_pac[@]}" ] # Installation script(pacman), checks if there are packages in the queue before proceeding to avoid unnecessary installations of existing packages..
then
	printf "\nAll Pacman packages already installed.."
else
	sudo pacman -S "${toInstall_pac[@]}" --noconfirm
fi

if [ ! "${toInstall_yay[@]}" ] # Installation script(yay), checks if there are packages in the queue before proceeding to avoid unnecessary installations of existing packages..
then
	printf "\nAll Yay packages already installed..\n"
else
	yay -S "${toInstall_yay[@]}" --noconfirm
fi

# Enabling some services
if pacman -Qs ufw > /dev/null # Checks if UFW exists
then
    sudo systemctl enable ufw
    sudo ufw enable
    sudo systemctl start ufw
else
    printf "ufw is not installed.. skipping"
fi

if pacman -Qs plex-media-server > /dev/null # Checks if plex exists
then  
    sudo systemctl enable plexmediaserver.service
    sudo systemctl start plexmediaserver.service
else
    printf "Plex media server is not installed.. skipping\n"
fi
# Done enabling the services

#Opening ports for Plex
if [ "systemctl is-enabled ufw.service"=='enabled' ] # If the service isn't enabled means something went wrong before so skipping if not.
then
    sudo ufw allow in 32400/tcp   ######################################################################################
    sudo ufw allow out 32400/tcp  # Allowing Plex to be accessed from outside of the local network
    sudo ufw allow in 32400/udp   # You can choose to disable this function through the plex GUI on localhost:32400/web
    sudo ufw allow out 32400/udp  ######################################################################################
else
    printf "ufw is not enabled skipping\n"
fi
# Done opening the ports

# Titus Ultimate gaming guide - ref -> https://www.christitus.com/ultimate-linux-gaming-guide/ ~ Credits to Chris Titus
# Enabling ACO
echo 'RADV_PERFTEST=aco' | sudo tee -a /etc/environment

# Esync enable
ulimit -Hn

# GameMode - No CPU Throttling
# Arch - Dependancies
if [ ! -d /usr/share/gamemode ] # Checks for existing gamemode installation
then
    cd /home/$USER/git || exit
    if [ ! -d gamemode ] 
    then
        git clone https://github.com/FeralInteractive/gamemode.git
	    cd gamemode || exit
	    ./bootstrap.sh
    
    else
    	printf "A folder with the name 'gamemode' already exists, continuing without Git cloning..\n"
        cd gamemode || exit
	    ./bootstrap.sh
    fi

else
    printf "GameMode is already installed in your system, skipping..\n"
fi

# Auto-Install Project: ProtonUP ~Installs the latest proton version directly into your steam dir! Easy!
# Doesn't automatically work for everyone, sometimes you will have to manually define your path/different path depending on where you installed steam.
# But if you followed exactly my config it should work straight out of the box !!!
if [ -d "/home/$USER/.local/bin/protonup" ]
then
    echo "Protonup is already installed"
else
    pip install protonup # Installs protonup
fi

echo "export PATH=$PATH:~/.local/bin" >> .bashrc
source .bashrc

if [ ! -d "/home/$USER/.local/share/Steam/compatibilitytools.d/" ]
then
    mkdir "/home/$USER/.local/share/Steam/compatibilitytools.d/"
    protonup -d "/home/$USER/.local/share/Steam/compatibilitytools.d/" # This sets the default download destination for GE-Proton when using 'protonup' command

else
    protonup -d "/home/$USER/.local/share/Steam/compatibilitytools.d/" # This sets the default download destination for GE-Proton when using 'protonup' command
fi

# This fixes the "command not found" error when typing protonup.
echo "if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"		
fi" | sudo tee ~/.profile > /dev/null

# Adding a permanent alias so the 'protonup' command always works.
echo "alias protonup='source ~/.profile && protonup'" | tee -a ~/.bashrc > /dev/null
source ~/.bashrc

# Running protonup
protonup

# ProtonUP installation done! ~~~

printf "\nScript Finished~\n\nIf anything failed to install, please try manually!\n\nPress enter to restart(Recommended)...\n\nOr close the window to end"

read -r x

sudo reboot

# ==================================================================================== </CODE> =============================================================================================================
