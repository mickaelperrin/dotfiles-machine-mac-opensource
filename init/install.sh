#!/usr/bin/env bash
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALLED_PACKAGES=
INSTALLED_CASK_PACKAGES=
INSTALLED_TAPS=
INSTALLED_GEMS=
INSTALLED_NPM_PACKAGES=
INSTALLED_PIP_PACKAGES=
export CURL_SSL_BACKEND=secure-transport

if [ -e "${SCRIPT_DIR}/packages.sh" ]; then
  # shellcheck disable=SC1090
  . "${SCRIPT_DIR}/packages.sh"
else
  # shellcheck source=./packages.default.sh
  . "${SCRIPT_DIR}/packages.default.sh"
fi


askForPackagesUpdate() {
  local answer
  read -rp "Do you want to install/update software ? [Y/n] " answer
  case ${answer:0:1} in
    n|N) exit ;;
    *) return;;
  esac
}

brewInstall() {
  h1 "Brew installation"

  if ! which brew > /dev/null; then
    echo "Installing Brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  else
    echo "Brew already installed. Skipping..."
  fi
}

getInstalledPackages() {
  h1 "Get installed packages"

  INSTALLED_PACKAGES=$(brew list --formula -1)
  INSTALLED_CASK_PACKAGES=$(brew list --cask -1)
  INSTALLED_TAPS=$(brew tap)
  INSTALLED_GEMS=$(gem list --no-versions || true)
  INSTALLED_NPM_PACKAGES=$(ls -1 "$(npm root -g || true)")
  INSTALLED_PIP_PACKAGES=$(pip list | awk '{print $1}' | tail -n+3 || true)
  INSTALLED_COMPOSER_PACKAGES=$(composer global show 2>/dev/null | awk '{print $1}' || true)

  echo "Installed brew taps:"
  echo "$INSTALLED_TAPS"
  echo "--"
  echo
  echo "Installed brew packages:"
  echo "$INSTALLED_PACKAGES"
  echo "--"
  echo
  echo "Installed brew packages:"
  echo "$INSTALLED_CASK_PACKAGES"
  echo "--"
  echo
  echo "Installed gems:"
  echo "$INSTALLED_CASK_PACKAGES"
  echo "--"
  echo
  echo "Installed NPM packages:"
  echo "$INSTALLED_NPM_PACKAGES"
  echo "--"
  echo
  echo "Installed PIP packages:"
  echo "$INSTALLED_PIP_PACKAGES"
  echo "--"
  echo
  echo "Installed COMPOSER packages:"
  echo "$INSTALLED_COMPOSER_PACKAGES"
  echo "--"
  echo
}

brewTaps() {

  h1 "Install brew taps"
  local taps=("${@}") tap

  for tap in "${taps[@]}"; do
    if [ "$tap" = "" ]; then
      continue
    fi
    if ! echo "$INSTALLED_TAPS" | grep -q "^$tap$"; then
      echo "Installing tap $tap..."
      brew tap "$tap"
    else
      echo "Tap '$tap' alreasy installed. Skipping..."
    fi
  done
}

brewInstallPackages() {

  local cask=
  local alreadyInstalled=$INSTALLED_PACKAGES

  if [ "$1" = 'cask' ]; then
    cask="--cask"
    alreadyInstalled=$INSTALLED_CASK_PACKAGES
    shift
  fi

  local category=$1
  shift

  h1 "Install brew $cask $category packages"

  local packages=("${@}")

  for package in "${packages[@]}"; do
    if [ "$package" = "" ]; then
      continue
    fi
    if ! echo "$alreadyInstalled" | grep -q "$package"; then
      echo "Installing brew package $package..."
      brew install $cask "$package"
      age
    else
      echo "Package '$package' alreasy installed. Skipping..."
    fi
  done
}

brewSpecificPackages() {
  return
}

composerPackages() {

  h1 "PHP packages"

  local packages=("${@}")
  local alreadyInstalled=$INSTALLED_COMPOSER_PACKAGES

  for package in "${packages[@]}"; do
    if [ "$package" = "" ] || echo "$alreadyInstalled" | grep -q "$package";  then
      [ "$package" = '' ] || echo "$package already installed"
      continue
    fi
    echo "Installing $package..."
    composer global require "$package"
  done
}

npmPackages() {

  h1 "Node packages"

  local packages=("${@}")
  local alreadyInstalled=$INSTALLED_NPM_PACKAGES

  for package in "${packages[@]}"; do
    if [ "$package" = "" ] || echo "$alreadyInstalled" | grep -q "$package";  then
      [ "$package" = '' ] || echo "$package already installed"
      continue
    fi
    echo "Installing $package..."
    npm install -g "$package"
  done
}

gemPackages() {

  h1 "Ruby packages (gem)"

  local packages=("${@}")
  local alreadyInstalled=$INSTALLED_GEMS

  for package in "${packages[@]}"; do
    if [ "$package" = "" ] || echo "$alreadyInstalled" | grep -q "$package"; then
      [ "$package" = '' ] || echo "$package already installed"
      continue
    fi
    echo "Installing $package..."
    GEM_HOME=~/.gen GEM_PATH=~/.gem gem install "$package"
  done
}

h1() {
  echo
  echo
  echo
  echo "==================================================================="
  echo "$1"
  echo "==================================================================="
  echo
}

masPackages() {

  h1 "Apple Store software"

  local packages=("${@}")

  if ! which mas >/dev/null; then
    brew install mas
  fi

  if ! mas account; then
    echo "You must be signed-in in the Mac app store to install the software"
    return
  fi

  for package in "${packages[@]}"; do
    if [ "$package" = "" ]; then
      continue
    fi
    echo "Installing $package..."
    mas install "$package"
  done
}

pipPackages() {

  h1 "Pyton packages (pip)"

  local packages=("${@}")
  local alreadyInstalled=$INSTALLED_PIP_PACKAGES

  if command -v pyenv 1>/dev/null 2>&1; then
    if ! pyenv global 3.9.11; then
      pyenv install 3.9.11
      pyenv global 3.9.11
    fi
    eval "$(pyenv init -)"
  else
    echo "pyenv not installed. Aborting..."
    exit 1
  fi

  if ! which pip > /dev/null; then
    sudo easy_install pip
  fi

  for package in "${packages[@]}"; do
   if [ "$package" = "" ] || echo "$alreadyInstalled" | grep -q "$package"; then
      [ "$package" = '' ] || echo "$package already installed"
      continue
    fi
    echo "Installing $package..."
    PIP_REQUIRE_VIRTUALENV="" pip install "$package"
  done
}

requiredFolders() {

  h1 "Initialize required folders"

  # Ensure ssh directories are created
  [ -d ~/.ssh/config.d ] || mkdir -p ~/.ssh/config.d
}

vimPluginsInstall() {

  h1 "Vim plugins"

  # Auto install vim plugins
  vim +PlugInstall +qall!
}

xcodeInstall() {
  h1 "Developer tools installation (xcode)"
# Download and install Command Line Tools if no developer tools exist
#       * previous evaluation didn't work completely, due to gcc binary existing for vanilla os x install
#       * gcc output on vanilla osx box:
#       * 'xcode-select: note: no developer tools were found at '/Applications/Xcode.app', requesting install.
#       * Choose an option in the dialog to download the command line developer tools'
#
# Evaluate 2 conditions
#       * ensure dev tools are installed by checking the output of gcc
#       * check to see if gcc binary even exists ( original logic )
# if either of the conditions are met, install dev tools
if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]]; then
  echo "Info   | Install   | xcode"
  xcode-select --install
else
  echo "developer tools already installed. Skipping..."
fi
}

zshInstall() {

  h1 "ZSH requirements"

  # ZGZN is a plugin manager for ZSH
  [ -d "${HOME}/.zsh/zgen" ] || git clone https://github.com/tarjoilija/zgen "${HOME}/.zsh/zgen"

  # Store history in a DB
  [ -d "${HOME}/.zsh/zsh-histdb" ] || git clone https://github.com/larkery/zsh-histdb "${HOME}/.zsh/zsh-histdb"

  # Set zsh as default shell
  if dscl . -read "/Users/$(whoami)" UserShell | awk '{print $2}' | grep -qv '/zsh'; then
    echo "Changing the default shell. This will prompt a password request."
    if ! grep -q "$(which zsh)" /etc/shells; then
      which zsh | sudo tee -a /etc/shells
    fi
    chsh -s "$(which zsh)"
  else
    echo "Default shell is already zsh. Skipping..."
  fi

}

askForPackagesUpdate

if [ "$(uname)" == "Darwin" ]; then
  xcodeInstall
  brewInstall
  getInstalledPackages
  brewTaps "${BASE_TAPS[@]}"
  brewInstallPackages base "${BASE_PACKAGES[@]}"
  brewInstallPackages tools "${TOOLS_PACKAGES[@]}"
  brewSpecificPackages
  brewInstallPackages cask base "${BASE_CASK_PACKAGES[@]}"
  brewInstallPackages cask tools "${TOOLS_CASK_PACKAGES[@]}"
  masPackages "${MAS_PACKAGES[@]}"
fi

npmPackages "${NPM_PACKAGES[@]}"
pipPackages "${PIP_PACKAGES[@]}"
gemPackages "${GEM_PACKAGES[@]}"
composerPackages "${COMPOSER_PACKAGES[@]}"
requiredFolders
zshInstall
vimPluginsInstall
