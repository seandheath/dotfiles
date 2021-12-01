{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    ./modules/myjellyfin.nix
    ./modules/usenet.nix
    ./modules/nvidia.nix
    ./modules/gnome.nix
    ./modules/server.nix
    ./modules/nextcloud.nix
  ];

  hardware.cpu.amd.updateMicrocode = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.hostName = "hydrogen"; # Define your hostname.
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  networking.useDHCP = false;
  networking.enableIPv6 = false;
  networking.interfaces.enp5s0.useDHCP = false;
  networking.interfaces.enp5s0.mtu = 9000;
  networking.interfaces.enp5s0.ipv4.addresses = [{
    address = "10.0.0.2";
    prefixLength = 24;
  }];
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.1" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keyFiles = [ "/home/user/.ssh/server.pub" ];
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 6789 7878 8096 8989 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
