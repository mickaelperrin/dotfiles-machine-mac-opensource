# Executes commands at login pre-zshrc.

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='fr_FR.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path+=(

  # Custom bin
  $HOME/{bin,.bin,.bin.base,.bin.shared,.bin.custom}

  # Globally installed composer packages
  $HOME/.composer/vendor/bin

  # Globally installed gems
  $HOME/.gem/bin

  # Globally installed RVM
  $HOME/.rvm/bin
)

if [[ "$(uname -m)" == "arm64" ]]; then
  path=(/opt/homebrew/bin $path)
fi


fpath+=(
  "$HOME/.zsh/includes/completions.d"
  "$HOME/.zsh/includes/completions.d/custom"
  "$HOME/.zsh/includes/completions.d/shared"
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi


# Should be defined *before* prezto
export POWERLEVEL9K_MODE='nerdfont-complete'

## PYTHON
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/.virtualenvs.$(uname -m)
[ -d $WORKON_HOME ] || mkdir -p $WORKON_HOME
export VIRTUALENVWRAPPER_VIRTUALENV=$(brew --prefix)/bin/virtualenv
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

# Manage PYENV on M1 Mac and rosetta
if [[ "$(pyenv root)" == *"$(uname -m)"* ]]; then
  export PYENV_ROOT="$(pyenv root)"
else
  export PYENV_ROOT="$(pyenv root).$(uname -m)"
fi
[ -d $PYENV_ROOT ] || mkdir -p $PYENV_ROOT

if command -v pyenv 1>/dev/null 2>&1; then
  if [[ ! -f "${PYENV_ROOT}/zpyenv.zsh" ]]; then
    {
      pyenv init - --no-rehash zsh
      pyenv virtualenv-init - zsh
    } >"${PYENV_ROOT}/zpyenv.zsh"
  fi
  source "${PYENV_ROOT}/zpyenv.zsh"
fi

## NODE
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export NODENV_ROOT="${HOME}/.nodenv.$(uname -m)"
[ -d $NODENV_ROOT ] || mkdir -p $NODENV_ROOT
if command -v nodenv 1>/dev/null 2>&1; then
  if [[ ! -f "${NODENV_ROOT}/nodenv.zsh" ]]; then
    {
      nodenv init - --no-rehash zsh
    } >"${NODENV_ROOT}/nodenv.zsh"
  fi
  source "${NODENV_ROOT}/nodenv.zsh"
fi

## Ruby
export GEM_HOME="$HOME/.gem.$(uname -m)"

## Parallel
export PARALLEL_HOME="$HOME/.parallel.$(uname -m)"
export PARALLEL_SHELL=$(which zsh)