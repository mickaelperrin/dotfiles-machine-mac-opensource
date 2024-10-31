#!/opt/homebrew/bin/zsh

# Overwrite default path generated with /usr/libexec/path_helper -s in /etc/profile
# To remove brew
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin"

source "${ZDOTDIR:-$HOME}/.zprofile"

if [ -f "${ZDOTDIR:-$HOME}/.zprofile.custom" ]; then
  source "${ZDOTDIR:-$HOME}/.zprofile.custom"
fi