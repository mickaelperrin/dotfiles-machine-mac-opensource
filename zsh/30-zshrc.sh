#!/opt/homebrew/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ANTIDOTE_DIR=${ZDOTDIR:-~}/.antidote

if [ ! -d ${ANTIDOTE_DIR}/.git ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

export ZSH_CONFIG_PATH="${HOME}/.zsh/includes"
export ANTIDOTE_CONFIG_TXT="$HOME/.zsh_plugins.txt"
export ANTIDOTE_CONFIG_ZSH="$HOME/.zsh_plugins.zsh"

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Lazy-load antidote from its functions directory.
fpath=(${ANTIDOTE_DIR}/functions $fpath)
autoload -Uz antidote

if [ ! -f "$ANTIDOTE_CONFIG_ZSH" ]; then

  function sourceFolder() {
    local configFolderPath="$ZSH_CONFIG_PATH/$1"
    # --unrestricted is required because shared and custom folders are git ignored
    fd ".*\.sh$" $configFolderPath --type f --absolute-path --follow --unrestricted| sort
  }

  function addPluginsConfig() {
    while IFS= read -r line; do
      local firstWord=$(echo "$line" | awk '{print $1}')
        # Line is empty
        # Line is a comment or an absolute path
        if [[ $firstWord =~ ^[/#~] ]] || [ -z $line ]; then
          echo "$line"
        elif [[ $firstWord =~ ^custom\.d ]]; then
          local pluginName=$(basename $firstWord)
          local customPath=${ZSH_CONFIG_PATH}/custom.d
          fd "${pluginName}" $customPath -I --glob --type f --absolute-path --follow --unrestricted  | sort
        else
          local pluginName=$(basename $firstWord)
          local configPath=${ZSH_CONFIG_PATH}/plugins.config.d
          fd "${pluginName}.before.sh" $configPath -I --glob --type f --absolute-path --follow --unrestricted | sort
          echo "$line"
          fd "${pluginName}.sh" $configPath -I --glob --type f --absolute-path --follow  | sort
        fi
    done
  }

  # Those vars are used by envsubst
  export ALIASES=$(sourceFolder alias)
  export FUNCTIONS=$(sourceFolder functions)
  export ENVS=$(sourceFolder env)
  export ZSH_CUSTOM_CONFIG_PATH="${HOME}/.zsh/includes/config.d"

  if [ -f "${ZSH_CONFIG_PATH}/zsh_plugins.common.txt" ]; then
    cat "${ZSH_CONFIG_PATH}/zsh_plugins.common.txt" >| "$ANTIDOTE_CONFIG_TXT"
  fi
  if [ -f "${ZSH_CONFIG_PATH}/zsh_plugins.custom.txt" ]; then
    cat "${ZSH_CONFIG_PATH}/zsh_plugins.custom.txt" >| "$ANTIDOTE_CONFIG_TXT"
  fi

  envsubst < "$ANTIDOTE_CONFIG_TXT" | addPluginsConfig | antidote bundle >| "$ANTIDOTE_CONFIG_ZSH"
fi

source "$ANTIDOTE_CONFIG_ZSH"
