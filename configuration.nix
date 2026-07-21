{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/security.nix
    ./modules/users.nix
    ./modules/fonts.nix
    ./modules/packages.nix
    ./modules/desktop.nix
    ./modules/nvidia.nix
    ./modules/environment.nix
    ./modules/dnscrypt.nix
  ];

  ###############################################
  ## Host
  ###############################################

  networking.hostName = "ThinkPad-P50";

  time.timeZone = "Asia/Riyadh";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us,ara";
    options = "grp:win_space_toggle";
  };

  ###############################################
  ## Nix
  ###############################################

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  ###############################################
  ## State Version
  ###############################################

  system.stateVersion = "26.05";
}
