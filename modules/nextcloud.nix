{ config, ... }:
let 
  id = {
    nextcloud = 2001;
    postgres = 71;
  };
  adminpass = config.sops.secrets.nextcloud-adminpass.path;
  dbpass = config.sops.secrets.nextcloud-dbpass.path;
in {
  sops.secrets.nextcloud-adminpass = {
    owner = config.users.users.nccnextcloud.name;
    group = config.users.groups.nccnextcloud.name;
    mode = "0400";
  };
  sops.secrets.nextcloud-dbpass = {
    owner = config.users.users.nccnextcloud.name;
    group = config.users.groups.nccnextcloud.name;
    mode = "0400";
  };
  users.groups.nccnextcloud.gid = id.nextcloud;
  users.groups.nccpostgres.gid = id.postgres;
  users.users.nccnextcloud = {
    isSystemUser = true;
    uid = id.nextcloud;
    group = config.users.groups.nccnextcloud.name;
  };
  users.users.nccpostgres = {
    isSystemUser = true;
    uid = id.postgres;
    group = config.users.groups.nccpostgres.name;
  };
  system.activationScripts.nextcloud.text = ''
    mkdir -p /var/lib/ncc
  '';
  containers.nextcloud = {
    ephemeral = true;
    autoStart = true;
    bindMounts = {
      "/run/secrets" = {
        hostPath = "/run/secrets";
        isReadOnly = true;
      };
      "/var/lib/" = {
        hostPath = "/var/lib/ncc/";
        isReadOnly = false;
      };
    };
    config = { config, pkgs, sops, ... }: {
      users.groups.nextcloud.gid = id.nextcloud;
      users.groups.postgres.gid = id.postgres;
      users.users.nextcloud = {
        isSystemUser = true;
        uid = id.nextcloud;
        group = "nextcloud";
      };
      users.users.postgres = {
        isSystemUser = true;
        uid = id.postgres;
        group = "postgres";
      };
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 80 ];
      services.nextcloud = {
        enable = true;
        autoUpdateApps.enable = true;
        autoUpdateApps.startAt = "02:00:00";
        https = false;
        maxUploadSize = "32G";
        hostName = "nc.nheath.com";
        package = pkgs.nextcloud23;
        config = {
          overwriteProtocol = "https";
          adminuser = "sean";
          adminpassFile = adminpass;
          dbuser = "nextcloud";
          dbpassFile = dbpass;
          dbtype = "pgsql";
          dbname = "nextcloud";
          dbhost = "/run/postgresql";
          extraTrustedDomains = [ "10.0.0.2" ];
        };
      };
      services.postgresql = {
        enable = true;
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [{
          name = "nextcloud";
          ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
        }];
      };
      systemd.services."nextcloud-setup" = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
      };
    };
  };
}
