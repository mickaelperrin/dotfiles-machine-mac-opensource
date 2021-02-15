## Misc

# Should be defined *before* prezto
export POWERLEVEL9K_MODE='nerdfont-complete'

## PYTHON
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_VIRTUALENV=$(brew --prefix)/bin/virtualenv
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

# Manage PYENV on M1 Mac and rosetta
if [[ "$(uname -m)" == "arm64" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
  export PYENV_ROOT=$(pyenv root)
else
  export PYENV_ROOT="$(pyenv root).x86_64"
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

## NODE
export NODE_PATH=$HOME/.npm-global:$NODE_PATH
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

if command -v nodenv 1>/dev/null 2>&1; then
  eval "$(nodenv init -)"
fi

## Ruby
export GEM_HOME="$HOME/.gem"


