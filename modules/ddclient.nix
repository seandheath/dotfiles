{ pkgs, config, ... }: {
  users.groups.ddclient = {};
  users.users.ddclient = {
    isSystemUser = true;
    group = "ddclient";
  };

  sops.secrets.ddclient-config.owner = config.users.users.ddclient.name;
  sops.secrets.ddclient-config.group = config.users.groups.ddclient.name;
  sops.secrets.ddclient-config.mode = "0400";

  services.ddclient = {
    enable = true;
    configFile = config.sops.secrets.ddclient-config.path;
  };

  systemd.services.ddclient.serviceConfig.User = pkgs.lib.mkForce config.users.users.ddclient.name;
  systemd.services.ddclient.serviceConfig.Group = pkgs.lib.mkForce config.users.groups.ddclient.name;
}

