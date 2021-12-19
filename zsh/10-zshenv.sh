#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Overwrite default path generated with /usr/libexec/path_helper -s in /etc/profile
# To remove brew
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin"

source "${ZDOTDIR:-$HOME}/.zprofile"
