with import <nixpkgs> {};

let
python = pkgs.python2.buildEnv.override {
   extraLibs = with pkgs.python2Packages; [
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
    scikitlearn
    scipy
    seaborn
    tkinter
    toml
    tqdm
    toolz
    virtualenv];
   ignoreCollisions = true;
};

in mkShell  {
 name = "python2-env";
 ignoreCollisions = true;
  buildInputs = [ python ];
  shellHook = ''
            alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
            export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python2.7/site-packages:$PYTHONPATH"
            unset SOURCE_DATE_EPOCH
  '';
  }

