#!/bin/bash
set -e

DOTFILES_LOCATION=${DOTFILES_LOCATION_BASE:-~/.dotfiles.base}

if  [ -d "$DOTFILES_LOCATION" ] && [ -d "$DOTFILES_LOCATION"/.git ]; then
  cd "$DOTFILES_LOCATION"
  git pull origin master
else
  mkdir -p "$DOTFILES_LOCATION"
  git clone https://github.com/mickaelperrin/dotfiles-machine-mac-opensource "$DOTFILES_LOCATION"
fi
"${DOTFILES_LOCATION}/install"
