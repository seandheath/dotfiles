
{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    14004
  ];
  virtualisation.oci-containers.backend = "docker";
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
  };
}