HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
#source $HOME/.zsh/zsh-histdb/sqlite-history.zsh
#autoload -Uz add-zsh-hook

# TODO: use percol completion with DB search
#export HISTDB_ISEARCH_THIS_HOST=0
#source $HOME/.zsh/zsh-histdb/histdb-interactive.zsh
#bindkey '^R' _histdb-isearch

_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
}

#export ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here

_histd_query_history() {
  if [ "$1" = 'force' ] || [ ! -f ~/.hist_fzf ]; then
    histdb --host --sep @@@ | tac | awk -F'@@@' '!seen[$5]++ {print $5}' | tee ~/.hist_fzf
  else
    cat ~/.hist_fzf
  fi
}

histdb-fzf-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  local command='zsh -c ". ~/.zshrc;_histd_query_history force"'
  selected=(
    $(_histd_query_history |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index  --bind='ctrl-r:reload:$command' $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf
    )
  )

  LBUFFER=$selected
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init

  return $ret
}

zle     -N   histdb-fzf-widget
zle     -N   _histd_query_history
bindkey '^R' histdb-fzf-widget
