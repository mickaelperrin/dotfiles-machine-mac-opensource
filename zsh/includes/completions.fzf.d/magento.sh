_magento_subcommands() {


}
_fzf_complete_magento() {
  local FNAME=$HOME/.cache/zsh/completion_magento_fzf

  [ ! -d $HOME/.cache/zsh ] && mkdir -p $HOME/.cache/zsh
  if [ ! -f $FNAME ]; then
    magento ni --raw --no-ansi list >! $FNAME
  fi
  _fzf_complete "--multi --reverse" "$@" < <( cat $FNAME )
}

_fzf_complete_magento_post() {
  awk '{print $1}'
}