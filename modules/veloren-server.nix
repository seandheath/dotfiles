
{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    14004
  ];
  users.groups.veloren = {};
  users.users.veloren = {
    isNormalUser = true;
    group = config.users.groups.veloren.name;
    home = "/home/veloren";
  };
  virtualisation.oci-containers.containers.veloren-server = {
    user = "veloren:veloren";
    image = "registry.gitlab.com/veloren/veloren/server-cli:nightly";
    autoStart = true;
    ports = [
      "14004:14004"
    ];
    volumes = [
      "/home/veloren:/opt/veloren"
    ];
    environment = {
      RUST_LOG = "debug,common::net=info";
    };
  };
}