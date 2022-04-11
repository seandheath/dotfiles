{ config, pkgs, ... }: {
  # Enable the KDE Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.gvfs.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    ksuperkey
  ];
}

