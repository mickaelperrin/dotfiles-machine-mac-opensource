#!/usr/bin/env bash
# shellcheck disable=SC2034

BASE_TAPS=(
  dart-lang/dart
  kaplanelad/tap # shellfirm
)

BASE_PACKAGES=(
  bash # Modern bash (>=5); macOS ships 3.2, needed by interactive installers
  bats-core # Bash Automated Testing System
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
  expect # Automate interactive CLIs (used in 2-shared deploy)
  fd # Simple fast alternative to find
  findutils # find xargs locate
  fswatch # file change monitor
  fzf # fuzzy find tool used in custom scripts
  fzy # Fuzzy selector (used by enhancd)
  gh # GitHub CLI
  git
  git-filter-repo # Remove files from git history
  git-lfs # Large file storage for git
  glab # GitLab CLI
  glow # Markdown render CLI
  gnu-getopt #required for some scripts
  gnu-sed # GNU version of sed
  gnu-tar # GNU version of tar
  go # Go languange
  grep # GNU grep used in some scripts (ggrep)
  gum # Glamorous shell UI (used in mani scripts)
  htop # Top processes
  jaq # jq clone (imposed by CLAUDE.md)
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
  php@8.3 # PHP 8.3
  php-code-sniffer # PHP linter
  php-cs-fixer # PHP formatter
  pre-commit # Git hooks
  pwgen # password generator
  pyenv
  p7zip
  rsync # Modern rsync (macOS ships an old one; used in 2-shared/3-custom scripts)
  ruby
  rust # Rust language
  sd # find & replace alternative to sed (imposed by CLAUDE.md)
  shellfirm # Intercept risky commands
  stow # Symlink manager (used in claude-code-stacks)
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
  zoxide
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
  claude-code@latest # canal latest retenu
  clickup
  docker-desktop
  font-hack-nerd-font
  ghostty # Terminal GPU (remplace iterm2)
  iterm2 # Terminal (à retirer après bascule complète vers ghostty)
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