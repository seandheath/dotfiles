
{ config, pkgs, ... }:
{
  virtualisation.oci-containers.containers.veloren-game-server-master = {
    image = "registry.gitlab.com/veloren/veloren/server-cli:latest";
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
  };
  virtualisation.oci-containers.containers.watchtower = {
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