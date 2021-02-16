ZGEN_PATH="${HOME}/.zsh/zgen/zgen.zsh"
export ZSH_PLUGIN_MANAGER="zgen"

source "$ZGEN_PATH"
source "$ZSH_GITHUB_PLUGINS_PATH/plugins.github.sh"


function sourcePluginConfigFile() {
  local configFilePath="${ZSH_GITHUB_PLUGINS_PATH}/conf.d/$1.sh"
  if [ -f $configFilePath ]; then
    source "$configFilePath"
  else
    $DEBUG && echo "  !!! Missing $configFilePath"
  fi
}

function loadGithubPlugins() {

  for plugin in "${githubPlugins[@]}";do
    $DEBUG && echo "Loading ZSH plugin: $plugin"
    pluginName=$(echo "$plugin" | cut -d'/' -f 2)
    [ "$1" = 'conf' ] && sourcePluginConfigFile "$pluginName"
    [ "$1" = 'plugin' ] && zgen load "$plugin"
  done
}

loadGithubPlugins conf

if zgen saved; then
  return
fi

$DEBUG && echo "Loading prezto"
zgen prezto
loadGithubPlugins plugin
zgen save


