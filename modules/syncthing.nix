{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    user = "user";
    group = "user";
    dataDir = "/home/user/sync";
    configDir = "/home/user/.config/syncthing";
  };
}
