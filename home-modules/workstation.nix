{ config, pkgs, ... }: {

  imports = [
    ./core.nix
    ./go.nix
    ./gnome.nix
    ./kitty.nix
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    ksuperkey
    nmap
    transmission-gtk
    nix-index
    clamav
    google-chrome
    brasero
    unstable.torbrowser
    godot
    krita
    mullvad-vpn
    unstable.protonup
    firefox
    unstable.joplin-desktop
    discord
    qucs
    filezilla
    bibletime
    nextcloud-client
    inetutils
    nixfmt
    tmux
    tintin
    jellyfin-media-player
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
    "org/gnome/mutter" = { workspaces-only-on-primary = "true"; };
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
        command = "/run/current-system/sw/bin/env -u WAYLAND_DISPLAY /etc/profiles/per-user/user/bin/alacritty";
        name = "open-terminal";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Primary><Shift><Alt>s";
        command = "flameshot gui";
        name = "screenshot";
      };
    "org/gnome/desktop/background" = {
      picture-uri = "none";
      primary-color = "0x000000";
      color-shading-type = "solid";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  services.nextcloud-client.enable = true;
}
