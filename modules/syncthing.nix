{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    user = "user";
    group = "user";
  };
}
