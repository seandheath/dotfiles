{ modules, config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../profiles/core.nix
    ../../profiles/workstation.nix
    ../../modules/kde.nix
    ../../modules/intel.nix
  ];

  # Update microcode
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  # Kernel config
  boot.kernelParams = [ "i915.enable_psr=0" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.blacklistedKernelModules = [ "psmouse" ];

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
  services.fstrim.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
