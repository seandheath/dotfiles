{ config, pkgs, home, ... }: {
  programs.go = {
    enable = true;
    package = pkgs.go_1_18;
  };
  home.sessionPath = [
    "$HOME/go/bin"
  ];
}
