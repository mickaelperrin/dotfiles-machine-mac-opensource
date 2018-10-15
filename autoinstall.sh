#!/bin/bash
set -e

DOTFILES_LOCATION=${DOTFILES_LOCATION:-~/.dotfiles.base}

if  [ -d $DOTFILES_LOCATION -a -d $DOTFILES_LOCATION/.git ]; then
  cd $DOTFILES_LOCATION
  git pull origin master
else
  git clone https://github.com/mickaelperrin/dotfiles-machine-mac-opensource $DOTFILES_LOCATION
fi
$DOTFILES_LOCATION/install
