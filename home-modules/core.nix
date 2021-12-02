{ config, pkgs, ... }: {

  imports = [
    ./git.nix
    ./neovim.nix
    ./bash.nix
    ./direnv.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "user";
  home.homeDirectory = "/home/user";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    dhcp
    nixfmt
    git
    fzf
    file
    htop
    xclip
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
