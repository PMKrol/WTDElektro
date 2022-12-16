#! /bin/bash

sudo apt update

#sudo apt remove unattended-upgrades modemmanager -y
sudo apt remove  modemmanager -y
sudo apt install openssh-server openssh-client x11vnc arduino screen mc openjdk-11-jre  -y

sudo usermod -a -G dialout $USER

#unattended
#sudo nano /etc/apt/apt.conf.d/20auto-upgrades
sudo cp /usr/share/unattended-upgrades/20auto-upgrades-disabled  /etc/apt/apt.conf.d/

#Disable wifi settings access
icon=disable-network-control.pkla

echo [Wifi management] > $icon
echo "Identity=unix-user:*" >> $icon
echo Action=org.freedesktop.NetworkManager.settings.* >> $icon
echo ResultAny=no >> $icon
echo ResultInactive=no >> $icon
echo ResultActive=no >> $icon

echo [Wifi sysad management] >> $icon
echo "Identity=unix-group:sudo;unix-user:root" >> $icon
echo Action=org.freedesktop.NetworkManager.settings.* >> $icon
echo ResultAny=yes >> $icon
echo ResultInactive=yes >> $icon
echo ResultActive=yes >> $icon

sudo cp disable-network-control.pkla /etc/polkit-1/localauthority/50-local.d/disable-network-control.pkla

#Disable screen-lock
#TODO
#kwriteconfig5 --file kscreensaverrc --group Daemon --key Autolock false

#Disable sleep
#TODO
sudo systemctl mask sleep.target suspend.target

#Set power-button to off
#TODO

### VNC ####
sudo apt install net-tools nmap -y
icon=x11vnc.service

echo '# File: /etc/systemd/system/x11vnc.service' > $icon
echo '[Unit]' >> $icon
echo 'Description="x11vnc"' >> $icon
echo 'Requires=display-manager.service' >> $icon
echo 'After=display-manager.service' >> $icon
echo '' >> $icon
echo '[Service]' >> $icon
echo 'ExecStart=/usr/bin/x11vnc -loop -nopw -xkb -repeat -noxrecord -noxfixes -noxdamage -forever -rfbport 5900 -display :0 -auth guess' >> $icon
echo '#ExecStart=/usr/bin/x11vnc -loop -nopw -noxdamage -forever -rfbport 5900 -auth guess -display :0' >> $icon
echo 'ExecStop=/usr/bin/killall x11vnc' >> $icon
echo 'Restart=on-failure' >> $icon
echo 'RestartSec=2' >> $icon
echo 'User=student' >> $icon
echo '' >> $icon
echo '[Install]' >> $icon
echo 'WantedBy=multi-user.target' >> $icon

sudo cp $icon /etc/systemd/system/x11vnc.service

sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service
#systemctl status x11vnc.service

### NEW ###
### disable password prompt for poweroff ###
echo "[Allow all users to shutdown]
Identity=unix-user:*
Action=org.freedesktop.login1.power-off-multiple-sessions
ResultAny=yes
ResultActive=yes
[Allow all users to reboot]
Identity=unix-user:*
Action=org.freedesktop.login1.reboot-multiple-sessions
ResultAny=yes
ResultActive=yes
[Allow all users to suspend]
Identity=unix-user:*
Action=org.freedesktop.login1.suspend-multiple-sessions
ResultAny=yes
ResultActive=yes
[Allow all users to ignore inhibit of shutdown]
Identity=unix-user:*
Action=org.freedesktop.login1.power-off-ignore-inhibit
ResultAny=yes
ResultActive=yes
[Allow all users to ignore inhibit of reboot]
Identity=unix-user:*
Action=org.freedesktop.login1.reboot-ignore-inhibit
ResultAny=yes
ResultActive=yes
[Allow all users to ignore inhibit of suspend]
Identity=unix-user:*
Action=org.freedesktop.login1.suspend-ignore-inhibit
ResultAny=yes
ResultActive=yes
" | sudo tee /etc/polkit-1/localauthority/50-local.d/nofurtherlogin.pkla

### hosts
#sudo nano /etc/hostname
#sudo nano /etc/hosts

cd $HOME/Pobrane
wget https://github.com/PMKrol/WTDElektro/archive/refs/heads/main.zip -O main.zip
7z x main.zip -aoa
cd WTDElektro-main/processing/ameduino/application.linux32
sudo mkdir /usr/local/bin/ameduino32
sudo cp -r * /usr/local/bin/ameduino32
sudo chmod +x /usr/local/bin/ameduino32/ameduino
sudo chown student /usr/local/bin/ameduino32 -R

#Create icon
echo "installing ameduino desktop icon"

icon=$HOME/Pulpit/ameduino.desktop

if [ -e $icon ]; then
	{
	echo "removing old icon ..."
	rm $icon
	}
fi

echo [Desktop Entry] >> $icon
echo Version=1.0 >> $icon
echo Type=Application >> $icon
echo Name=ameduino >> $icon
echo Comment= >> $icon
echo Exec=/usr/local/bin/ameduino >> $icon
echo Icon= >> $icon
echo Path= >> $icon
echo Terminal=false >> $icon
echo StartupNotify=false >> $icon

#End of create icon


### useradd and mod ###
sudo adduser san
sudo usermod -a -G sudo san
sudo adduser san dialout
echo "User san"
#su san -P -c "sudo deluser student sudo"
