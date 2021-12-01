{ config, ... }:
let 
  id = {
    nextcloud = 2001;
    acme = 2002;
    postgres = 71;
  };
in {
  users.groups.nccnextcloud.gid = id.nextcloud;
  users.groups.nccacme.gid = id.acme;
  users.groups.nccpostgres.gid = id.postgres;
  users.users.nccnextcloud = {
    isSystemUser = true;
    uid = id.nextcloud;
    group = "nccnextcloud";
  };
  users.users.nccacme = {
    isSystemUser = true;
    uid = id.acme;
    group = "nccacme";
  };
  users.users.nccpostgres = {
    isSystemUser = true;
    uid = id.postgres;
    group = "nccpostgres";
  };
  system.activationScripts.nextcloud.text = ''
    mkdir -p /var/lib/nextcloudcontainer
  '';
  containers.nextcloud = {
    ephemeral = true;
    autoStart = true;
    bindMounts = {
      "/var/lib/" = {
        hostPath = "/var/lib/nextcloudcontainer/";
        isReadOnly = false;
      };
    };
    config = { config, pkgs, ... }: {
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
        hostName = "sunrise.nheath.com";
        package = pkgs.nextcloud22;
        config = {
          adminuser = "sean";
          adminpassFile = "/var/lib/config/nextcloud.adminpass";
          dbuser = "nextcloud";
          dbpassFile = "/var/lib/config/nextcloud.dbpass";
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
