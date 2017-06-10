#!/bin/bash


#directories
SRC=$(pwd)
LOGFILE="${SRC}/OpenVPN/LOGFILE.log"
DAEMON="${SRC}/daemon.sh"

touch "$LOGFILE"


openvpn_installed=$(which openvpn)
chrome_installed=$(which google-chrome)

if [ "$openvpn_installed" == "" ];
then
	echo "OpenVPN is not installed" 
	echo "Installing..." 
	sudo apt-get install openvpn >> "$LOGFILE"
else
	echo "OpenVPN is already installed" >> "$LOGFILE"
fi
if [ "$chrome_installed" == "" ];
then
    echo "Google-Chrome is not installed"
    echo "Installing..."

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - >> "$LOGFILE"
	sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' >> "$LOGFILE"
	sudo apt-get update >> "$LOGFILE"
	sudo apt-get install google-chrome-stable >> "$LOGFILE"
else
	echo "Google-Chrome is already installed" >> "$LOGFILE"
fi

UD="$1"

DESK_PATH=/home/$UD/.config/autostart

if [ ! -d "$DESK_PATH" ]; then
	mkdir /home/$UD/.config/autostart
	touch $DESK_PATH/.desktop
	echo "[Desktop Entry]" >> $DESK_PATH/.desktop
	echo "Name=google-chrome" >> $DESK_PATH/.desktop
	echo "Type=Application" >> $DESK_PATH/.desktop
	echo "Exec=google-chrome https://mail.ru/" >> $DESK_PATH/.desktop
	echo "Terminal=false" >> $DESK_PATH/.desktop
else
	#if [ !-f "$DESK_PATH"/.desktop ]; then
	#	touch $DESK_PATH/.desktop
	#fi
	echo "[Desktop Entry]" >> $DESK_PATH/.desktop
	echo "Name=google-chrome" >> $DESK_PATH/.desktop
	echo "Type=Application" >> $DESK_PATH/.desktop
	echo "Exec=google-chrome https://mail.ru/" >> $DESK_PATH/.desktop
	echo "Terminal=false" >> $DESK_PATH/.desktop
fi

#sudo cp "$DAEMON" /etc/init.d
#chmod +x /etc/init.d/deamon.sh
#update-rc.d deamon.sh defaults
sudo sed -i '$ d' /etc/rc.local
sudo sed -i -e '$i sh \$DEAMON start\n exit 0' /etc/rc.local

