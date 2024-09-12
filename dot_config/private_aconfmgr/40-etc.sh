CopyFile /etc/adjtime
CopyFile /etc/crypttab
CopyFile /etc/fstab
CopyFile /etc/hostname
CopyFile /etc/locale.conf
CopyFile /etc/locale.gen
CreateLink /etc/localtime /usr/share/zoneinfo/America/New_York
CopyFile /etc/machine-id 444
CopyFile /etc/mkinitcpio.conf
CopyFile /etc/mkinitcpio.d/linux.preset
CreateLink /etc/os-release ../usr/lib/os-release
CopyFile /etc/pacman.conf
CopyFile /etc/shells
CopyFile /etc/vconsole.conf
