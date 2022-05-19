{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  users.groups.user = {};
  users.users.user = {
    isNormalUser = true;
    group = config.users.groups.user.name;
    extraGroups = [ "wheel" "scanner" "lp" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLhPOBx9dR2X3oYz5RS2eAGZA7YSeHPcnrQauHSmuk1"
    ];
  };
  home-manager.users.user = { pkgs, ... }: {
    imports = [
      ../home-modules/workstation.nix
    ];
    #programs.git = {
      #enable = true;
      #userName = "Sean Heath";
      #userEmail = "se@nheath.com";
    #};
  };
}

