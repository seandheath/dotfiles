{ config, pkgs, ... }:
let 
  id = {
    nextcloud = 2001;
  };
  adminpass = config.sops.secrets.nextcloud-adminpass.path;
in {
  sops.secrets.nextcloud-adminpass = {
    owner = config.users.users.nextcloud.name;
    group = config.users.groups.nextcloud.name;
    mode = "0400";
  };
  users.groups.nextcloud.gid = id.nextcloud;
  users.users.nextcloud = {
    isSystemUser = true;
    uid = id.nextcloud;
    group = users.groups.nextcloud.name;
    home = "/home/nextcloud";
  };
  services.nextcloud = {
    enable = true;
    autoUpdateApps.enable = true;
    autoUpdateApps.startAt = "02:00:00";
    https = true;
    maxUploadSize = "32G";
    hostName = "nc.nheath.com";
    package = pkgs.nextcloud24;
    home = config.users.users.nextcloud.home;
    config = {
      overwriteProtocol = "https";
      adminuser = "sean";
      adminpassFile = adminpass;
      extraTrustedDomains = [ "10.0.0.2" ];
    };
  };
}
