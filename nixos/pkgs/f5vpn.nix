with import <nixpkgs> {};

# { stdenv, makeWrapper, fetchurl, dpkg
# , alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype
# , gdk_pixbuf, glib, gnome2, pango, nspr, nss, gtk3
# , xorg, autoPatchelfHook, systemd, libnotify, qt5, libglvnd
# }:

let deps = [
      qt5.qtbase
      xorg.libX11
      xorg.libXi
      xorg.libSM
      xorg.libICE
      xorg.libxcb
      xorg.libXrender
      xorg.libXext
      libglvnd
      fontconfig
      freetype
      glib
  ];

in

stdenv.mkDerivation rec {
  pname = "fvpn";
  version = "1.0";

  src = /home/pierre/Downloads/husky/linux_f5vpn.x86_64.deb;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = deps;

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = "dpkg-deb -x $src .";

  runtimeDependencies = [systemd.lib libnotify];

  # libs = "$out/share/f5/vpn/lib";
  
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share $out/bin

    mv opt/f5 $out/share

    chmod +x $out/share/f5/vpn/f5vpn
    chmod +x $out/share/f5/vpn/svpn
    chmod +x $out/share/f5/vpn/tunnelserver

    ln -s $out/share/f5/vpn/f5vpn $out/bin/f5vpn
    ln -s $out/share/f5/vpn/svpn $out/bin/svpn
    ln -s $out/share/f5/vpn/tunnelserver $out/bin/tunnelserver

    
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Client for UW F5 VPN";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };

}

