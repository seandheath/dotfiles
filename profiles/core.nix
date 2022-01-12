{ config, pkgs, devel, ... }: {
  imports = [
    ../modules/sops.nix
  ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 16;
  boot.loader.efi.canTouchEfiVariables = true;

  # List packages installed in system profile. To search, run:
  environment = {
    variables.editor = "nvim";
    systemPackages = with pkgs; [
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      sops
    ];
  };

  # Enable unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      devel.config = config.nixpkgs.config;
    };
  };

  # Set localization stuff
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Set CPU Governor
  powerManagement.cpuFreqGovernor = "performance";

  # Enable automatic upgrade
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "github:seandheath/dotfiles";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
