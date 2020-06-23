## Misc

# Should be defined *before* prezto
export POWERLEVEL9K_MODE='nerdfont-complete'

## PATH

path+=(
  ~/.bin.base
)

#export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

## Python
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/Virtualenvs
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
if command -v nodenv 1>/dev/null 2>&1; then
  eval "$(nodenv init -)"
fi
export PATH=$HOME/.yarn/bin:$PATH
export NODE_PATH=$HOME/.npm-global:$NODE_PATH
export PATH=$HOME/.npm-global/bin:$PATH
#export NODE_PATH=$NODE_PATH:$(npm root -g)

## Ruby

export GEM_HOME="$HOME/.gem"

## Imgur
# used in alfred workflow
export IMGUR_CLIENT_ID=247f57bb8217a70

