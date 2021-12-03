{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];



  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "plutonium"; # Define your hostname.

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  programs.steam.enable = true;
}
