{ config, ... }:{
  systemd.services.ddclient.serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
  services.ddclient = {
    enable = true;
    domains = [ builtins.readFile config.sops.secrets.ddclient.domains.path ];
    username = builtins.readFile config.sops.secrets.ddclient.username.path;
    password = builtins.readFile config.sops.secrets.ddclient.password.path;
    protocol = "googledomains";
    ssl = true;
  };
}

