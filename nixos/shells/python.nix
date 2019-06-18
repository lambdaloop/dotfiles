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
  python-rofi
])
