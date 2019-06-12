with import <nixpkgs> {};

let
  manyLinuxFile =
    writeTextDir "_manylinux.py"
      ''
        print("in _manylinux.py")
        manylinux1_compatible = True
      '';

in
buildFHSUserEnv {
  name = "my-python-env";
  targetPkgs = pkgs: with pkgs; [
    (python3.withPackages (ps: with ps; [
      numpy
      scipy
      pandas
      matplotlib
      tkinter
      seaborn
      opencv3
      kitchen
      notebook
      toolz
      virtualenv
      scikitlearn
      h5py
      pip
    ]))
    pipenv
    which
    gcc
    binutils
    zsh
    perl
    
    # All the C libraries that a manylinux_1 wheel might depend on:
    ncurses
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libICE
    xorg.libSM
    glib

  ];

  runScript = "$SHELL";

  profile = ''
    export PYTHONPATH=${manyLinuxFile.out}:/usr/lib/python3.7/site-packages
    # Paths for gcc if compiling some C sources with pip
    # Some other required environment variables
    export FONTCONFIG_FILE=/etc/fonts/fonts.conf
    export QTCOMPOSE=${pkgs.xorg.libX11}/share/X11/locale
    export LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive
  '';
}
