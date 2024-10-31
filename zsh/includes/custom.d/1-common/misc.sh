setopt RM_STAR_WAIT # Wait 10 seconds before rm *
setopt interactivecomments # Allow comments with # in command line

ZBEEP='\e[?5h\e[?5l'

zstyle ':completion:*' menu select

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} "ma=48;5;244;38;5;255"

