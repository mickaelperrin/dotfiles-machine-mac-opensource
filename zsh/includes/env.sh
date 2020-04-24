## Misc

# Should be defined *before* prezto
export POWERLEVEL9K_MODE='nerdfont-complete'

## PATH

path+=(
  ~/.bin.base
)

export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules

# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

## Python
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/Virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

## Ruby

export GEM_HOME="$HOME/.gem"

## Imgur
# used in alfred workflow
export IMGUR_CLIENT_ID=247f57bb8217a70
