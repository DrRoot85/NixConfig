{ config, pkgs, lib, ... }:

{
  ###############################################
  ## Bootloader
  ###############################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ###############################################
  ## Latest Kernel
  ###############################################

  boot.kernelPackages = pkgs.linuxPackages_latest;

  ###############################################
  ## Initrd
  ###############################################

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];

  ###############################################
  ## Filesystems
  ###############################################

  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "btrfs"
    "xfs"
  ];

  ###############################################
  ## Plymouth (optional)
  ###############################################

  # boot.plymouth.enable = true;

  ###############################################
  ## Silent Boot (optional)
  ###############################################

  # boot.consoleLogLevel = 3;
  # boot.initrd.verbose = false;
  # boot.kernelParams = [
  #   "quiet"
  #   "splash"
  #   "loglevel=3"
  #   "rd.systemd.show_status=auto"
  #   "udev.log_level=3"
  # ];

  ###############################################
  ## Kernel Parameters
  ###############################################

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];

  ###############################################
  ## Sysctl
  ###############################################

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  ###############################################
  ## Misc
  ###############################################

  boot.tmp.cleanOnBoot = true;
}
