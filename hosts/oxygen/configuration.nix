{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../users/user.nix
    ../../profiles/core.nix
    ../../profiles/workstation.nix
    ../../modules/mullvad.nix
    ../../modules/nvidia.nix
    ../../modules/gnome.nix
  ];

  boot.kernelModules = [ "kvm-amd" ];

  networking.interfaces.enp4s0.useDHCP = false;
  networking.interfaces.enp4s0.mtu = 9000;
  networking.interfaces.enp6s0.useDHCP = false;
  networking.interfaces.wlp5s0.useDHCP = false;

  # Set up bridged networking for virt-manager
  networking.bridges = { "br0" = { interfaces = [ "enp4s0" ]; }; };
  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.0.0.10";
      prefixLength = 24;
    }];
    mtu = 9000;
  };
  virtualisation.libvirtd.allowedBridges = [ "virbr0" "br0" ];

  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.1" ];
  networking.hostName = "oxygen";
  networking.firewall.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ 139 445 ]; # samba
    allowedUDPPorts = [ 137 138 ]; # samba
  };

  # Set up samba share
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = oxygen
      netbios name = oxygen
      security = user
      hosts allow = 10.0.0.
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      smb encrypt = required
    '';
    shares = {
      private = {
        path = "/mnt/share";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "user";
        "force group" = "users";
      };
    };
  };

  # Scanning
  hardware.sane.enable = true;

  # Steam
  programs.steam.enable = true;

  system.stateVersion = "21.05"; # Did you read the comment?

}
