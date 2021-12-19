# Require brew
if ! which brew > /dev/null; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null ;
fi

# Add brex to PATH
if [[ "$(uname -m)" == "arm64" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Require brew cask to install binaries
brew cask > /dev/null || brew install caskroom/cask/brew-cask

# The unarchiver
brew cask list | grep -q the-unarchiver || brew cask install the-unarchiver

# Command not found
brew command command-not-found-init > /dev/null 2>&1 || eval "$(brew command-not-found-init)"

mkdir -p "${HOME}/.npm-packages"
cat "${HOME}/.npmrc" | grep -q 'prefix=' || echo "prefix=${HOME}/.npm-packages" >> "${HOME}/.npmrc"

pip install \
  fd \
  fzf \
  pygments \
  rmtrash \
  terminal-notifier \
