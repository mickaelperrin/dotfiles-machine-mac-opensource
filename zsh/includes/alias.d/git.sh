alias gpo='git push origin --all'
alias gcs='git checkout staging'
alias gpom='git push origin master'
alias gpod='git push origin develop'
alias gpos='git push origin staging'
alias gstr='find . -type d -name .git -exec echo \; -exec echo \; -exec echo {} \; -exec echo "################################" \; -exec bash -c " git -c color.status=always --git-dir={} --work-tree=\$(dirname "{}") status" \; | less -REX'
alias gpor='find . -type d -name .git -exec echo \; -exec echo \; -exec echo {} \; -exec echo "################################" \; -exec bash -c " git -c color.status=always --git-dir={} --work-tree=\$(dirname "{}") push origin --all" \; | less -REX'
alias kraken="open -na 'GitKraken' --args -p \$(pwd)"