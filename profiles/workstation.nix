{ config, pkgs, ... }: {

  imports = [
    ../modules/gnome.nix
    ../modules/mullvad.nix
  ];

  # Enable CUPS and add driver for printer
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Set up virtualization
  environment.systemPackages = with pkgs; [ virt-manager ];
  programs.dconf.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # Set up sound with PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
