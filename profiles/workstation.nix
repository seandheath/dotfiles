{ inputs, config, pkgs, ... }: {

  imports =
    [ ../modules/mullvad.nix ../modules/dod_certs.nix ../modules/clamav.nix ];

  # Fix bluetooth for controller
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

  # Enable CUPS and add driver for printer
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Set up virtualization
  environment.systemPackages = with pkgs; [
    nmap
    unstable.vlc
    nextcloud-client
    unstable.tor-browser-bundle-bin
    jellyfin-media-player
    emacs
    lldb_9 # for emacs debugging
    delve
    nodejs
    gotools
    mitmproxy
    openjdk
    wireshark
    qtox
    vagrant
    discord
    graphviz
    gocode
    inetutils
    unstable.gopls
    python310
    ripgrep
    unstable.google-chrome
    gimp
    brasero
    unstable.signal-desktop
    filezilla
    flameshot
    xournalpp
    pandoc
    tmux
    libreoffice
    gcc
    unstable.go
    unstable.joplin-desktop
    bibletime
    git
    mullvad-vpn
    teams
    unstable.vscode
    firefox
    rustup
    pkg-config
    glxinfo
    unstable.bitwarden
    devel.vmware-horizon-client
    unstable.glibc
    virt-manager
    unstable.protonup
    b612
    inconsolata
  ];

  # Enable dconf
  programs.dconf.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    virtualbox.host.enable = true;
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
    emacs-all-the-icons-fonts
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

  # Disable lid switch for laptops
  services.logind.lidSwitch = "ignore";

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
