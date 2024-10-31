#!/usr/bin/env bash

# Require brew
if ! which brew > /dev/null; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null ;
fi

# Add brew to PATH
if [[ "$(uname -m)" == "arm64" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Require brew cask to install binaries
brew cask > /dev/null || brew install caskroom/cask/brew-cask

mkdir -p "${HOME}/.npm-packages"
grep -q 'prefix=' "${HOME}/.npmrc" || echo "prefix=${HOME}/.npm-packages" >> "${HOME}/.npmrc"

