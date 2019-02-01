#!/bin/bash

CONFIG="`dirname \"$0\"`/data"
GO_VERSION=go1.11.4
DUET_VERSION=0.5.2
CONCOURSE_VERSION=v3.4.1
COMPOSE_VERSION=1.18.0
INTELLIJ_VERSION=ideaIC-2017.2.4
WEBSTORM_VERSION=WebStorm-2017.2.4
PYCHARM_VERSION=pycharm-community-2017.2.3

# apt-get update && dist-upgrade
echo "********************************"
echo "*   Updating All The Things    *"
echo "********************************"
apt update 
echo yes | apt upgrade
echo yes | apt install libnss3-tools

# install SSL certs
echo "********************************"
echo "* Installing DellEMC SSL certs *"
echo "********************************"
cp ${CONFIG}/sslcerts/*.crt /usr/local/share/ca-certificates/
sudo -u tom mkdir -p /home/tom/.pki/nssdb
sudo -u tom certutil -A -d sql:/home/tom/.pki/nssdb -i /usr/local/share/ca-certificates/EMC_Decrypt.crt -n EMC_Decrypt -t "C,,,"
sudo -u tom certutil -A -d sql:/home/tom/.pki/nssdb -i /usr/local/share/ca-certificates/EMCSSLDecryptionCAv2.crt -n EMC_DecryptionCAv2 -t "C,,,"
sudo -u tom certutil -A -d sql:/home/tom/.pki/nssdb -i /usr/local/share/ca-certificates/EMC_Internal.crt -n EMC_Internal -t "C,,,"
sudo -u tom certutil -A -d sql:/home/tom/.pki/nssdb -i /usr/local/share/ca-certificates/EMC_ROOT.crt -n EMC_ROOT -t "C,,,"
sudo -u tom certutil -A -d sql:/home/tom/.pki/nssdb -i /usr/local/share/ca-certificates/EMC_SSL.crt -n EMC_SSL -t "C,,,"
sudo -u tom certutil -A -d sql:/home/tom/.pki/nssdb -i /usr/local/share/ca-certificates/EMC_User.crt -n EMC_User -t "C,,,"
#wget http://aia.dell.com/int/root/Dell%20Internal%20MSPKI%202015%20Base64_PEM.zip
#unzip "Dell Internal MSPKI 2015 Base64_PEM.zip" -d certs
#rm "Dell Internal MSPKI 2015 Base64_PEM.zip"
#for f in /home/tom/Desktop/certs/*.pem; do
#  openssl x509 -outform der -in "$f" -out "${f%.pem}.crt"
#done
#cp certs/*.crt /usr/local/share/ca-certificates/
#rm -r ./certs

# Chrome
echo "********************************"
echo "*      Installing Chrome       *"
echo "********************************"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --no-check-certificate
dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

### Config Setup
mkdir -p /home/tom/.config/google-chrome/.cache
chown tom /home/tom/.config/google-chrome/.cache
mkdir -p /home/tom/.config/google-chrome/Default
chmod 777 /home/tom/.config/google-chrome/Default
cp ${CONFIG}/chrome/Bookmarks /home/tom/.config/google-chrome/Default/Bookmarks
chmod 555 /home/tom/.config/google-chrome/Default/Bookmarks
chmod -R 777 /home/tom/.config/google-chrome

# git & bison
echo "********************************"
echo "* Installing git other deps  *"
echo "********************************"
echo yes | apt-get -y install git bison

# Fix Firefox
echo "********************************"
echo "*   Fix Firefox cache issue    *"
echo "********************************"
mkdir -p ~/.cache
chown -R $USER:$USER ~/.cache

# Virtualbox
echo "********************************"
echo "*       Installing Vbox        *"
echo "********************************"
echo yes | apt install virtualbox

# Terminator
echo "********************************"
echo "*    Installing Terminator     *"
echo "********************************"
echo yes | apt install terminator
mkdir -p ~/.config/terminator
cp ${CONFIG}/terminator/config ~/.config/terminator/config

# Atom
echo "********************************"
echo "*       Installing Atom        *"
echo "********************************"
#echo yes | apt install atom
wget -O atom-amd64.deb http://atom.io/download/deb
apt install gdebi-core
echo y | sudo gdebi atom-amd64.deb
echo yes | apm install --packages-file ${CONFIG}/atom/packages.list
cp ${CONFIG}/atom/configs/* ~/.atom/
chmod -R 777 /home/tom/.atom
rm atom-amd64.deb

# Golang
echo "******************"
echo "* Install Golang *"
echo "******************"
echo yes | apt install golang-go
#echo yes | apt install gccgo-go

# git-duet
echo "********************************"
echo "*     Installing git-duet      *"
echo "********************************"
wget https://github.com/git-duet/git-duet/releases/download/${DUET_VERSION}/linux_amd64.tar.gz
tar -xvf linux_amd64.tar.gz -C /usr/local/bin
echo "export GIT_DUET_ROTATE_AUTHOR=1" >> ~/.bashrc
echo "export GIT_DUET_GLOBAL=true" >> ~/.bashrc
echo "git config --global alias.ci duet-commit" >> ~/.bashrc
rm linux_amd64.tar.gz

# fly
echo "********************************"
echo "*        Installing fly        *"
echo "********************************"
wget https://github.com/concourse/concourse/releases/download/${CONCOURSE_VERSION}/fly_linux_amd64
mv fly_linux_amd64 /usr/local/bin/fly
chmod a+x /usr/local/bin/fly

# docker
echo "********************************"
echo "*      Installing docker       *"
echo "********************************"
echo yes | apt install curl
curl -fsSL https://get.docker.com/ | sh
ME=$USER
usermod -aG docker $ME
systemctl enable docker
cp -r ${CONFIG}/docker/* /usr/local/bin/
wget "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -O /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose

# Miscellaneous scripts
echo "********************************"
echo "*    Miscellaneous scripts     *"
echo "********************************"
cp ${CONFIG}/misc/* /usr/local/bin/

# Miscellaneous scripts
echo "********************************"
echo "*   Install Postman as a deb   *"
echo "********************************"
wget https://dl.pstmn.io/download/latest/linux64 -O /tmp/postman.tar.gz
rm -rf /opt/Postman
tar -xzf /tmp/postman.tar.gz -C /opt
rm /tmp/postman.tar.gz
rm -f /usr/bin/postman
ln -s /opt/Postman/Postman /usr/bin/postman

# Intellij
echo "********************************"
echo "*         Intellij             *"
echo "********************************"
apt install snapd
snap install intellij-idea-community --classic --edge

# WebStorm
echo "********************************"
echo "*          WebStorm            *"
echo "********************************"
mkdir /opt/webstorm
wget https://download.jetbrains.com/webstorm/${WEBSTORM_VERSION}.tar.gz -O /opt/webstorm/${WEBSTORM_VERSION}.tar.gz
tar -xvf /opt/webstorm/${WEBSTORM_VERSION}.tar.gz -C /opt/webstorm --strip-components=1
cp ${CONFIG}/jetbrains/webstorm.desktop /opt/webstorm/webstorm.desktop
echo "alias webstorm=/opt/webstorm/bin/webstorm.sh" >> ~/.bashrc
rm /opt/webstorm/${WEBSTORM_VERSION}.tar.gz

# PyCharm
echo "********************************"
echo "*          PyCharm             *"
echo "********************************"
mkdir /opt/pycharm
wget https://download.jetbrains.com/python/${PYCHARM_VERSION}.tar.gz -O /opt/pycharm/${PYCHARM_VERSION}.tar.gz
tar -xvf /opt/pycharm/${PYCHARM_VERSION}.tar.gz -C /opt/pycharm --strip-components=1
cp ${CONFIG}/jetbrains/pycharm.desktop /opt/pycharm/pycharm.desktop
echo "alias pycharm=/opt/pycharm/bin/pycharm.sh" >> ~/.bashrc
rm /opt/pycharm/${PYCHARM_VERSION}.tar.gz

# remove this scripts and config folder
rm /home/tom/Desktop/setup.sh
rm -r /home/tom/Desktop/data
sed -i '$ d' /home/tom/.profile
chown -R tom.tom /home/tom
chmod 700 /home/tom/.config
reboot
