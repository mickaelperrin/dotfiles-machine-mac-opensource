HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
source $HOME/.zsh/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook
add-zsh-hook precmd histdb-update-outcome

# TODO: use percol completion with DB search
#export HISTDB_ISEARCH_THIS_HOST=0
#source $HOME/.zsh/zsh-histdb/histdb-interactive.zsh
#bindkey '^R' _histdb-isearch

histdb-fzf-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(histdb --host --sep 999 | tac | awk -F'999' '{print $5}' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf) )

  LBUFFER=$selected
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init

  return $ret
}

zle     -N   histdb-fzf-widget
bindkey '^R' histdb-fzf-widget