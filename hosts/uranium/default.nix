{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Update microcode
  hardware.cpu.intel.updateMicrocode = true;

  # Graphics
  boot.kernelParams = [ "i915.enable_psr=0" ];

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "uranium"; # Define your hostname.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.interfaces.wlp0s20f3.mtu = 9000;

  # Enable firmware updates
  services.fwupd.enable = true;
}
