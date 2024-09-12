CopyFile /etc/adjtime
CopyFile /etc/crypttab
CopyFile /etc/fstab
CopyFile /etc/hostname
CopyFile /etc/locale.conf
CopyFile /etc/locale.gen
CopyFile /etc/machine-id 444
CopyFile /etc/mkinitcpio.conf
CopyFile /etc/mkinitcpio.d/linux.preset
CopyFile /etc/pacman.conf
CopyFile /etc/shells
CopyFile /etc/vconsole.conf
CreateLink /etc/localtime /usr/share/zoneinfo/America/New_York
CreateLink /etc/os-release ../usr/lib/os-release
CreateLink /usr/lib/vmware/view/pkcs11/libopenscpkcs11.so /usr/lib64/pkcs11/opensc-pkcs11.so 
