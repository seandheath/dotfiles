{ config, ... }:
let 
  id = {
    nextcloud = 2001;
    acme = 2002;
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
  users.groups.nccacme.gid = id.acme;
  users.groups.nccpostgres.gid = id.postgres;
  users.users.nccnextcloud = {
    isSystemUser = true;
    uid = id.nextcloud;
    group = config.users.groups.nccnextcloud.name;
  };
  users.users.nccacme = {
    isSystemUser = true;
    uid = id.acme;
    group = config.users.groups.nccacme.name;
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
      users.groups.acme.gid = id.acme;
      users.groups.postgres.gid = id.postgres;
      users.users.nextcloud = {
        isSystemUser = true;
        uid = id.nextcloud;
        group = "nextcloud";
      };
      users.users.acme = {
        isSystemUser = true;
        uid = id.acme;
        group = "acme";
      };
      users.users.postgres = {
        isSystemUser = true;
        uid = id.postgres;
        group = "postgres";
      };
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      services.nextcloud = {
        enable = true;
        autoUpdateApps.enable = true;
        autoUpdateApps.startAt = "02:00:00";
        https = true;
        maxUploadSize = "32G";
        hostName = "nc.nheath.com";
        package = pkgs.nextcloud22;
        config = {
          adminuser = "sean";
          adminpassFile = adminpass;
          dbuser = "nextcloud";
          dbpassFile = dbpass;
          dbtype = "pgsql";
          dbname = "nextcloud";
          dbhost = "/run/postgresql";
          overwriteProtocol = "https";
          extraTrustedDomains = [ "10.0.0.2" ];
        };
      };
      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
        virtualHosts = {
          "sunrise.nheath.com" = {
            forceSSL = true;
            enableACME = true;
          };
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
      security.acme = {
        acceptTerms = true;
        email = "sunrise@nheath.com";
      };
      systemd.services."nextcloud-setup" = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
      };
    };
  };
}
