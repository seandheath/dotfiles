
{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    14004
  ];
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    veloren = {
      image = "registry.gitlab.com/veloren/veloren/server-cli:v0.12.0";
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
    watchtower = {
      image = "containrrr/watchtower";
      volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
      cmd = [ "--interval 30 --stop-timeout 130s --cleanup"];
    };
  };
}