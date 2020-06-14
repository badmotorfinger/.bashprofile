echo 'Ensure you have the backup_home and installation_packages variable set to the correct location'
echo 'Also ensure you have the packages WebStorm, Rider, DataGrip, pencil available for installation'

read -p "Press ENTER to continue"

backup_home=/media/vince/LinuxStorage/homebackup/vince
installation_packages=/home/vince/Downloads/LinuxRestore

# Prevent Windows and Linux fighting over time. Prevent Linux from changing time on the mobo

timedatectl set-local-rtc 1 --adjust-system-clock

# Copy Brave Browser profile from backup

cp -rpv $backup_home/.config/BraveSoftware ~/.config/BraveSoftware

# Copy old home data

cp -v $backup_home/.bashrc ~/
cp -v $backup_home/.profile ~/
cp -v $backup_home/fancy-bash-prompt.sh ~/
cp -v $backup_home/z.sh ~/
cp -v $backup_home/.z ~/
cp -v $backup_home/.bash_history ~/
cp -v $backup_home/.gitconfig ~/
cp -vr $backup_home/.ssh ~/.ssh
cp -v $backup_home/homescreenlayout.sh ~/
cp -v $backup_home/startup.sh ~/
cp -v $backup_home/.vim_mru_files ~/
cp -vrp $backup_home/.git-radar/ ~/.git-radar
cp -vrp $backup_home/.FreeCAD ~/FreeCAD
cp -vrp $backup_home/sourcecode ~/sourcecode

# Brave Browser

sudo apt install -y apt-transport-https curl

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install -y brave-browser


# Install other applications

sudo apt install -y chromium-browser gimp vim arandr git qbittorrent neofetch shutter dconf-editor xclip cowsay lolcat meld remmina remmina-plugin-rdp filezilla ttf-mscorefonts-installer

# Install Guake
sudo add-apt-repository ppa:linuxuprising/guake
sudo apt-get update
sudo apt install -y guake

#bash restore

echo "vm.swappiness=1" | sudo tee -a /etc/sysctl.conf
printf "\ndisplay-setup-script=/home/vince/homescreenlayout.sh" | sudo tee -a /etc/lightdm/lightdm.conf.d/70-linuxmint.conf
printf "\nsession-setup-script=/home/vince/homescreenlayout.sh" | sudo tee -a /etc/lightdm/lightdm.conf.d/70-linuxmint.conf

# Install VirtualBox
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
printf "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install -y virtualbox-6.0

# Tell git not to show untracked files for the dotFiles repository
git clone --bare git@github.com:vincpa/dotFiles.git $HOME/dotFiles
config config --local status.showUntrackedFiles no

# Install packaged software which is not in a repository
sudo tar xzf $installation_packages/WebStorm*.tar.gz -C /opt/
sudo tar xzf $installation_packages/datagrip*.tar.gz -C /opt/
sudo tar xzf $installation_packages/JetBrains*.tar.gz -C /opt/
sudo apt install ./pencil_3.1.0.ga_amd64.deb

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


# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install Inkscape
sudo add-apt-repository ppa:inkscape.dev/stable
sudo apt update
sudo apt install -y inkscape

# Remove default installed programs
sudo apt remove -y thunderbird
sudo apt remove -y rhythmbox
sudo apt remove -y transmission-gtk
sudo apt remove -y mintbackup

# Install FreeCAD
sudo add-apt-repository ppa:freecad-maintainers/freecad-stable
sudo apt-get update
sudo apt install -y freecad

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

# Disable services which aren't used often

sudo systemctl stop mssql-server.service
sudo systemctl disable mssql-server.service

# Increase the number of files linux will monitor for changes. This is mainly for Angular so it can watch for file changes

echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system
