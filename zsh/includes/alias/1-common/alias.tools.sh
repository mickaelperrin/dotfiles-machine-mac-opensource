# Tools
alias dud='du -d 1 -h | sort -h'
alias duf='du -sh * | sort -h'
alias k9='kill -9'
#alias colorls='colorls --dark'
alias l='colorls'
alias ls='ls -G' #colorize ls
alias ldirs='l --dirs --almost-all'
alias lf='l --files --almost-all'
# Force use of rmtrash
alias del='trash -F'
alias rm="echo Use 'del', or the full path '/bin/rm'"