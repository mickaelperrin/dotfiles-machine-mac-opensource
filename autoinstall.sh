#!/bin/bash
set -e

DOTFILES_LOCATION=${DOTFILES_LOCATION:-~/.dotfiles.base}

mkdir -p $DOTFILES_LOCATION
git clone https://github.com/mickaelperrin/dotfiles-machine-mac-opensource $DOTFILES_LOCATION
$DOTFILES_LOCATION/install
