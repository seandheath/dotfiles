{ inputs, config, pkgs, ... }: {

  imports = [
    ../modules/gnome.nix
    ../modules/mullvad.nix
    ../modules/dod_certs.nix
    ../modules/clamav.nix
  ];

  # Fix bluetooth for controller
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;

  # Enable CUPS and add driver for printer
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Set up virtualization
  environment.systemPackages = with pkgs; [
    crawl
    bitwarden
    joycond
    devel.vmware-horizon-client
    unstable.glibc
    virt-manager
    unstable.protonup
    kwalletmanager
    kwallet-pam
    b612
    inconsolata
    xow
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

  # Fonts
  fonts.fonts = with pkgs; [
    b612
    inconsolata
    iosevka
    aileron
  ];
  fonts.fontconfig = {
    enable = true;
    cache32Bit = true;
    defaultFonts = {
      monospace = [ "Inconsolata" "Source Code Pro" ];
      sansSerif = [ "Aileron" "DejaVu Sans" ];
    };
  };

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
