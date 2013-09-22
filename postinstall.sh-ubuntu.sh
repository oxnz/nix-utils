#!/bin/sh
if [ `id -u` -ne 0 ]
then
	echo "Root privilige needed"
	exit 1
fi

# disable guest account
echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
# disable remote login
echo "greeter-show-remote-login=false" >> /etc/lightdm/lightdm.conf

# set gedit
gsettings set org.gnome.gedit.preferences.encodings auto-detected "['UTF-8', 'GB18030', 'GB2312', 'GBK', 'BIG5', 'CURRENT', 'ISO-8859-15', 'UTF-16']"

# mp3 file name
export PATH=$PATH GST_ID3_TAG_ENCODING=GBK:UTF-8:GB18030
export PATH=$PATH GST_ID3V2_TAG_ENCODING=GBK:UTF-8:GB18030

# install skype
sudo apt-get install libxss1 libqtwebkit4
sudo dpkg -i skype*.deb

echo “安装必要软件”
p7zip
unrar 
flash-plugin-installer
vim-data

echo "字体配置"
mkfontdir
fc-cache -fv
