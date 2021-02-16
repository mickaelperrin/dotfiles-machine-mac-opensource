# Documentation at https://github.com/b4b4r07/enhancd
export ENHANCD_FILTER="fzf:/usr/local/bin/peco:fzy:non-existing-filter"

export ENHANCD_AUTO_LS=true
export ENHANCD_GIT_STATUS=true
export ENHANCD_LAST_DIR=

function _after_cd() {
  # Do run hook twice on same folder
  [ "$(pwd)" != "$ENHANCD_LAST_DIR" ] && ENHANCD_LAST_DIR=$(pwd) || return

  # If colorls exists, use it
  if which colorls > /dev/null; then
    echo
    colorls --dark --gs --dirs --almost-all
    echo
    colorls --dark --gs --files --almost-all
    echo
    return
  fi

  # If k (zsh plugin) exists, use it
  if which k > /dev/null; then
    k --almost-all --no-vcs --human; return
  fi

  # Run ls command
  $ENHANCD_AUTO_LS && ls -A

  # Run git status
  if $ENHANCD_GIT_STATUS; then
    local gitdir="$(git rev-parse --git-dir 2>/dev/null)"
    if [ -n "$gitdir" ]; then
      echo; git status -sb
    fi
  fi
}

export ENHANCD_HOOK_AFTER_CD=_after_cd