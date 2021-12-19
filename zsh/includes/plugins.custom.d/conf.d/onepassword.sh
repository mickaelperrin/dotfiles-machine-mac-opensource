#!/usr/bin/env bash
# This file is intended to be included in your .bashrc

alias oplogin='eval $(opsign.sh in)'
alias oplogout='eval $(opsign.sh out)'
if [[ "$(uname -m)" == "arm64" ]]; then
  alias op-tools='arch -x86_64 /usr/local/bin/op-tools'
  alias op-local='arch -x86_64 /usr/local/bin/op-local'
fi

alias assh='op-tools ssh-add'
alias opmapping="op-local list --format=\"{uuid}|{UUID}|{LASTPASS_ID}|{title}\" | column -t -s'|' | peco"
alias opl='op-local'
alias opled:='vi ~/.onepassword-tools.yml'
alias opup='eval $(opsign.sh update)'

eval $(opsign.sh update)