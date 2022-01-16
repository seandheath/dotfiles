{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    inconsolata
  ];
  programs.gnome-terminal.profile.default = {
    font = "Inconsolata";
  };
}
