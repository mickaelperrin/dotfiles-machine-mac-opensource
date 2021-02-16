# Sets Prezto options.

export ZSH_PREZTO_PLUGINS_PATH="${ZSH_CONFIG_PATH}/plugins.prezto.d"
source $ZSH_PREZTO_PLUGINS_PATH/prezto.plugins.sh

function sourcePluginConfigFile() {
  local configFilePath="${ZSH_PREZTO_PLUGINS_PATH}/conf.d/$1$2.sh"
  if [ -f $configFilePath ]; then
    source "$configFilePath"
  else
    # Do not throw warning for config overrides
    if [ -z $2 ]; then
      $DEBUG && echo "  !!! Missing configuration file for prezto plugin $1..."
      $DEBUG && echo "$configFilePath not found"
    fi
  fi
}

function loadPreztoPlugins() {
  for plugin in "${preztoPlugins[@]}"; do
    $DEBUG && echo "Loading prezto plugin: $plugin"
    sourcePluginConfigFile "$plugin"
    pmodload "$plugin"
    sourcePluginConfigFile "$plugin" '.override'
  done
  # Prevent that modules get loaded twice
  zstyle ':prezto:load' pmodule
}

loadPreztoPlugins

