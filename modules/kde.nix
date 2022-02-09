{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  # Enable the KDE Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;

  # Environment variables to set editor
  # and theme
  environment = {
    sessionVariables.GTK_THEME = "Adwaita:dark";
    etc = {
      "xdg/gtk-2.0/gtkrc".text = ''
        gtk-theme-name = "Adwaita-dark"
        gtk-icon-theme-name = "Adwaita"
      '';
      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = Adwaita-dark
        gtk-application-prefer-dark-theme = true
        gtk-icon-theme-name = Adwaita
      '';

      # Qt4
      "xdg/Trolltech.conf".text = ''
        [Qt]
        style=GTK+
      '';
    };
  };

  qt5 = {
    enable = true;
    platformTheme = "gtk";
    style = "adwaita-dark";
  };
}

