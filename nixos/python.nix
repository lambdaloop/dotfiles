with import <nixpkgs> {};

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
])
