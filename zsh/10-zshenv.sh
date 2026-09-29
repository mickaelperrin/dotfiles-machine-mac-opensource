#!/opt/homebrew/bin/zsh

# ZPROF profiling support (PROD-001)
# Usage: ZPROF=1 zsh -i -c exit
if [[ "$ZPROF" = 1 ]]; then
  zmodload zsh/zprof
fi

# Overwrite default path generated with /usr/libexec/path_helper -s in /etc/profile
# To remove brew
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin"

source "${ZDOTDIR:-$HOME}/.zprofile"

if [ -f "${ZDOTDIR:-$HOME}/.zprofile.custom" ]; then
  source "${ZDOTDIR:-$HOME}/.zprofile.custom"
fi

# Tier-3 environment needed by non-interactive shells too: scripts and agents
# (e.g. Claude Code's Bash tool) never read .zshrc, so variables left to the
# $ENVS bundle were missing there — collect_server_data.sh then lacked its
# ONEPASS_* references and fell back to an impossible sudo password prompt.
# Conditional: the stack is shared, and only a machine with tier 3 has the file.
# sourceFolder in .zshrc skips this exact path so it is not loaded twice.
ZSHENV_EARLY_ENV="${HOME}/.zsh/includes/env/3-custom/env.misc.sh"
if [ -f "$ZSHENV_EARLY_ENV" ]; then
  source "$ZSHENV_EARLY_ENV"
fi