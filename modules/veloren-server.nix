
{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    14004
  ];
  users.groups.veloren = {};
  users.users.veloren = {
    isSystemUser = true;
    group = config.users.groups.veloren.name;
    home = "/home/veloren";
  };
  virtualisation.oci-containers.containers.veloren-server = {
    image = "registry.gitlab.com/veloren/veloren/server-cli:nightly";
    autoStart = true;
    ports = [
      "14004:14004"
    ];
    volumes = [
      "/home/user/veloren:/opt/veloren"
    ];
    environment = {
      RUST_LOG = "debug,common::net=info";
    };
    extraOptions = [ "--userns=keep-id" ];
  };
  systemd.services.podman-veloren-server.serviceConfig.User = "veloren";
}