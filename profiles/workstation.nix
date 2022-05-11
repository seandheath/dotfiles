{ inputs, config, pkgs, ... }: {

  imports = [
    ../modules/mullvad.nix
    ../modules/dod_certs.nix
    ../modules/clamav.nix
    ../modules/syncthing.nix
  ];

  # Fix bluetooth for controller
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

  # Enable CUPS and add driver for printer
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Set up virtualization
  environment.systemPackages = with pkgs; [
    gimp
    brasero
    signal-desktop
    gnomeExtensions.gtile
    alacritty
    xournalpp
    krita
    thunderbird-bin
    inkscape
    texlive.combined.scheme-full
    pandoc
    ark
    thunderbird-bin
    tmux
    libreoffice
    gcc
    unstable.go
    unstable.joplin-desktop
    bibletime
    nextcloud-client
    git
    mullvad-vpn
    teams
    unstable.vscode
    firefox
    koreader
    kdiff3
    kmail
    meld
    rustup
    pkg-config
    protonmail-bridge
    solvespace
    cataclysm-dda-git
    pioneer
    freeciv
    zeroad
    shattered-pixel-dungeon
    glxinfo
    unstable.crawl
    bitwarden
    devel.vmware-horizon-client
    unstable.glibc
    virt-manager
    unstable.protonup
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

  # Enable controllers
  #services.joycond.enable = true;

  services.gnome.gnome-keyring.enable = true;

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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
