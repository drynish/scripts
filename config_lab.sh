#!/bin/sh

echo "deb http://mirror.csclub.uwaterloo.ca/debian stretch main contrib non-free" > /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security stretch main contrib non-free" >> /etc/apt/sources.list

apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install -y --force-yes build-essential sudo iceweasel file-roller gdb cmake libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev doxygen git

usermod -G sudo etudiant 

wget --content-disposition "https://data.services.jetbrains.com/products/download?code=CL&platform=linux" -P /tmp
wget --content-disposition "https://data.services.jetbrains.com/products/download?code=PS&platform=linux" -P /tmp

for file in /tmp/*.tar.gz 
do
	tar -xzf $file -C /home/etudiant
done

mv /home/etudiant/PhpStorm* /home/etudiant/phpstorm
mv /home/etudiant/clion* /home/etudiant/clion

chown -R etudiant.etudiant /home/etudiant/phpstorm /home/etudiant/clion

mkdir /home/etudiant/Bureau
echo "xfconf-query --channel thunar –-property /misc-exec-shell-scripts-by-default --create --type bool --set true" >> /home/etudiant/Bureau/ExecuteScript.sh
chmod +x /home/etudiant/Bureau/ExecuteScript.sh

rm config_linux.sh
