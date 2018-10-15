#!/usr/bin/env bash

h1() {
  echo
  echo
  echo
  echo "==================================================================="
  echo "$1"
  echo "==================================================================="
  echo
}

read -r -p "Do you want to setup the default Mac OS congfiguration ? This will overwrite your current settings. [Y/n] " response
 case "$response" in
   [Nn][Oo]|[nN])
     return
   ;;
esac

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

h1 "Mac OS: keyboard"
echo "# Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 20

h1 "Mac OS: terminal"
echo "# Enable Secure Keyboard Entry in Terminal.app"
echo "# See: https://security.stackexchange.com/a/47786/8918"
defaults write com.apple.terminal SecureKeyboardEntry -bool true


###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"SystemUIServer" \
	"Terminal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
