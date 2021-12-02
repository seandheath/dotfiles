# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];


  boot.initrd.luks.devices."crypt-swap".device = "/dev/disk/by-uuid/47309e6f-5e4b-46f8-b1f7-1dd1d350dd03";
  boot.initrd.luks.devices."crypt-root".device = "/dev/disk/by-uuid/137e1e21-2f79-4a86-be31-ca2760593788";

  swapDevices =
    [ { device = "/dev/disk/by-uuid/6eaef370-91c9-4e8e-a7cb-c6e7022acbbf"; }
    ];
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/83216da6-c4ce-40c3-9dd2-389282300ec2";
      fsType = "btrfs";
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/544E-B89A";
      fsType = "vfat";
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}