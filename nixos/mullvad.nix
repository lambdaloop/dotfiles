{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mullvad;

  mullvad = pkgs.callPackage ./pkgs/mullvad.nix {};

  mullvadService = cfg:
  {
    description = "Mullvad VPN daemon";
    after = [ "network.target" "network-online.target" "NetworkManager.service" "systemd-resolved.service"];
    path = with pkgs; [ iproute utillinux coreutils ];

    unitConfig = {
       StartLimitBurst = 5;
       StartLimitIntervalSec = 20;
    };

    serviceConfig = {
       Restart = "always";
       RestartSec = 1;
       ExecStart = "${mullvad}/bin/mullvad-daemon -v --disable-stdout-timestamps";
    };
    wantedBy = [ "multi-user.target" ];
  };

  mullvadConfig = {
    enable = mkEnableOption "Mullvad VPN server";
  };

in

{

  ###### interface

  options = {
    services.mullvad = mullvadConfig;
  };


  ###### implementation

  config = mkIf (cfg.enable) {
    systemd.services.mullvad = mullvadService cfg;
  };

}
