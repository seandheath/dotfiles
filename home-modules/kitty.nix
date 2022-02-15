{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font.package = pkgs.b612;
    font.name = "Inconsolata";
    font.size = 14;
  };
}
