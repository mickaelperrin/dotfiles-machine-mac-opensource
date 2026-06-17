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

  # Assemble the effective plugin list: the base list ($ANTIDOTE_CONFIG_TXT is a
  # symlink owned by the top-most installed tier) plus optional additive fragments
  # that higher tiers drop into ~/.zsh/includes (e.g. zsh_plugins.custom.txt from
  # 2-shared). Build into a separate file so the symlinked base list is never
  # overwritten, then bundle from the assembled result.
  _zsh_plugins_assembled="${ANTIDOTE_CONFIG_TXT:r}.assembled.txt"
  cat "$ANTIDOTE_CONFIG_TXT" >| "$_zsh_plugins_assembled"
  for _zsh_plugins_fragment in \
    "${ZSH_CONFIG_PATH}/zsh_plugins.common.txt" \
    "${ZSH_CONFIG_PATH}/zsh_plugins.custom.txt"; do
    [ -f "$_zsh_plugins_fragment" ] || continue
    print >> "$_zsh_plugins_assembled"
    cat "$_zsh_plugins_fragment" >> "$_zsh_plugins_assembled"
  done
  unset _zsh_plugins_fragment

  envsubst < "$_zsh_plugins_assembled" | addPluginsConfig | antidote bundle 2>/dev/null >| "$ANTIDOTE_CONFIG_ZSH"
fi

source "$ANTIDOTE_CONFIG_ZSH"

if [ -z "$CLAUDECODE" ] || [ "$CLAUDECODE" -ne 1 ]; then
  # Historique des répertoires récents (persistant entre sessions), pour `cd -`.
  # chpwd_recent_dirs n'enregistre qu'en shell interactif (garde -o interactive).
  autoload -Uz add-zsh-hook chpwd_recent_dirs cdr
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 100
  zstyle ':chpwd:*' recent-dirs-default false

  # La navigation `cd` personnalisée dépend de zoxide (`z`/`zi`). Sur une machine
  # neuve où `./install` n'a pas encore installé zoxide, on conserve le `cd` natif
  # pour éviter « cd: command not found: z » à chaque changement de répertoire.
  if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"

  # Navigation façon enhancd : `cd` flou ouvre une liste fzf au lieu de sauter
  # aveuglément. Les chemins réels et `..` gardent le comportement direct.
  # Cas spéciaux :
  #   cd       -> liste interactive frecency (zoxide)
  #   cd ...   -> liste fzf des répertoires parents du courant
  #   cd -     -> liste fzf des 10 derniers répertoires (avant-dernier en tête)
  #   cd @     -> racine du dépôt git courant
  #   cd ,     -> liste fzf des répertoires frères (même parent)
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
    elif [[ "$1" == "@" ]]; then
      local root                               # racine du dépôt git courant
      root=$(git rev-parse --show-toplevel 2>/dev/null) \
        && builtin cd -- "$root" \
        || print -u2 "cd: pas dans un dépôt git"
    elif [[ "$1" == "," ]]; then
      local target
      local -a siblings
      siblings=("${PWD:h}"/*(N-/))            # répertoires du parent (nullglob)
      siblings=(${siblings:#$PWD})             # exclut le répertoire courant
      target=$(print -rl -- "${siblings[@]}" \
        | fzf --height=40% --layout=reverse --prompt='frère> ') \
        && builtin cd -- "$target"
    elif [[ -d "$1" || "$1" == /* || "$1" == ~* || "$1" == .* ]]; then
      z "$@"                                   # chemin explicite -> cd direct
    else
      zi "$@"                                  # mot-clé flou -> liste fzf pré-filtrée
    fi
  }
  fi

  # Atuin — sélection du mode de recherche selon la version installée.
  # daemon-fuzzy (>= 18.13) sert la recherche depuis un index en mémoire du daemon
  # et élimine la latence "cold-start" du Ctrl+R. Sur une version antérieure, ce mode
  # ferait échouer le chargement des settings (donc tout `atuin`) : on reste alors en
  # fuzzy (défaut) et on affiche un rappel de mise à jour, sans rien casser.
  # Coût de démarrage nul : `atuin --version` n'est relancé que si le binaire a changé.
  () {
    local cachedir="${XDG_CACHE_HOME:-$HOME/.cache}"
    local cache="$cachedir/atuin-search-mode.zsh"
    local bin
    bin="$(command -v atuin)" || return 0
    if [[ ! -e "$cache" || "$bin" -nt "$cache" ]]; then
      [[ -d "$cachedir" ]] || mkdir -p "$cachedir"
      autoload -Uz is-at-least
      local ver=${${(z)"$(atuin --version 2>/dev/null)"}[2]}
      if is-at-least 18.13.0 "${ver:-0}"; then
        print 'export ATUIN_SEARCH_MODE=daemon-fuzzy' > "$cache"
      else
        print -r -- "print -u2 \"⚠ atuin ${ver:-?} < 18.13 — Ctrl+R lent (cold-start). Mets à jour : brew upgrade atuin\"" > "$cache"
      fi
    fi
    source "$cache"
  }

  zvm_after_init() {
    # Fallback Ctrl+R : si l'init atuin échoue (absent / cassé / version incompatible),
    # afficher un message utile au lieu d'un "no such widget" muet. En cas de succès,
    # l'init atuin réenregistre ce widget (zle -N _atuin_search_widget _atuin_search).
    _atuin_fallback_widget() {
      zle -M "⚠ atuin indisponible (init en échec) — vérifie / mets à jour : brew upgrade atuin"
    }
    zle -N _atuin_search_widget _atuin_fallback_widget

    eval "$(atuin init zsh --disable-up-arrow)"
  }
fi

# ZPROF profiling output (PROD-001)
if [[ "$ZPROF" = 1 ]]; then
  zprof
fi