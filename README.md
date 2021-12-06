Hello and welcome!

# Aben's Arch post installation script
Installs most common software and needed drivers so you are up and running with a single click!
<br>!!!
<br><b>NOTE: This is meant for AMD64 systems, if you are using a different CPU architecture it's recommended to modify the install script for your appropriate system first.</b>
<br>!!!

Tested on Garuda, EndeavourOS, Vanilla Arch, Working 100% ( sat 27 nov 2021 )

# What's new? - 12.6.21
1. Added CPU autodetection & ucode install.


# What does it do? 

1. Updates the system
2. (Optional) Installs the desktop environment of your choosing followed by all required packages.
3. Autodetects your computers hardware specs and installs the appropriate drivers.
# The following software/driver & utils are installed.
   1. Mesa - https://mesa3d.org/
   2. OpenCL libs for MESA
   3. OpenGL libs for MESA
   4. Pavucontrol (for audio controlling) - https://freedesktop.org/software/pulseaudio/pavucontrol/
   5. ntfs-3g (for NTFS read/write support) - https://wiki.archlinux.org/title/NTFS-3G
   6. qbittorrent (torrent client) - https://www.qbittorrent.org/
   7. Lutris (open gaming platform) - https://lutris.net
   8. Python - https://www.python.org/
   9. zsh (shell) ~ https://www.zsh.org/
   10. Alacritty (terminal emulator) - https://alacritty.org/
   11. OBS-Studio (Open Streaming & Recording platform) - https://obsproject.com/
   12. gparted (partition editing platform) - https://gparted.org/
   13. Steam (Gaming platform) - https://steampowered.com ( Removed for now due to some issues )
   14. Bitwarden (Open Password manager) - https://bitwarden.com
   15. git - https://github.com
   16. kdenlive (Libre video editor) - https://kdenlive.org/en/
   17. Oracle VM VirtualBox (a free and open-source hosted hypervisor for x86 virtualization) - https://www.virtualbox.org/
   18. plex-media-server (Multimedia streaming platform) - https://plex.tv
   19. python-pip (Package installer for Python) - https://pypi.org/project/pip/
   20. VLC (Open Media player) - https://www.videolan.org/vlc/
   21. Spotify (Online music player) - https://spotify.com
   22. Discord (VoIP, instant messaging and digital distribution platform) - https://discord.com
   23. Sublime-text (Text editor) - https://sublimetext.com
   24. Timeshift (back-up & restore util for Linux) - https://linuxmasterclub.com/timeshift/
   25. Gaming mode & Gaming optimizations by Chris Titus - https://www.youtube.com/watch?v=xvrft9ULvho , https://www.christitus.com/ultimate-linux-gaming-guide/,
   26. Glorious-Eggroll Proton configuration - https://github.com/GloriousEggroll
   27. Protonup (Steam proton update utility)(Python) - https://pypi.org/project/protonup/
   28. Xorg (X Window System display server) - https://www.x.org/wiki/
   29. Brave (Chromium based privacy browser) - https://brave.com/
   30. UFW (Firewall) - ?
   31. Nano (GNU Text editor) - https://www.nano-editor.org/
   32. Code (Microsoft Visual studio code) - https://code.visualstudio.com/
   33. Gimp (GNU Image Manipulation Program) - https://www.gimp.org/
   34. Atom (Free and open-source text and source code editor) - https://atom.io/
   35. Common Java runtimes & Libs
   36. Pulseaudio ( Audio server )
------------------------------------------------------------------------------------------------------------------------------
**You can change the installation packages by editing the "install.sh" script file on < Line: 235 > for all pacman packages 
<br>and < Line: 327 > for all yay packages**

# How to install?
<pre>
<code>
   git clone https://github.com/AbenOG/install_script.git
   cd install_script
   chmod +x install.sh
   ./install.sh
</code>
</pre>

------------------------------------------------------------------------------------------------------------------------------

You are more than welcome to dig in and contribute to this project, don't be a stranger! 
More features to come soon!
