# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/p50>
      ./hardware-configuration.nix
    ];


 nix = {
   package = pkgs.nixFlakes;
   extraOptions = ''
    experimental-features = nix-command flakes
   '';
 };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ThinkPad-P50"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Riyadh";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
#  services.xserver.windowManager.hyprland.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ara";
    variant = "";
    options = "grp:win_space_toggle";
};

  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #sound.enable = true;

  # services.rtkit.enable = true;
  security.rtkit.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # OR
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
     jack.enable = true;
   };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
   services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.DrRoot = {
     isNormalUser = true;
     description = "Mahmoud Hassan Bashier";
     extraGroups = [ "wheel" "networkmanager" "video" "audio" "storage" "media" "input"]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
  #     firefox
  #     tree
     ];
   };

   security.doas.enable = true;
   security.sudo.enable = false;
   security.doas.extraRules = [{
	users = ["DrRoot"];
	keepEnv = true; 
	persist = true;
	#wheelNeedsPassword = true;
	#nopass = true;
	}];

  # Allow unfree packages
  nixpkgs.config = {
	allowUnfree = true;
	allowBroken = true;
	allowUnsupportedSystem = true;
	#allowUnfreePredicate = pkg:builtins.elem (lib.getName pkg) [ "#nvidia-x11" ];
	permittedInsecurePackages = [
		"openssl-1.1.1w"
];
};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     firefox-esr
     zoom-us
     zed-editor
     sublime4
     openssl_1_1
     stremio
     auto-cpufreq
     libevdev
     mpv
     yt-dlp
     #fzf
     qutebrowser
     zathura
     btop
     htop
     nuspell
     hyphen
     hunspell
     hunspellDicts.en_US

### Hypr
     waybar
     kitty
     swww
     wofi 
     pyprland

     hyprpicker
     hyprcursor
     hyprlock
     hypridle
     hyprpaper
     imv
     #wezterm

     wlr-randr
     gpu-viewer
     dig
     speedtest-rs
   ];


  fonts = {                                                  #This is depricated new sytax will
    fonts = with pkgs; [                                   #be enforced in the next realease
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      nerdfonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
	      monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
	      serif = [ "Noto Serif" "Source Han Serif" ];
	      sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
    };


  programs.hyprland = {
	enable =true;
	xwayland.enable = true;
};

  environment.sessionVariables = {
	WLR_NO_HARDWARE_CURSORS = "1";
	NIXOS_OZONE_WL = "1";
};

  xdg.portal = {
	enable = true;
	extraPortals = [
		pkgs.xdg-desktop-portal-gtk
	];
};

  #wayland.windowManager.hyprland.systemd.variables = ["--all"];

  hardware.opengl = {
	enable = true;
	#driSupport = true;
	#driSupport32Bit = true;

	};


  services.xserver.videoDrivers = ["nvidia" "modesetting" ];
  boot.initrd.availableKernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  system.nixos.tags = [ "with-nvidia" ];
  system.nixos.label = "nVidia";

 
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    # xrandr --listproviders
    # lspci| grep -E 'VGA|3D'

#    optimus_prime = {
#      enable = true;
#      nvidiaBusId = "PCI:1:0:0";
#      intelBusId = "PCI:0:02:0";
#      };

  };
 
  
  services.geoclue2.enable = true;
  services.dbus.enable = true;
  services.fwupd.enable = true;
  services.auto-cpufreq.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  system.autoUpgrade = {
   enable = true;
#   channel = "https://nixos.org/channels/nixos-unstable";
  };



######################################################################################
 # Enable Encrypted DNS
  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.enable = true;
    networkmanager.dns = "none";
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    #configFile = "/etc/dnscrypt-proxy/dnscrypt-proxy.toml";
    settings = {
	ipv4_servers = true;
	ipv6_servers = true;
	require_dnssec = true;
	dnscrypt_servers = true;
	doh_servers = true;
	odoh_servers = true;
	require_nolog = true;
	require_nofilter = true;
	lb_strategy = "random";
	lb_estimator = true;
	dnscrypt_ephemeral_keys = true;
	ignore_system_dns = true;
	netprobe_address = "45.11.45.11:53";
	block_ipv6 = false;
	block_unqualified = true;
	block_undelegated = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
      sources.relays = {
    	urls = [
	  "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md" "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
	];
	cache_file = "/var/cache/dnscrypt-proxy/relays.md";
	minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
};
     sources.odoh-servers = {
	urls = [
	  "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md" "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
	];
	cache_file = "/var/lib/dnscrypt-proxy2/odoh-servers.md";
	minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
	};
      sources.odoh-relays = {
	urls = [
	   "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md" "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md" ];
	cache_file = "/var/lib/dnscrypt-proxy2/odoh-relays.md";
	minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
	};

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
     # server_names = [ "cloudflare" "cloudflare-ipv6" "cloudflare-security" "cloudflare-security-ipv6" "adguard-dns-doh" "mullvad-adblock-doh" "mullvad-doh" "nextdns" "nextdns-ipv6" "quad9-dnscrypt-ipv4-filter-pri" "google" "google-ipv6" "ibksturm" ];
	server_names = [ "anon-cs-fr" "anon-bcn" "ams-dnscrypt-nl" "anon-meganerd" "anon-scaleway-ams" "d0wn-tz-ns1" "anon-arapurayil-in-ipv4" "anon-cs-rome" "dct-at1" "anon-cs-austria" "anon-techsaviours.org" "dct-nl1" "anon-meganerd" "anon-scaleway-ams" "dct-ru1" "anon-cs-czech" "anon-techsaviours.org" "dnscrypt.be" "anon-cs-belgium" "anon-serbica" "dnscrypt.ca-1" "anon-cs-il" "anon-openinternet" "dnscrypt.ca-2" "anon-cs-il2" "anon-openinternet" "dnscrypt.pl" "anon-cs-poland" "anon-techsaviours.org" "dnscrypt.uk-ipv4" "anon-cs-london" "anon-scaleway" "dnswarden-uncensor-dc-swiss" "anon-cs-fr" "anon-kama" "meganerd" "anon-scaleway-ams" "anon-serbica" "openinternet" "anon-cs-sea" "anon-inconnu" "plan9dns-fl" "anon-cs-tx" "anon-inconnu" "plan9dns-mx" "anon-cs-tx" "anon-inconnu" "plan9dns-nj" "anon-cs-nyc1" "anon-inconnu" "pryv8boi" "anon-cs-dus1" "anon-techsaviours.org" "sby-limotelu" "anon-cs-sydney" "anon-saldns01-conoha-ipv4" "scaleway-ams" "anon-meganerd" "anon-serbica" "scaleway-fr" "anon-cs-fr" "anon-dnscrypt.uk-ipv4" "serbica" "anon-cs-nl" "anon-scaleway-ams" "techsaviours.org-dnscrypt" "anon-cs-berlin" "anon-dnswarden-swiss" "v.dnscrypt.uk-ipv4" "anon-cs-london" "anon-scaleway" "odohrelay-koki-ams" "odohrelay-crypto-sx" "odohrelay-surf" "odohrelay-koki-bcn" "odohrelay-ams" "odohrelay-ibksturm" "odohrelay-se" ];

  anonymized_dns = {
	skip_incompatible = true;
	direct_cert_fallback = false;
	routes = [
		{ server_name = "*"; via = [ "anon-cs-fr" "anon-bcn" "ams-dnscrypt-nl" "anon-meganerd" "anon-scaleway-ams" "d0wn-tz-ns1" "anon-arapurayil-in-ipv4" "anon-cs-rome" "dct-at1" "anon-cs-austria" "anon-techsaviours.org" "dct-nl1" "anon-meganerd" "anon-scaleway-ams" "dct-ru1" "anon-cs-czech" "anon-techsaviours.org" "dnscrypt.be" "anon-cs-belgium" "anon-serbica" "dnscrypt.ca-1" "anon-cs-il" "anon-openinternet" "dnscrypt.ca-2" "anon-cs-il2" "anon-openinternet" "dnscrypt.pl" "anon-cs-poland" "anon-techsaviours.org" "dnscrypt.uk-ipv4" "anon-cs-london" "anon-scaleway" "dnswarden-uncensor-dc-swiss" "anon-cs-fr" "anon-kama" "meganerd" "anon-scaleway-ams" "anon-serbica" "openinternet" "anon-cs-sea" "anon-inconnu" "plan9dns-fl""anon-cs-tx" "anon-inconnu" "plan9dns-mx" "anon-cs-tx" "anon-inconnu" "plan9dns-nj" "anon-cs-nyc1" "anon-inconnu" "pryv8boi" "anon-cs-dus1" "anon-techsaviours.org" "sby-limotelu" "anon-cs-sydney" "anon-saldns01-conoha-ipv4" "scaleway-ams" "anon-meganerd" "anon-serbica" "scaleway-fr" "anon-cs-fr" "anon-dnscrypt.uk-ipv4" "serbica" "anon-cs-nl" "anon-scaleway-ams" "techsaviours.org-dnscrypt" "anon-cs-berlin" "anon-dnswarden-swiss" "v.dnscrypt.uk-ipv4" "anon-cs-london"
 "anon-scaleway" "odohrelay-koki-ams" "odohrelay-crypto-sx" "odohrelay-surf" "odohrelay-koki-bcn" "odohrelay-ams" "odohrelay-ibksturm" "odohrelay-se"
    ]; }
];
};
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";



};

}
