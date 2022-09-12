{ config, pkgs, ... }: {
  #services.xserver.enable = true;
  #services.xserver.desktopManager.kodi.enable = true;
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "kodi";
  users.extraUsers.kodi.isNormalUser = true;
  services.cage.user = "kodi";
  services.cage.program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
  services.cage.enable = true;
  #users.extraUsers.kodi.extraGroups = [ "usenet" ];
  
} 
