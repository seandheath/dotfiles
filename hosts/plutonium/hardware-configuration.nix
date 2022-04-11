{ config, lib, pkgs, modulesPath, ... }:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/5f8fac75-ffde-4bb1-b45a-c1de9b6eded6";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CECC-5AFE";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/mapper/home";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."home".device = "/dev/disk/by-uuid/c7dc0ba0-7639-4717-ba57-ac493e8c46ff";

  fileSystems."/data" =
    { device = "/dev/mapper/data";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."data".device = "/dev/disk/by-uuid/b0a419d8-c344-4b38-b73f-f08deffb21e4";

  swapDevices = [{device = "/dev/disk/by-uuid/2765ca63-14cf-4a80-81f6-ee53c05d424b";}];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = true;
}
