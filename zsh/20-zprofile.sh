#!/opt/homebrew/bin/zsh

# Executes commands at login pre-zshrc.

# Browser
# -------
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
# -------
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Language
# -------
if [[ -z "$LANG" ]]; then
  export LANG='fr_FR.UTF-8'
fi

# Paths
# -----
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

path+=(
  # Custom bin
  $HOME/{bin,.bin,.bin.base}
  # Globally installed composer packages
  $HOME/.composer/vendor/bin
  # Globally installed gems
  $HOME/.gem/bin
  # Globally installed RVM
  $HOME/.rvm/bin
  # Rust
  $HOME/.cargo/bin
  # Added by Toolbox App
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
)
# Append homebrew bin on Silicon
if [[ "$(uname -m)" == "arm64" ]]; then
  # Can't be dynamic
  path=(/opt/homebrew/bin $path)
fi

# Prepend ~/.bin after homebrew so our wrappers take priority
path=($HOME/.bin $path)

# Less
# ----
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Python
# ------
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/.virtualenvs
[ -d $WORKON_HOME ] || mkdir -p $WORKON_HOME
export VIRTUALENVWRAPPER_VIRTUALENV=$(brew --prefix)/bin/virtualenv
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

export PYENV_ROOT="${HOME}/.pyenv"
[ -d $PYENV_ROOT ] || mkdir -p $PYENV_ROOT

if (( ${+commands[pyenv]} )); then
  # Regenerate the init cache whenever the toolchain changes. The resolved
  # binary paths carry the Homebrew Cellar version, so installing, upgrading
  # or removing pyenv / pyenv-virtualenv all invalidate the cache. Guarding
  # on mere file existence froze a cache generated while pyenv-virtualenv was
  # not yet installed, leaving `pyenv activate` broken indefinitely.
  () {
    local sig="# sig: ${commands[pyenv]:A}|${commands[pyenv-virtualenv-init]:A}"
    local cache="${PYENV_ROOT}/zpyenv.zsh"
    local first='' src=''

    [[ -s $cache ]] && read -r first < $cache
    [[ $first == $sig ]] && return 0

    src="$(pyenv init - --no-rehash zsh)"
    (( ${+commands[pyenv-virtualenv-init]} )) && \
      src+=$'\n'"$(pyenv virtualenv-init - zsh)"

    # Only overwrite on non-empty output: a failed generation must never be
    # frozen in place.
    [[ -n $src ]] && print -r -- "$sig"$'\n'"$src" >! $cache
  }

  [[ -s "${PYENV_ROOT}/zpyenv.zsh" ]] && source "${PYENV_ROOT}/zpyenv.zsh"
  path=($HOME/.local/bin $PYENV_ROOT/bin $path)
fi

# Node
# ----
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export NODENV_ROOT="${HOME}/.nodenv"
[ -d $NODENV_ROOT ] || mkdir -p $NODENV_ROOT
if (( ${+commands[nodenv]} )); then
  # Same cache-invalidation contract as pyenv above.
  () {
    local sig="# sig: ${commands[nodenv]:A}"
    local cache="${NODENV_ROOT}/nodenv.zsh"
    local first='' src=''

    [[ -s $cache ]] && read -r first < $cache
    [[ $first == $sig ]] && return 0

    src="$(nodenv init - --no-rehash zsh)"
    [[ -n $src ]] && print -r -- "$sig"$'\n'"$src" >! $cache
  }

  [[ -s "${NODENV_ROOT}/nodenv.zsh" ]] && source "${NODENV_ROOT}/nodenv.zsh"
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Ruby
# ----
export GEM_HOME="$HOME/.gem"

# Parallel
# --------
export PARALLEL_HOME="$HOME/.parallel"
export PARALLEL_SHELL=$(which zsh)

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
