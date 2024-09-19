

# Thu Sep 19 10:21:02 AM EDT 2024 - Unknown packages


AddPackage dnsmasq # Lightweight, easy to configure DNS forwarder and DHCP server
AddPackage gnome-tweaks # Graphical interface for advanced GNOME 3 settings (Tweak Tool)
AddPackage guestfs-tools # Tools for accessing and modifying guest disk images
AddPackage htop # Interactive process viewer
AddPackage pkgfile # alpm .files metadata explorer
AddPackage qemu-base # A basic QEMU setup for headless environments
AddPackage qemu-full # A full QEMU setup
AddPackage vlc # Multi-platform MPEG, VCD/DVD, and DivX player


# Thu Sep 19 10:21:03 AM EDT 2024 - Unknown foreign packages


AddPackage --foreign auto-cpufreq # Automatic CPU speed & power optimizer
AddPackage --foreign proton-ge-custom-bin # A fancy custom distribution of Valves Proton with various patches


# Thu Sep 19 10:21:03 AM EDT 2024 - Missing foreign packages


RemovePackage --foreign yay-debug


# Thu Sep 19 10:21:03 AM EDT 2024 - New / changed files


CopyFile /etc/brlapi.key 640 '' brlapi
CreateDir /etc/cni/net.d 700
CopyFile /etc/makepkg.conf.d/rust.conf
CopyFile /etc/makepkg.conf.d/rust.conf.pacnew
CopyFile /etc/pacman.conf.pacnew
CopyFile /etc/systemd/logind.conf
CreateLink /etc/systemd/system/hibernate.target /dev/null
CreateLink /etc/systemd/system/hybrid-sleep.target /dev/null
CreateLink /etc/systemd/system/multi-user.target.wants/auto-cpufreq.service /usr/lib/systemd/system/auto-cpufreq.service
CreateLink /etc/systemd/system/power-profiles-daemon.service /dev/null
CreateLink /etc/systemd/system/sleep.target /dev/null
CreateLink /etc/systemd/system/suspend.target /dev/null
CreateDir /opt/containerd/bin 711
CreateDir /opt/containerd/lib 711
CopyFile /usr/lib/vlc/plugins/plugins.dat


# Thu Sep 19 10:21:03 AM EDT 2024 - New file properties


SetFileProperty /opt/containerd mode 711
