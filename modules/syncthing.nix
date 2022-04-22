{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    unstable.syncthingtray
  ];
  services.syncthing = {
    enable = true;
    user = "user";
    group = "user";
    dataDir = "/home/user/sync";
    configDir = "/home/user/.config/syncthing";
  };
}
