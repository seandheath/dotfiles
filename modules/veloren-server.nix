
{ config, pkgs, ... }:
{
  users.groups.veloren = {};
  users.users.veloren = {
    isNormalUser = true;
    group = config.users.groups.veloren.name;
    home = "/home/veloren";
  };
  virtualisation.oci-containers.containers.veloren-game-server-master = {
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
  virtualisation.oci-containers.containers.watchtower = {
    user = "veloren:veloren";
    image = "containrrr/watchtower:latest";
    autoStart = true;
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
    cmd = [
      "--interval 30 --stop-timeout 130s --cleanup veloren-game-server-master"
    ];
  };
  networking.firewall.allowedTCPPorts = [
    14004
  ];
}