#!/usr/bin/env bash

# echo "source activate '$1' ; ipython --simple-prompt" > /home/pierre/tmp/conda_chainer.sh

# nix-shell ~/dotfiles/nixos/shells/conda-shell.nix

"/home/pierre/miniconda3/envs/$1/bin/ipython" --simple-prompt
