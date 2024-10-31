#!/usr/bin/env bash
# shellcheck disable=SC2034

BASE_TAPS=(
  homebrew/core
  homebrew/cask
  homebrew/cask-fonts
  homebrew/cask-versions
  kaplanelad/tap # shellfirm
)

BASE_PACKAGES=(
  blackbox # Manage secrets in git
  composer # PHP package manager
  clickup # Project maangament tool
  coreutils # Required for gshred binary
  ctop # Docker containers top
  docker-compose # Docker compose tool
  dos2unix # Convert text format
  fd # Simple fast alternative to find
  findutils # find xargs locate
  fswatch # file change monitor
  fzf # fuzzy find tool used in custom scripts
  git
  git-filter-repo # Remove files from git history
  gnu-getopt #required for some scripts
  git-lfs # Large file storage for git
  gnu-sed # GNU version of sed
  gnu-tar # GNU version of tar
  go # Go languange
  grep # GNU grep used in some scripts (ggrep)
  htop # Top processes
  jq # JSON processor
  lnav # Log file viewer
  md5deep # md5 recursive
  multitail # Multiple tail -f used in scripts
  mutagen-io/mutagen/mutagen-compose-beta #File synchronisation for docker volumes (replaces unison)
  mysql-client
  node
  nodenv
  php
  pwgen # password generator
  pyenv
  p7zip
  shellfirm # Intercept risky commands
  tig # CLI git client
  trash # move file to macos trash
  tree # Display directory tree in CLI
  terminal-notifier # Mac OS notifications from CLI
  vim # Text editor
  wget # CLI downloader
  yarn # Faster NPM clone by Facebook
  yq
  zsh # Main shell
)

TOOLS_PACKAGES=(
  colordiff
)

BASE_CASK_PACKAGES=(
  alfred # effective launcher and much more
  1password
  1password-cli
  font-hack-nerd-font
  iterm2 # Terminal
  jetbrains-toolbox # phpstorm installer
  gpg-suite-no-mail
)

TOOLS_CASK_PACKAGES=(
)

NPM_PACKAGES=(
)

PIP_PACKAGES=(
  pygments
  pyotp
  virtualenv
)

GEM_PACKAGES=(
)

COMPOSER_PACKAGES=(
  davidrjonas/composer-lock-diff
)

MAS_PACKAGES=(
)