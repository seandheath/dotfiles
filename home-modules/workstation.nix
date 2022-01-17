{ config, pkgs, ... }: {

  imports = [
    ./core.nix
    ./go.nix
    ./gnome.nix
  ];

  home.packages = with pkgs; [
    crawl
    unstable.torbrowser
    godot
    krita
    mullvad-vpn
    unstable.protonup
    ungoogled-chromium
    firefox
    unstable.joplin-desktop
    discord
    qucs
    kicad
    filezilla
    bibletime
    nextcloud-client
    inetutils
    nixfmt
    tmux
    tintin
    jellyfin-media-player
    inconsolata
    flameshot
    gnomeExtensions.appindicator
    vscodium
    mullvad-vpn
    protonup
    slack
    glances
    wireshark
    python310
    pcsctools
    opensc
    gcc
    xournalpp
    htop
    tree
    git
    gnomeExtensions.gtile
    gnome.gnome-tweaks
    fzf
    keepassxc
    teams
    rustup
    go
    go-langserver
    zig
    file
    vlc
    libreoffice
    signal-desktop
    opensans-ttf
  ];

  dconf.settings = {
    "org/gnome/mutter" = { workspaces-only-on-primary = "false"; };
    "org/gnome/terminal/legacy" = { theme-variant = "dark"; };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      gtk-theme = "Adwaita-dark";
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-left = [ "<Primary><Shift><Alt>Left" ];
      move-to-workspace-right = [ "<Primary><Shift><Alt>Right" ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
      home = [ "<Super>e" ];
      area-screenshot-clip = [ ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Alt>Return";
        command = "/run/current-system/sw/bin/gnome-terminal";
        name = "open-terminal";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Primary><Shift><Alt>s";
        command = "flameshot gui";
        name = "screenshot";
      };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  services.nextcloud-client.enable = true;

  services.redshift = {
    enable = true;
    settings.redshift.brightness-day = "1";
    settings.redshift.brightness-night = "1";
    temperature = {
      day = 4700;
      night = 3700;
    };
    dawnTime = "06:00-06:01";
    duskTime = "16:00-16:01";
  };
}
