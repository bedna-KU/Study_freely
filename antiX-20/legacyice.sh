#!/bin/bash

# --------------------------------------
# Script to convert antiX16 to LegacyIce
# --------------------------------------

# (Only GTK and QT application)
# (In alphabetical order)

### Set background
echo -e "\e[40m\n\n"

### Velcome
echo -e "\e[93m----------------------------------------------------------\e[38;5;46m"
echo -e "\e[93m-- Installation Study freely by Bedna                    -\e[38;5;46m"
echo -e "\e[93m----------------------------------------------------------\e[38;5;46m\n"

### Goto to home directory
cd ~

# --------------------------------------
### Test architecture
# --------------------------------------
echo -e "\e[93m- Test architecture\e[38;5;46m\n"

if [ `arch` == "x86_64" ];then
	echo -e "Architecture x86 64bit\n\n"
	architecture="amd64"
	architecture_x="x86_64"
elif [[ `arch` == i* ]];then
	echo -e "Architecture x86 32bit\n\n"
	architecture="i386"
	architecture_x="i386"
else
	echo -e "Unsupported architecture\n\n"
	exit 1
fi

# --------------------------------------
### Add/remove packages
# --------------------------------------

### Upgrade system
echo -e "\e[93m- Upgrade system\e[38;5;46m\n"
sudo apt-get --yes update
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade
sudo apt-get --yes autoremove

echo -e "\e[93m- Install programs\e[38;5;46m\n"

### Core tools
sudo apt-get --yes install autopoint autoconf bc debfoster curl dh-autoreconf git g++ \
hsetroot intltool key-mon libgtk2.0-dev libnotify-bin linuxdoc-tools numlockx \
subversion synaptic telnet wget whois wmctrl software-properties-common xfce4-notifyd xfce4-terminal \
xosd-bin

### Graphics programs
sudo apt --yes install blender gimp inkscape

### Multimedia programs
sudo apt --yes install pulseaudio pavucontrol pasystray

### Communication programs
sudo apt --yes install mumble hexchat

### Network programs
sudo apt --yes install filezilla

### Utils
sudo apt --yes install galculator

### Languages
sudo apt-get --yes install libreoffice-l10n-sk myspell-sk hyphen-sk hunspell-sk firefox-esr-l10n-sk aspell-sk

# --------------------------------------
### SET THEMES
# --------------------------------------

# --------------------------------------
### SET CONFIGS
# --------------------------------------

### Download IceWM config files
echo -e "\e[93m- Download IceWM config files\e[38;5;46m\n"
if [[ -e "/home/$USER/.icewm" ]]; then
	num=1
	while [[ -e "/home/$USER/.icewm-back-$num" ]]; do
		(( num++ ))
	done
	mv "/home/$USER/.icewm" "/home/$USER/.icewm-back-$num"
fi
svn checkout https://github.com/KERNELULTRAS/LegacyIce-antiX.git/trunk/.icewm

### COMPOSITOR

### Download compositor config files
echo -e "\e[93m- Setup compositor\e[38;5;46m\n"
wget -P /tmp https://raw.githubusercontent.com/KERNELULTRAS/LegacyIce-antiX/master/antiX-15/compton.conf
if [[ -e "/home/$USER/.config/compton.conf" ]]; then
	num=1
	while [[ -e "/home/$USER/.config/compton.conf-back-$num" ]]; do
		(( num++ ))
	done
	mv "/home/$USER/.config/compton.conf" "/home/$USER/.config/compton.conf-back-$num"
fi
mv /tmp/compton.conf $HOME/.config/compton.conf

### Backup .bashrc
if [[ -e "/home/$USER/.bashrc" ]]; then
	num=1
	while [[ -e "/home/$USER/.bashrc.conf-back-$num" ]]; do
		(( num++ ))
	done
	cp "/home/$USER/.bashrc" "/home/$USER/.bashrc.conf-back-$num"
fi

### Echo LegacyIce textinfo
echo -e "\e[93m- Add TEXT to .bashrc\e[38;5;46m\n"
if grep -q "@   @@@ @@@ @@@ @@@ @ @  @ @@@ @@@" .bashrc
then
    echo -e "\e[93m- Skip .bashrc\e[38;5;46m\n"
else
	echo -e "\e[93m- Setup .bashrc\e[38;5;46m\n"
	echo "
	echo -e \"\e[91m\"
	echo \"@   @@@ @@@ @@@ @@@ @ @  @ @@@ @@@\"
	echo \"@   @   @   @ @ @   @ @  @ @   @\"
	echo \"@   @@@ @ @ @@@ @   @@@  @ @   @@@        /\\\\\"
	echo \"@   @   @ @ @ @ @    @   @ @   @     /\\\\  /  \\\\  /\\\\\"
	echo \"@@@ @@@ @@@ @ @ @@@  @   @ @@@ @@@  /  \\\\/    \\\\/  \\\\\"
	echo -e \"\e[94m---------------------------------------------------\"">>$HOME/.bashrc
	echo "date">>$HOME/.bashrc
	echo "
	echo \"---------------------------------------------------\"
	echo -e \"\e[37m\"">>$HOME/.bashrc
	echo "[ -n \"${PATH##*/sbin*}\" ] && PATH=$PATH:/sbin:/usr/sbin">>$HOME/.bashrc
fi

### Clutter off (Off hide mouse)
echo -e "\e[93m- Clutter off\e[38;5;46m\n"
if [[ -e "/etc/default/unclutter" ]]; then
	sudo sed -i 's/START_UNCLUTTER=true/START_UNCLUTTER=false/g' /etc/default/unclutter
	pkill unclutterf
fi

### Resize winoptions by xrandr
echo -e "\e[93m- Setup Winoptions\e[38;5;46m\n"
chmod +x .icewm/winoptions.sh
./.icewm/winoptions.sh

### Create menu
echo -e "\e[93m- Create menu\e[38;5;46m\n"
sudo sh -c "icewm-menu-fdo > /usr/share/icewm/menu"

### Update menu after install or uninstall programs
echo -e "\e[93m- Setup autoupdate menu\e[38;5;46m\n"
sudo sh -c "echo 'DPkg::Post-Invoke {\"xde-menu --menugen --wmname=icewm --format=icewm --root-menu /etc/xdg/menus/lxde-applications.menu --nolaunch --output /usr/share/icewm/menu\";};' >/etc/apt/apt.conf.d/99-update-menus"
sudo xde-menu --menugen --wmname=icewm --format=icewm --root-menu /etc/xdg/menus/lxde-applications.menu --nolaunch --output /usr/share/icewm/menu 

### Rename ice_user_name to active user
echo -e "\e[93m- Setup user name\e[38;5;46m\n"
find ~/.icewm -type f -print0 | xargs -0 sed -i "s/mario/$USER/g"

### END OF SCRIPT
echo -e "\n"
echo -e "\e[93m##################################################\e[38;5;46m\n"
echo -e "\e[93m##################################################\e[38;5;46m\n"
echo -e "\n"
echo -e "\e[93m- Done, please restart and change session to IceWM\e[38;5;46m\n"
echo -e "\e[93m- Good luck\e[38;5;46m\n"
echo -e "\e[0m\n"
