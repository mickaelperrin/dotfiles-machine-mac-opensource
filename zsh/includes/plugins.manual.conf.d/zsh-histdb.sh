HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
source $HOME/.zsh/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook
add-zsh-hook precmd histdb-update-outcome

# TODO: use percol completion with DB search
#source $HOME/.zsh/zsh-histdb/histdb-interactive.zsh
#bindkey '^r' _histdb-isearch