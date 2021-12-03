{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  hardware.cpu.amd.updateMicrocode = true;

  # Keep GPU alive even though we're headless
  hardware.nvidia.nvidiaPersistenced = true;

  networking.hostName = "hydrogen"; # Define your hostname.
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  networking.enableIPv6 = false;
  networking.interfaces.enp5s0.useDHCP = false;
  networking.interfaces.enp5s0.mtu = 9000;
  networking.interfaces.enp5s0.ipv4.addresses = [{
    address = "10.0.0.2";
    prefixLength = 24;
  }];
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.1" ];

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 6789 7878 8096 8989 ];
}
