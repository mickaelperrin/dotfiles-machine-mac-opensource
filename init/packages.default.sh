#!/usr/bin/env bash
# shellcheck disable=SC2034

BASE_TAPS=(
  dart-lang/dart
  homebrew/cask-fonts
  homebrew/cask-versions
  kaplanelad/tap # shellfirm

)

BASE_PACKAGES=(
  age # required by other
  blackbox # Manage secrets in git
  bumpversion # Version bumper
  certbot # Generate certificates
  ccusage # Claude code usage
  composer # PHP package manager
  coreutils # Required for gshred binary
  curl
  ctop # Docker containers top
  dart # Dart language
  deno # JS runtime
  docker-compose # Docker compose tool
  dnsmasq # DNS local
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
  markdownlint-cli2 # Markdown linter
  md5deep # md5 recursive
  mkcert # Easily create certificates
  multitail # Multiple tail -f used in scripts
  mutagen-io/mutagen/mutagen-compose-beta #File synchronisation for docker volumes (replaces unison)
  mysql-client
  node
  nodenv
  nss  # Install certs in firefox trust store
  php
  php-code-sniffer # PHP linter
  php-cs-fixer # PHP formatter
  pre-commit # Git hooks
  pwgen # password generator
  pyenv
  p7zip
  ruby
  rust # Rust language
  sass # CSS preprocessor
  shellfirm # Intercept risky commands
  stow # Symlink manager (used in claude-code-stacks)
  tig # CLI git client
  trash # move file to macos trash
  tree # Display directory tree in CLI
  uv # Python package manager
  terminal-notifier # Mac OS notifications from CLI
  vim # Text editor
  watch # Command watcher
  wget # CLI downloader
  whois # Domain lookup
  yamllint
  yarn # Faster NPM clone by Facebook
  yq
  zsh # Main shell
)

TOOLS_PACKAGES=(
  colordiff
)

BASE_CASK_PACKAGES=(
  1password
  1password-cli
  arc
  claude # Claude desktop
  claude-code
  clickup
  docker-desktop
  font-hack-nerd-font
  iterm2 # Terminal
  jetbrains-toolbox # phpstorm installer
  gpg-suite-no-mail
  redis-insight # Redis GUI
)

TOOLS_CASK_PACKAGES=(
)

NPM_PACKAGES=(
  bun
  intelephense
  mdtail
  pnpm
  semantic-release
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

GO_PACKAGES=(
)

CARGO_PACKAGES=(
)

MAS_PACKAGES=(
)