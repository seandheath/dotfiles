{ config, pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kodi";
  users.extraUsers.kodi.isNormalUser = true;
  users.extraUsers.kodi.extraGroups = [ "usenet" ];
} 