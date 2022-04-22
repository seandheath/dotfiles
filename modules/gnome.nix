{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Removes extra gnome packages
  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome.gnome-music
    gnome.totem
    gnome.tali
    gnome.iagno
    gnome.hitori
    gnome.atomix
    gnome-tour
  ];

  # Enables keyboard shortcuts
  programs.dconf.enable = true;

  # Enable applet indicators
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  # Environment variables to set editor
  # and theme
  environment = {
    systemPackages = with pkgs; [
      gnome.gnome-tweak-tool
    ];
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
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
