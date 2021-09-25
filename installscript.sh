echo "What is the device name (hdd/nvme/ssd)?"
read device_name

echo "Setting time zone"
ln -sf /usr/share/zoneinfo/Europe/Sofia /etc/localtime

hwclock --systohc

echo "Generating locale"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "arch" >> /etc/hostname

echo $'127.0.0.1	localhost\n::1		localhost\n127.0.1.1	arch.localdomain	arch' >> /etc/hosts

echo root:ng | chpasswd

echo "Installing needed software"
pacman -S xorg xorg-server xorg-xinit grub efibootmgr networkmanager mtools vim base-devel git ttf-cascadia-code zsh --noconfirm

echo "Installing grub"
mkdir /grub
mount /dev/"${device_name}1" /grub
grub-install --target=x86_64-efi --efi-directory=/grub --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Enabling needed services"
systemctl enable NetworkManager

echo "Adding the new user"
echo "Name the new user"
read username
useradd -m $username
echo $username:ng | chpasswd
usermod -aG audio,video,storage,wheel $username

echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$username

echo "All is done. Do you want to install more software?"
read install_more

if [[ "$install_more" == "y" ]]
then
    echo "Install KDE?"
    read install_kde

    if [[ "$install_kde" == "y" ]]
    then
        echo "Installing plasma"
        sudo pacman -S plasma-desktop plasma-meta --noconfirm
    fi

    echo "Install awesome wm?"
    read install_awesome

    if [[ "$install_awesome" == "y" ]]
    then
        echo "Installing awesome"
        sudo pacman -S awesome --noconfirm
    fi

    echo "Install qtile?"
    read install_qtile

    if [[ "$install_qtile" == "y" ]]
    then
        echo "Installing qtile"
        sudo pacman -S qtile --noconfirm
    fi

    echo "Install sddm?"
    read install_sddm

    if [[ "$install_sddm" == "y" ]]
    then
        echo "Installing sddm"
        sudo pacman -S sddm --noconfirm
        sudo systemctl enable sddm.service
    fi
fi

echo "everythin done. good luck"
