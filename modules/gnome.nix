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
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverridePackages = with pkgs; [ gnome3.gnome-settings-daemon ];
    extraGSettingsOverrides = ''
      [org.gnome.desktop.background]
      color-shading-type='solid'
      picture-uri='none'
      primary-color='0x000000'

      [org.gnome.desktop.interface]
      color-scheme='prefer-dark'
      enable-hot-corners=false
      gtk-theme='Adwaita-dark'
      show-battery-percentage=true
      
      [org.gnome.desktop.peripherals.touchpad]
      tap-to-click=true
      two-finger-scrolling-enabled=true

      [org.gnome.desktop.sound]
      allow-volume-above-100-percent=true

      [org.gnome.desktop.wm.keybindings]
      move-to-workspace-left=['<Primary><Shift><Alt>Left']
      move-to-workspace-right=['<Primary><Shift><Alt>Right']
      switch-applications=@as []
      switch-applications-backwards=@as []
      switch-windows=['<Alt>Tab']
      switch-windows-backward=['<Shift><Alt>Tab']

      [org.gnome.mutter]
      attach-modal-dialogs=false
      dynamic-workspaces=tue
      edge-tiling=true
      focus-change-on-pointer-rest=true
      workspaces-only-on-primary='true'

      [org.gnome.nautilus.preferences]
      default-folder-viewer='list-view'
      search-filter-time-type='last_modified'
      search-view='list-view'

      [org.gnome.settings-daemon.plugins.power]
      power-button-action='suspend'

      [org.gnome.settings-daemon.plugins.media-keys]
      custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']
      home=['<Super>e']

      [org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0]
      binding='<Alt>Return'
      command='/run/current-system/sw/bin/gnome-terminal'
      name='open-terminal'
    '';
  };


  # Enable applet indicators
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  # Environment variables to set editor
  # and theme
  environment = {
    systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnome.gnome-terminal
      gnomeExtensions.appindicator
      gnomeExtensions.gtile
      gnome.gedit
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
