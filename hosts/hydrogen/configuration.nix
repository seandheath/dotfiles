{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../profiles/core.nix
    ../../profiles/server.nix
    ../../modules/kde.nix
    ../../modules/nvidia.nix
    ../../users/user.nix
  ];

  hardware.cpu.amd.updateMicrocode = true;

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

  # Add kodi to hydrogen
  environment.systemPackages = with pkgs; [
    kodi
    vlc
  ];

  # Enable sound
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
