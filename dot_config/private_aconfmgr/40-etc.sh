CopyFile /etc/locale.conf
CopyFile /etc/locale.gen
CopyFile /etc/mkinitcpio.conf
CopyFile /etc/pacman.conf
CopyFile /etc/vconsole.conf
CopyFile /etc/xdg/reflector/reflector.conf
CreateLink /etc/localtime /usr/share/zoneinfo/America/New_York
CreateLink /etc/os-release ../usr/lib/os-release
