# Prevent Windows and Linux fighting over time. Prevent Linux from changing time on the mobo

timedatectl set-local-rtc 1 --adjust-system-clock

# Proton VPN
sudo apt install -y openvpn dialog python3-pip python3-setuptools
sudo pip3 install protonvpn-cli

# Brave Browser

sudo apt install -y apt-transport-https curl

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install -y brave-browser


# Install other applications
sudo apt install -y ultracopier  chromium-browser gimp vim arandr git qbittorrent neofetch samba flameshot dconf-editor xclip cowsay lolcat meld remmina remmina-plugin-rdp filezilla firefox gtkhash inkscape nemo-gtkhash keepassxc ttf-mscorefonts-installer

# Install flatpaks
flatpak install flathub org.x.Warpinator

# Install rclone
curl https://rclone.org/install.sh | sudo bash

# youtube downloader
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

# Install Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

# Install Guake
sudo add-apt-repository ppa:linuxuprising/guake
sudo apt-get update
sudo apt install -y guake

# Install VirtualBox
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
printf "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install -y virtualbox-6.0

############################## Development Tools Start ##############################

# Install ASPNET Core
wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo apt-get install -y dotnet-sdk-2.2
sudo apt-get install -y aspnetcore-runtime-2.2
sudo apt-get install -y dotnet-sdk-3.1
sudo apt-get install -y aspnetcore-runtime-3.1

# Install nodejs
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
printf '\nexport PATH=~/.npm-global/bin:$PATH' | tee -a ~/.profile
source ~/.profile

# Install SQL Server

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
printf "\n$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y mssql-server

# Run SQL Server Setup

sudo /opt/mssql/bin/mssql-conf setup

# Install SQL CMD line tools

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update 
sudo apt-get install -y mssql-tools unixodbc-dev

# Increase the number of files linux will monitor for changes. This is mainly for Angular so it can watch for file changes
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

############################## Development Tools End ##############################

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# Install FreeCAD
sudo add-apt-repository ppa:freecad-maintainers/freecad-stable
sudo apt-get update
sudo apt install -y freecad

# Disable services which aren't used often

sudo systemctl stop mssql-server.service
sudo systemctl disable mssql-server.service

# Remove default installed programs
sudo apt remove -y thunderbird
sudo apt remove -y rhythmbox
sudo apt remove -y transmission-gtk
sudo apt remove -y mintbackup

# Set up dotfile repo
git clone --bare git@github.com:badmotorfinger/homeConfigs.git $HOME/dotFiles
git config --local status.showUntrackedFiles no

