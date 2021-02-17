if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
module_path+=( "/Users/mickaelperrin/.zinit/bin/zmodules/src" )
zmodload zdharma/zplugin


zinit light zinit-zsh/z-a-submods
export ZSH_PLUGIN_MANAGER="zinit"

export ZSH_GITHUB_PLUGINS_PATH="${ZSH_CONFIG_PATH}/plugins.github.d"
source $ZSH_GITHUB_PLUGINS_PATH/github.plugins.sh

export ZSH_PREZTO_PLUGINS_PATH="${ZSH_CONFIG_PATH}/plugins.prezto.d"
source $ZSH_PREZTO_PLUGINS_PATH/prezto.plugins.sh

export ZSH_OHMYZSH_PLUGINS_PATH="${ZSH_CONFIG_PATH}/plugins.oh-my-zsh.d"
source $ZSH_OHMYZSH_PLUGINS_PATH/oh-my-zsh.plugins.sh

zinit_prezto_prompt() {
  zinit ice depth=1
  zinit light romkatv/powerlevel10k
}

zinit_prezto_completion() {
  zinit ice svn
  zinit snippet "PZT::modules/completion"
  zinit snippet https://gist.githubusercontent.com/mickaelperrin/6162752a75803787fb717750ffd1a97c/raw/a23810cf14af99b9b465f3d7eb7c232df1dce8b0/_symfony
}

zinit_prezto_command-not-found() {
  zinit ice svn wait lucid
  zinit snippet "PZT::modules/command-not-found"
}

zinit_prezto_autosuggestions() {
  zinit ice svn submods'zsh-users/zsh-autosuggestions -> external'
  zinit snippet PZT::modules/autosuggestions
}

zinit_prezto_fasd() {
  zinit ice svn submods'clvv/fasd -> external'
  zinit snippet PZT::modules/fasd
}

zinit_github_g-plane/zsh-yarn-autocompletions() {
  zinit ice atload"zpcdreplay" atclone'./zplug.zsh' wait lucid
  zinit light g-plane/zsh-yarn-autocompletions
}

zinit_github_greymd/docker-zsh-completion() {
  zinit lucid has'docker' for \
  as'completion' is-snippet \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  \
  as'completion' is-snippet \
  'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose' \
}

function sourcePluginConfigFile() {
  local configFilePath="$1/$2$3.sh"
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

function loadPlugins() {
  local source="$1"
  case "$source" in
    'github')
      local plugins=("${githubPlugins[@]}")
      local configFilePath="${ZSH_GITHUB_PLUGINS_PATH}/conf.d"
      local prefix=""
      local command='zinit wait lucid atload"zicompinit; zicdreplay" blockf for '
      ;;
    'prezto')
      local plugins=("${preztoPlugins[@]}")
      local configFilePath="${ZSH_PREZTO_PLUGINS_PATH}/conf.d"
      local prefix="PZT::modules/"
      local command="zinit ice svn && zinit snippet "
      ;;
    'oh-my-zsh')
      local plugins=("${ohMyZSHPlugins[@]}")
      local configFilePath="${ZSH_OHMYZSH_PLUGINS_PATH}/conf.d"
      local prefix="OMZP::"
      local command="zinit ice svn && zinit snippet "
      ;;
  esac
  for plugin in ${plugins[@]}; do
    $DEBUG && echo "Loading $source plugin: $plugin"
    sourcePluginConfigFile "$configFilePath" "$plugin"
    if ! whence -w zinit_${source}_${plugin} > /dev/null; then
       eval "$command $prefix$plugin"
    else
      zinit_${source}_$plugin
    fi
    sourcePluginConfigFile "$plugin" '.override'
  done
  zstyle ':prezto:load' pmodule
}

loadPlugins prezto
loadPlugins oh-my-zsh
loadPlugins github

