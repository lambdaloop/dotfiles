#!/usr/bin/env bash

echo 'source activate dlc; emacs' | nix-shell ~/dotfiles/nixos/conda-shell.nix
