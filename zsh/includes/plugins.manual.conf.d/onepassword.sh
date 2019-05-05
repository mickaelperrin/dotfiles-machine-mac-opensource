#!/usr/bin/env bash
# This file is intended to be included in your .bashrc

. "${HOME}/.bin.base/opsign.sh"
eval $(get1PasswordSession)

alias oplogin='eval $(opsign.sh in)'
alias oplogout='eval $(opsign.sh out)'
alias assh='op-tools ssh-add'
alias opmapping="op-local list --format=\"{uuid}|{UUID}|{LASTPASS_ID}|{title}\" | column -t -s'|' | peco"
alias opl='op-local'
alias opled:='vi ~/.onepassword-tools.yml'
