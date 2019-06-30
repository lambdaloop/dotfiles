with import <nixpkgs> {};

let python-rofi = python3.pkgs.buildPythonPackage rec {
      name = "python-rofi";
      version = "1.0.1";
      src = pkgs.fetchgit { url = "git://github.com/bcbnz/python-rofi"; sha256 = "0mbg00bzz8c8bpgbi05myj8rk4zlql440cndwnhav63cn84kkrwa"; rev = "d20b3a2ba4ba1b294b002f25a8fb526c5115d0d4"; };
      doCheck = false;
      buildInputs = [];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/bcbnz/python-rofi";
        license = licenses.mit;
        description = "Create simple GUIs using the Rofi application";
      };
    };
in
python3.withPackages (ps: with ps; [
  dbus
  dbus-python
  h5py
  ipython
  kitchen
  matplotlib
  notebook
  numba
  numpy
  opencv3
  pandas
  pip
  pydbus
  python-rofi
  scikitlearn
  scipy
  seaborn
  tkinter
  toml
  tqdm
  toolz
  virtualenv
])
