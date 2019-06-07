# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "europa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     dmenu
     emacs
     firefox
     gitAndTools.gitFull
     glxinfo
     gparted
     killall
     mg
     mpv
     python3Full
     python3Packages.pip
     rofi
     stow
     trayer
     wget
     (xmonad-with-packages.override { packages = p: with p; [ xmonad-extras xmonad-contrib xmonad]; })
     xmobar
     xorg.xmodmap
     xkbset
     zotero
     zsh
     konsole
     inkscape
     networkmanagerapplet
     imlib2
     openssl

     numix-gtk-theme
     numix-icon-theme
     numix-icon-theme-square
     numix-cursor-theme
   ];


  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };

    pidgin = {
      openssl = true;
      gnutls = true;
    };

    packageOverrides = pkgs: {
        # Define my own Emacs
        emacs = pkgs.lib.overrideDerivation (pkgs.emacs.override {
            # Make sure imagemgick is a dependency because I regularly
            # look at pictures from Emasc
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
        xf86inputevdev = pkgs.xorg.xf86inputevdev.overrideAttrs (attrs: attrs // {
                            patches = [ ./pkgs/evdev-ahm.patch ];
        });
        };

    };

  };

  # Add fonts
  fonts = {
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
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.systemWide = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "dvorak";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = false;
  services.xserver.libinput.tapping = false;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  services.gnome3.gnome-keyring.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pierre = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
   };

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
  # services.upower.enable = true;
  # systemd.services.upower.enable = true;

  fileSystems."/boot" =
   { device = "/dev/sda1";
     fsType = "vfat";
     #    options = [ "rw" "data=ordered" "relatime" ];
   };

}
