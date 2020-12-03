echo 'Ensure you have the backup_home and installation_packages variable set to the correct location'
echo 'Also ensure you have the packages WebStorm, Rider, DataGrip, pencil available for installation'

read -p "Press ENTER to continue"

backup_home=/media/vince/LinuxStorage/homebackup/vince
installation_packages=/home/vince/Downloads/LinuxRestore


# Copy old home data

cp -v $backup_home/.bashrc ~/
cp -v $backup_home/.profile ~/
cp -v $backup_home/fancy-bash-prompt.sh ~/
cp -v $backup_home/z.sh ~/
cp -v $backup_home/.z ~/
cp -v $backup_home/.bash_history ~/
cp -v $backup_home/.gitconfig ~/
cp -vr $backup_home/.ssh ~/.ssh
cp -v $backup_home/startup.sh ~/
cp -v $backup_home/.vim_mru_files ~/
cp -vrp $backup_home/.git-radar/ ~/.git-radar
cp -vrp $backup_home/.FreeCAD ~/.FreeCAD
cp -vrp $backup_home/sourcecode ~/sourcecode

# Needed for Virt-Manager
# sudo apt install -y libvirt-bin gir1.2-spiceclientgtk-3.0


# Install Bpytop
# sudo python3 -m pip install psutil
# git clone https://github.com/aristocratos/bpytop.git
# cd bpytop
# sudo make install


echo "vm.swappiness=1" | sudo tee -a /etc/sysctl.conf

# Tell git not to show untracked files for the dotFiles repository
git clone --bare git@github.com:badmotorfinger/homeConfigs.git $HOME/dotFiles
config config --local status.showUntrackedFiles no



# Install Lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt-get update
sudo apt-get install lutris

# Enable Samba
# sudo systemctl enable ufw.service --now
# sudo ufw enable
# sudo ufw allow proto udp to any port 137 from 192.168.1.0/24
# sudo ufw allow proto udp to any port 138 from 192.168.1.0/24
# sudo ufw allow proto tcp to any port 139 from 192.168.1.0/24
# sudo ufw allow proto tcp to any port 445 from 192.168.1.0/24
# Enable NetBIOS
# sudo iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns

