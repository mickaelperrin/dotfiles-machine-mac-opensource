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
  dive # Docker image inspection tool
  docker-compose # Docker compose tool
  dos2unix
  fd # Simple fast alternative to find
  findutils
  fswatch
  fzf # fuzzy find tool used in custom scripts
  git
  gnu-getopt #required for some scripts
  git-lfs # Large file storage for git
  gnu-sed # GNU version of sed
  gnu-tar # GNU version of tar
  go # Go languange
  grep # GNU grep used in some scripts (ggrep)
  htop # Top processes
  jq # JSON processor
  md5deep
  multitail # Multiple tail -f used in scripts
  mutagen-io/mutagen/mutagen-compose-beta #File synchronisation for docker volumes (replaces unison)
  node
  nodenv
  peco # Fuzzy filter used in many custom bash scripts
  php
  pwgen # password generator
  pyenv
  p7zip
  svn # required by zinit ZSH plugin manager
  tig # CLI git client
  trash # move file to macos trash
  tree # Display directory tree in CLI
  terminal-notifier # Mac OS notifications from CLI
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
  onepassword-local-search
  onepassword-tools
  pyotp
  virtualenv
  wakatime
)

GEM_PACKAGES=(
  colorls
)

COMPOSER_PACKAGES=(
  davidrjonas/composer-lock-diff
)

MAS_PACKAGES=(
)