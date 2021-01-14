BASE_TAPS=(
  homebrew/core
  homebrew/cask
  homebrew/cask-fonts
  homebrew/cask-versions
)

BASE_PACKAGES=(
  composer # PHP package manager
  coreutils # Required for gshred binary
  ctop # Docker containers top
  docker-compose # Docker compose tool
  dos2unix
  fd # Simple fast alternative to find
  findutils
  fswatch
  fzf # fuzzy find tool used in custom scripts
  git
  gnu-getopt
  git-lfs # Large file storage for git
  gnu-sed # GNU version of sed
  gnu-tar # GNU version of tar
  go # Go languange
  grep # GNU grep used in some scripts (ggrep)
  htop # Top processes
  jq # JSON processor
  md5deep
  node
  nodenv
  peco # Fuzzy filter used in many custom bash scripts
  php
  pyenv
  p7zip
  rmtrash # move file to macos trash
  tig # CLI git client
  tree # Display directory tree in CLI
  terminal-notifier # Mac OS notifications from CLI
  unison # File synchronize used mainly to resolve performance issues with Docker
  vim # Text editor
  wget # CLI downloader
  xmlstarlet # CLI file editor used in wordpress generator
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
  docker-edge
  font-hack-nerd-font
  iterm2 # Terminal
  jetbrains-toolbox # phpstorm installer
  vagrant
  gpg-suite
)

TOOLS_CASK_PACKAGES=(
)

NPM_PACKAGES=(
)

PIP_PACKAGES=(
  pygments
  onepassword-local-search
  onepassword-tools
  pyotp
)

GEM_PACKAGES=(
  colorls
)

COMPOSER_PACKAGES=(
  davidrjonas/composer-lock-diff
)

MAS_PACKAGES=(
)