#!/bin/sh

# Load functions.
. /functions.sh

echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mLoading fake time..."
date -s "2026-01-01 12:00:00"

mkdir /temp
mkdir /backup

echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mSearching for the USB Drive..."
sleep 2
for x in a b c d e f g h i j k
do
	device="/dev/sd"$x
  mount $device"1" /temp > /dev/null
  if [ $? = 0 ]; then
  	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mPotential USB Drive found - \e[32m\e[1m$device\e[39m\e[0m!"
  	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mSearching for Batocera installation archive & other files..."
		if [ -e /temp/bzImage ] && [ -e /temp/initramfs.cpio.gz ] && ls /temp/batocera_ps4*.tar.xz 1> /dev/null 2>&1; then
			echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[32m\e[1mDevice $device has the necessary files to install Batocera for PS4!"
			break;
		fi
		umount /temp
	fi
	if [ $x = "k" ]; then
		echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[31m\e[1mERROR! Valid USB Drive not found! Try to reinsert the USB Drive and run \e[32m\e[1mexec install.sh."
		echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mPress Ctrl+Alt+Del to reboot into PS4 Orbis."
	rescueshell
	fi
done

sizeusb=$(fdisk -l | grep -i "Disk $device" | awk '{print $3}')
mu=$(fdisk -l | grep -i "Disk $device" | awk '{print $4}')
sizeusb=$(echo $sizeusb | awk -F',' '{print $1}')
mu=$(echo $mu | awk -F',' '{print $1}')

echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[32m\e[1mSize of selected USB Drive: $sizeusb $mu"
if [ "$mu" != "GB" ] || [ $sizeusb -lt 20 ]; then
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[31m\e[1mERROR! Insufficient space on USB Drive! Use a USB Drive with atleast 20GB storage."
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mPress Ctrl+Alt+Del to reboot into PS4 Orbis."
	exit
fi

echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mBeginning Batocera for PS4 installation..."
sleep 2
echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mCopying files to /backup..."
tarname=$(cd /temp && ls | grep batocera_ps4*.tar.xz);

echo -e "\e[34m\e[1m>> \e[39m\e[0mCopying \e[34m\e[1m$tarname\e[39m\e[0m..."
pv /temp/${tarname} > /backup/${tarname}

if [ $? -ne  0 ]; then
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[31m\e[1mERROR! Insufficient RAM!"
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mTry using 1GB VRAM payload."
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mPress Ctrl+Alt+Del to reboot into PS4 Orbis."
	rescueshell
fi

echo -e "\e[34m\e[1m>> \e[39m\e[0mCopying \e[34m\e[1minitramfs.cpio.gz\e[39m\e[0m..."
pv /temp/initramfs.cpio.gz > /backup/initramfs.cpio.gz
if [ $? -ne  0 ]; then
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[31m\e[1mERROR! Insufficient RAM!"
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mTry using 1GB VRAM payload."
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mPress Ctrl+Alt+Del to reboot into PS4 Orbis."
	rescueshell
fi

echo -e "\e[34m\e[1m>> \e[39m\e[0mCopying \e[34m\e[1mbzImage\e[39m\e[0m..."
pv /temp/bzImage > /backup/bzImage
if [ $? -ne  0 ]; then
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[31m\e[1mERROR! Insufficient RAM!"
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mTry using 1GB VRAM payload."
	echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mPress Ctrl+Alt+Del to reboot into PS4 Orbis."
	rescueshell
fi

if [ -f /temp/bootargs.txt ]; then
	echo -e "\e[34m\e[1m>> \e[39m\e[0mCopying \e[34m\e[1mbootargs.txt\e[39m\e[0m..."
	pv /temp/bootargs.txt > /backup/bootargs.txt
	if [ $? -ne 0 ]; then
		echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[31m\e[1mERROR! Failed to copy bootargs.txt"
		rescueshell
	fi
else
	echo -e "\e[33m\e[1m>> \e[39m\e[0mbootargs.txt not found, skipping."
fi

umount /temp

sleep 2
echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mCreating partitions for Batocera..."
(
echo "o"
echo "d"
echo "n"
echo "p"
echo "1"
echo #default
echo "+50M"
echo "n"
echo "p"
echo "2"
echo #default
echo "+16G"
echo "n"
echo "p"
echo "3"
echo #default
echo #default
echo "w"
echo "q"
) | fdisk $device > /dev/null

sleep 2
echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mFormatting partitions. Please wait..."
while sleep 0.2; do printf "."; done &
mkfs.vfat -n BOOT $device"1" > /dev/null
mke2fs -t ext4 -F -L BATOCERA -O ^has_journal $device"2" > /dev/null 2>&1
mke2fs -t ext4 -F -L SHARE -O ^has_journal $device"3" > /dev/null 2>&1
kill $!

sleep 1
echo -e "\n\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mMounting new partitions and copying files in /backup to them..."
mount $device"1" /temp
echo -e "\e[34m\e[1m>> \e[39m\e[0mCopying \e[34m\e[1minitramfs.cpio.gz\e[39m\e[0m..."
pv /backup/initramfs.cpio.gz > /temp/initramfs.cpio.gz
echo -e "\e[34m\e[1m>> \e[39m\e[0mCopying \e[34m\e[1mbzImage\e[39m\e[0m..."
pv /backup/bzImage > /temp/bzImage

if [ -f /backup/bootargs.txt ]; then
	echo -e "\e[34m\e[1m>> \e[39m\e[0mCopying \e[34m\e[1mbootargs.txt\e[39m\e[0m..."
	pv /backup/bootargs.txt > /temp/bootargs.txt
fi

umount /temp

sleep 1
mount $device"2" /newroot

echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mBeginning Batocera installation..."
sleep 5

echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mExtracting Batocera for PS4..."
pv /backup/${tarname} | tar -xpJf - -C /newroot --numeric-owner --warning=none

echo -e "\n\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mPreparing batocera config files..."

    output=$(blkid "${device}3" | awk 'BEGIN{FS="[=\"]"} {print $(NF-4)}')

    if [ -n "$output" ]; then
        echo "OK: detected UUID for userdata: $output"

        if cat <<EOT >> /newroot/boot/batocera-boot.conf
sharedevice=DEV $output
splash.screen.enabled=1
system.hostname=BATOCERA
EOT
        then
            echo "OK: batocera-boot.conf updated"
        else
            echo "ERROR: failed to write batocera-boot.conf"
        fi
    else
        echo "ERROR: failed to detect UUID for ${device}4"
    fi
	
	# Ensure /boot/boot directory exists (Batocera expects this)
	if [ ! -d /newroot/boot/boot ]; then
		mkdir -p /newroot/boot/boot && echo " Created /boot/boot"
	fi

	# Create batocera.board only once
	BOARD_FILE="/newroot/boot/boot/batocera.board"

	if [ ! -f "$BOARD_FILE" ]; then
		echo "PS4" > "$BOARD_FILE"
		echo "Created batocera.board"
	else
		echo "batocera.board already exists"
	fi

echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mCleaning up..."
rm /backup/*
rm -R /newroot/lost+found

echo -e "\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mAdding EAP key..."
cp /key/eap_hdd_key.bin /newroot/etc/cryptmount > /dev/null
#cp /lib/firmware/edid/my_edid.bin /newroot/lib/firmware/edid > /dev/null

echo -e "\n\e[31m\e[1m>\e[34m\e[1m>\e[31m\e[1m> \e[39m\e[0mInstallation completed successfully."

echo -e "\n\e[33m\e[1mIMPORTANT:\e[39m\e[0m"
echo -e "The system will reboot in 10 seconds on PS4 Orbis."
echo -e "After reboot, load the \e[1mLinux payload with 2GB VRAM\e[0m to start Batocera."
echo ""

echo -n "Rebooting in: "
for i in 10 9 8 7 6 5 4 3 2 1; do
    echo -n "$i "
    sleep 1
done
echo ""

sync
sleep 1

echo -e "\nRebooting now...\n"

# Try the cleanest reboot methods first
reboot -f 2>/dev/null || \
echo b > /proc/sysrq-trigger 2>/dev/null || \
poweroff -f

