{ config, pkgs, ... }:
let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  develTarball = fetchTarball https://github.com/seandheath/nixpkgs/archive/master.tar.gz;
in {
  imports = [
    "${builtins.fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    /home/user/dotfiles/modules/sops.nix
  ];
  hardware.enableRedistributableFirmware = true;

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Automatically collect garbage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 16;
  boot.loader.efi.canTouchEfiVariables = true;

  # List packages installed in system profile. To search, run:
  environment = {
    variables.editor = "nvim";
    systemPackages = with pkgs; [
      neovim 
      sops
      srm
      p7zip
      jmtpfs
    ];
  };

  # Enable unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
      devel = import develTarball { config = config.nixpkgs.config; };
    };
  };

  # Set localization stuff
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable automatic upgrade
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "github:seandheath/dotfiles";
  };
}
