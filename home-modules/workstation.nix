{ config, pkgs, ... }: {

  imports = [
    ./core.nix
    ./go.nix
    ./gnome.nix
  ];


  home.sessionPath = [ "/home/user/go/bin" ];

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

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
        command = "/run/current-system/sw/bin/gnome-terminal";
        name = "open-terminal";
      };
    "org/gnome/desktop/background" = {
      picture-uri = "none";
      primary-color = "0x000000";
      color-shading-type = "solid";
    };
  };
}
