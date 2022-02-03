{ inputs, config, pkgs, ... }: {

  imports = [
    ../modules/gnome.nix
    ../modules/mullvad.nix
    ../modules/dod_certs.nix
    ../modules/clamav.nix
  ];

  # Enable CUPS and add driver for printer
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Set up virtualization
  environment.systemPackages = with pkgs; [
    devel.vmware-horizon-client
    unstable.glibc
    virt-manager
    unstable.protonup
  ];

  # Enable dconf
  programs.dconf.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # Enable steam
  programs.steam.enable = true;

  # Enable smartcards
  services.pcscd.enable = true;

  # Set up sound with PipeWire
  #hardware.pulseaudio = {
    #enable = true;
    #support32Bit = true;
  #};
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
