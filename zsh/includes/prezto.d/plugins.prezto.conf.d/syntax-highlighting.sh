#
# Syntax Highlighting
#

# Set syntax highlighters.
# By default, only the main highlighter is enabled.
 zstyle ':prezto:module:syntax-highlighting' highlighters \
   'main' \
   'brackets' \
   'pattern' \
   'line' \
   'cursor' \
   'root'

# Set syntax highlighting styles.
# zstyle ':prezto:module:syntax-highlighting' styles \
#   'builtin' 'bg=blue' \
#   'command' 'bg=blue' \
#   'function' 'bg=blue'

# Set syntax pattern styles.
 zstyle ':prezto:module:syntax-highlighting' pattern \
   'rm*-rf*' 'fg=white,bold,bg=red'