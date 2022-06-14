{ config, pkgs, ... }:
let 
  adminpass = config.sops.secrets.nextcloud-adminpass.path;
  dbpass = config.sops.secrets.nextcloud-dbpass.path;
in {
  sops.secrets.nextcloud-adminpass = {
    owner = config.users.users.nextcloud.name;
    group = config.users.groups.nextcloud.name;
    mode = "0400";
  };
  sops.secrets.nextcloud-dbpass = {
    owner = config.users.users.nextcloud.name;
    group = config.users.groups.nextcloud.name;
    mode = "0400";
  };
  services.nextcloud = {
    enable = true;
    autoUpdateApps.enable = true;
    autoUpdateApps.startAt = "02:00:00";
    https = true;
    maxUploadSize = "32G";
    hostName = "nc.nheath.com";
    package = pkgs.nextcloud24;
    config = {
      overwriteProtocol = "https";
      adminuser = "sean";
      adminpassFile = adminpass;
      dbpassFile = dbpass;
      dbtype = "pgsql";
      extraTrustedDomains = [ "10.0.0.2" ];
    };
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "nextcloud"
    ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions = {
          "DATABASE nextcloud" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };
}
