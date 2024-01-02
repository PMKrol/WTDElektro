#! /bin/bash

echo "Run as admin!"

#sudo apt install openjdk-11-jre  -y

AVERSION=ameduino_pmkrol2

#cd /home/student/Pobrane
#wget https://github.com/PMKrol/WTDElektro/archive/refs/heads/main.zip -O main.zip
#7z x main.zip -aoa
cd WTDElektro-main/processing/$AVERSION/application.linux64
# sudo rm -r /usr/local/bin/ameduino32
# sudo mkdir /usr/local/bin/ameduino32
# sudo cp -r * /usr/local/bin/ameduino32
# sudo chmod +x /usr/local/bin/ameduino32/$AVERSION
# sudo chown student /usr/local/bin/ameduino32 -R

sudo rm -r /usr/local/bin/ameduino64
sudo mkdir /usr/local/bin/ameduino64
sudo cp -r * /usr/local/bin/ameduino64
sudo chmod +x /usr/local/bin/ameduino64/$AVERSION
sudo chown student /usr/local/bin/ameduino64 -R

symlink=/usr/local/bin/ameduino
sudo rm $symlink
# echo "#!/bin/bash
# #export PATH=\$PATH:`ls /usr/java/jre*/bin/java | sed -e 's/java\$//'` #ok!
# /usr/local/bin/ameduino64/$AVERSION" | sudo tee $symlink
echo "#!/bin/bash
/usr/local/bin/ameduino64/$AVERSION" | sudo tee $symlink

sudo chmod +x $symlink

#Create icon
echo "installing ameduino desktop icon"

icon=/home/student/Pulpit/ameduino.desktop

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
echo Exec=$symlink >> $icon
echo Icon= >> $icon
echo Path= >> $icon
echo Terminal=false >> $icon
echo StartupNotify=false >> $icon

#End of create icon
