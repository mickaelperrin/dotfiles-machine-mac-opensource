#if exists peco; then
#  zle -N percol_select_history
#  bindkey '^R' percol_select_history
#fi