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
if [ -z "$CLAUDECODE" ] || [ "$CLAUDECODE" -ne 1 ]; then
  export ANTIDOTE_CONFIG_TXT="$HOME/.zsh_plugins.txt"
  export ANTIDOTE_CONFIG_ZSH="$HOME/.zsh_plugins.zsh"
else
  export PROMPT='%~
%# '
  export ANTIDOTE_CONFIG_TXT="$HOME/.zsh_plugins_minimal.txt"
  export ANTIDOTE_CONFIG_ZSH="$HOME/.zsh_plugins_minimal.zsh"
fi

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
  export ZSH_CUSTOM_CONFIG_PATH="${HOME}/.zsh/includes/custom.d/1-common"

  if [ -f "${ZSH_CONFIG_PATH}/zsh_plugins.common.txt" ]; then
    cat "${ZSH_CONFIG_PATH}/zsh_plugins.common.txt" >| "$ANTIDOTE_CONFIG_TXT"
  fi
  if [ -f "${ZSH_CONFIG_PATH}/zsh_plugins.custom.txt" ]; then
    cat "${ZSH_CONFIG_PATH}/zsh_plugins.custom.txt" >| "$ANTIDOTE_CONFIG_TXT"
  fi

  envsubst < "$ANTIDOTE_CONFIG_TXT" | addPluginsConfig | antidote bundle 2>/dev/null  >| "$ANTIDOTE_CONFIG_ZSH"
fi

source "$ANTIDOTE_CONFIG_ZSH"

if [ -z "$CLAUDECODE" ] || [ "$CLAUDECODE" -ne 1 ]; then
  eval "$(zoxide init zsh)"

  # Historique des répertoires récents (persistant entre sessions), pour `cd -`.
  # chpwd_recent_dirs n'enregistre qu'en shell interactif (garde -o interactive).
  autoload -Uz add-zsh-hook chpwd_recent_dirs cdr
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 100
  zstyle ':chpwd:*' recent-dirs-default false

  # Navigation façon enhancd : `cd` flou ouvre une liste fzf au lieu de sauter
  # aveuglément. Les chemins réels et `..` gardent le comportement direct.
  # Cas spéciaux :
  #   cd       -> liste interactive frecency (zoxide)
  #   cd ...   -> liste fzf des répertoires parents du courant
  #   cd -     -> liste fzf des 10 derniers répertoires (avant-dernier en tête)
  # `z`/`zi` sont fournis par zoxide (sans --cmd cd) et utilisent `builtin cd`
  # en interne : pas de récursion. `builtin cd` est enregistré par le hook zoxide.
  cd() {
    if (( $# == 0 )); then
      zi                                       # sans argument -> liste frecency
    elif [[ "$1" == "..." ]]; then
      local d="$PWD" target
      local -a parents
      while [[ "$d" != "/" ]]; do             # construit la chaîne des parents
        d="${d:h}"
        parents+=("$d")
      done
      target=$(print -rl -- "${parents[@]}" \
        | fzf --height=40% --layout=reverse --prompt='parent> ') \
        && builtin cd -- "$target"
    elif [[ "$1" == "-" ]]; then
      cdr -r                                   # remplit $reply : récents, courant exclu
      local target
      target=$(print -rl -- "${reply[1,10]}" \
        | fzf --height=40% --layout=reverse --prompt='récent> ') \
        && builtin cd -- "$target"
    elif [[ -d "$1" || "$1" == /* || "$1" == ~* || "$1" == .* ]]; then
      z "$@"                                   # chemin explicite -> cd direct
    else
      zi "$@"                                  # mot-clé flou -> liste fzf pré-filtrée
    fi
  }

  zvm_after_init() {
    eval "$(atuin init zsh --disable-up-arrow)"
  }
fi

# ZPROF profiling output (PROD-001)
if [[ "$ZPROF" = 1 ]]; then
  zprof
fi