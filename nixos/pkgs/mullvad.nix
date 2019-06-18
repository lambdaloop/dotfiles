# with import <nixpkgs> {};

{ stdenv, makeWrapper, fetchurl, dpkg
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype
, gdk_pixbuf, glib, gnome2, nspr, nss, gtk3, gtk2, at-spi2-atk
, gsettings-desktop-schemas, gobject-introspection, wrapGAppsHook
, xorg, nghttp2
, libudev0-shim, glibc, curl, openssl, autoPatchelfHook
, udev, pulseaudio, libpulseaudio, systemd, libnotify
}:

let deps = [
    alsaLib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gnome2.GConf
    gnome2.pango
    gtk2
    gtk3
    gsettings-desktop-schemas
    pulseaudio
    libpulseaudio
    libnotify
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    nspr
    nss
    udev
    stdenv.cc.cc
    systemd
  ];

in

stdenv.mkDerivation rec {
  name = "mullvad-${version}";
  version = "2019.4";

  src = fetchurl {
    url = "https://www.mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
    sha256 = "5b568cc40322aee871f3919ab62222f2a3e15f52223dacd18cd29a9835d1b495";
  };

  nativeBuildInputs = [ 
    autoPatchelfHook
    dpkg
    makeWrapper
    gobject-introspection 
  ];
  
  buildInputs = deps;

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontStrip = true;
  
  unpackPhase = "dpkg-deb -x $src pkg";

  installPhase = ''
    runHook preInstall

    libdir=$out/lib/mullvad
    mkdir -p $out/share/mullvad $out/lib $out/bin
    mkdir -p $libdir

    mv ./pkg/usr/share/* $out/share
    mv ./pkg/usr/bin/* $out/bin
    mv pkg/opt/Mullvad\ VPN/* $out/share/mullvad
    cp $out/share/mullvad/*.so $libdir

    rpath="$out/share/mullvad:$libdir"

    patchelf \
       --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
       --set-rpath $rpath $out/share/mullvad/mullvad-vpn

    librarypath="${stdenv.lib.makeLibraryPath deps}:$libdir"

    wrapProgram $out/share/mullvad/mullvad-vpn \
        --prefix LD_LIBRARY_PATH : "$librarypath" \
        --prefix PATH

    sed -i 's|\/opt\/Mullvad.*VPN|'$out'/bin|g' $out/share/applications/mullvad-vpn.desktop
    sed -i 's|\/opt\/Mullvad.*VPN/resources|'$out'/bin|g' $out/share/mullvad/resources/mullvad-daemon.conf
    sed -i 's|\/opt\/Mullvad.*VPN/resources|'$out'/bin|g' $out/share/mullvad/resources/mullvad-daemon.service

    ln -s $out/share/mullvad/mullvad-vpn $out/bin/mullvad-vpn
    ln -s $out/share/mullvad/resources/mullvad-daemon $out/bin/mullvad-daemon
    
    install -D -m644 $out/share/mullvad/resources/mullvad-daemon.service $out/lib/systemd/system/mullvad.service

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://mullvad.net;
    description = "Client for Mullvad VPN";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };

}

