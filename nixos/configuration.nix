# coding: utf-8
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
 chili-sddm-theme = pkgs.libsForQt5.callPackage ./pkgs/sddm_chili.nix {};
 mullvad = pkgs.callPackage ./pkgs/mullvad.nix {};

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./mullvad.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_5_1;
  # boot.kernelParams = ["acpi_osi=" "acpi_backlight=vendor"];
  # boot.kernelParams = ["video.use_native_backlight=1"];
  boot.kernel.sysctl = {
    "vm.swappiness" = pkgs.lib.mkDefault 1;
  };

  networking.hostName = "europa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  boot.kernelModules = [ "fuse" "coretemp"];

  hardware.bluetooth = {
     enable = true;
   };
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  # time.timeZone = "America/Chicago";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # command line tools
    bash
    file
    ffmpeg-full
    gitAndTools.gitFull
    htop
    killall
    mg
    scrot
    stow
    wget
    zip unzip
    zsh

    # core GUIs
    emacs
    evince
    firefox-bin
    gparted
    inkscape
    konsole
    mpv
    viewnior
    zotero

    # programming
    python3Full
    python3Packages.pip

    # ui
    dmenu
    networkmanagerapplet
    rofi
    trayer
    maim

    # dictionaries
    aspell
    aspellDicts.en aspellDicts.fr
    manpages

    # X utilities
    xkbset
    xmobar
    xorg.xmodmap
    xorg.xbacklight
    xcompmgr

    # other programs
    cantata
    gsimplecal
    htop
    imagemagick
    mpc_cli
    gnome3.nautilus
    nox
    ntfs3g
    openssl
    pandoc
    pass
    pavucontrol
    playerctl
    spotify

    # graphics
    intel-ocl
    libva-full
    libvdpau-va-gl
    vaapiIntel
    vaapiVdpau
    xorg.xf86videointel

    # style
    lxappearance
    numix-cursor-theme
    numix-gtk-theme
    numix-icon-theme
    numix-icon-theme-square
    arc-icon-theme
    pantheon.elementary-gtk-theme
    pantheon.elementary-icon-theme
    hicolor-icon-theme
    xfce4-13.xfce4-icon-theme
    vanilla-dmz

    gdk_pixbuf
    gnome3.librsvg
  ] ++
  [
   chili-sddm-theme
   mullvad
  ];


  documentation.dev.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = false;
    };

    # pidgin = {
    #   openssl = true;
    #   gnutls = true;
    # };

    packageOverrides = pkgs: {
      # Define my own Emacs
      emacs = pkgs.lib.overrideDerivation (
      pkgs.emacs.override {
            # Make sure imagemgick is a dependency because I regularly
            # look at pictures from Emacs
            imagemagick = pkgs.imagemagickBig;
            }) (attrs: {
            # I don't want emacs.desktop file because I only use
            # emacsclient.
            postInstall = attrs.postInstall + ''
            rm $out/share/applications/emacs.desktop
            '';
       });

      xorg = pkgs.xorg // {
        # patch evdev for space as control hack
        xf86inputevdev = pkgs.xorg.xf86inputevdev.overrideAttrs
              (attrs: attrs // {
                   patches = [ ./pkgs/evdev-ahm.patch ];
               });
      };

      mpv = pkgs.mpv.override {
         x11Support = true;
         vaapiSupport = true;
         vdpauSupport = true;
         pulseSupport = true;
      };

    };

  };

  # Add fonts
  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      inconsolata # monospaced
      ubuntu_font_family
      dejavu_fonts
      google-fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      font-awesome-ttf
      roboto
      paratype-pt-serif
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; };
  programs.bash.enableCompletion = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    webInterface = true;
    drivers = with pkgs; [ gutenprint gutenprintBin hplipWithPlugin brlaser ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Automatic device mounting daemon
  services.devmon.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.systemWide = false;
  hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.zeroconf.discovery.enable = true;
     
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-ocl
    ];
    driSupport32Bit = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "dvorak";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver.videoDrivers = [ "intel" ];

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.tapping = false;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.theme = "chili";

  # services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  services.xserver.config =
    ''
  Section "InputClass"
  Identifier "Keyboard" # You can name this arbitrarily
  Driver "evdev"
  # Option "XKBOptions" "terminate:ctrl_alt_bksp" # and so on

  # If you save this file under xorg.conf.d/ :
  Option "AutoServerLayout" "on"

  MatchIsKeyboard "on"
  # If you have multiple keyboards, you want something like one of them:
  #  MatchProduct "AT Translated Set 2 keyboard"
  #  MatchUSBID "0566:3029"
  # Name is found in Xorg log, following the message "Adding input device"
  # or by
  # $ cat /proc/bus/input/devices

  ### at-home-modifier options begin here.
  # The basic option.
  Option "TransMod" "65:37" # Defines key/modifier pairs.

  ## Fine tuning options. Explained in a later section.
  # For the first time, omit them.

  Option "AhmTimeout" "400" # In millisecond.
  # Option "AhmDelay" "65" # Delayed keys. Seperate by spaces.
  # Option "AhmFreezeTT" "true"
  # Option "AhmResetTime" "10" # In sec.
  # Option "AhmPaddingInterval" "10" # In millisecond.
  EndSection
  '';


  services.redshift = {
    enable = true;

    # Seattle
    latitude = "47.6705";
    longitude = "-122.314";

    temperature = {
      day = 6500;
      night = 3100;
    };
    extraOptions = ["-m vidmode"];
  };

  services.mpd = {
    enable = true;
    musicDirectory= /home/pierre/Music;
  };

  services.gnome3.gnome-keyring.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
          "*/10 * * * *      pierre    . /etc/profile; ${pkgs.bash}/bin/bash /home/pierre/scripts/screens.sh"
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pierre = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "power" "games" "storage" "audio" "pulse" "dialout"];
  };


  security.sudo.extraConfig = ''
  %power      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/poweroff
  %power      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/reboot
  %power      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl suspendg
  %power      ALL=(ALL:ALL) NOPASSWD: /home/pierre/scripts/fix_brightness_permissions.sh
  %storage      ALL=(ALL:ALL) NOPASSWD: ${pkgs.utillinux}/bin/mount
  %storage      ALL=(ALL:ALL) NOPASSWD: ${pkgs.utillinux}/bin/umount
  %storage      ALL=(ALL:ALL) NOPASSWD: ${pkgs.exfat}/bin/mount.exfat
'';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?


  fileSystems."/jellyfish" =
    { device = "/dev/disk/by-label/jellyfish";
      fsType = "ext2";
    };
  
  #  services.emacs.enable = true;

  hardware.facetimehd.enable = true;

  # Enable UPower, which is used by taffybar.
  services.upower.enable = true;
  systemd.services.upower.enable = true;

  # systemd.services.mullvad = {
  #   description = "Mullvad VPN daemon";
  #   after = [ "network.target" "network-online.target" "NetworkManager.service" "systemd-resolved.service"];
  #   path = with pkgs; [ iproute utillinux coreutils ];

  #   unitConfig = {
  #      StartLimitBurst = 5;
  #      StartLimitIntervalSec = 20;
  #   };

  #   serviceConfig = {
  #      Restart = "always";
  #      RestartSec = 1;
  #      ExecStart = "${mullvad}/bin/mullvad-daemon -v --disable-stdout-timestamps";
  #   };
  #   wantedBy = [ "multi-user.target" ];
  # };

  services.mullvad.enable = true;

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "vfat";
      #    options = [ "rw" "data=ordered" "relatime" ];
    };

}
