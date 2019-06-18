#!/usr/bin/env bash

echo 'source activate dlc; emacs' | nix-shell ~/dotfiles/nixos/shells/conda-shell.nix
