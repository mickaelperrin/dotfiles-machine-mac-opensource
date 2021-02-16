#
# macOS
#

# Set the keyword used by `mand` to open man pages in Dash.app
zstyle ':prezto:module:osx:man' dash-keyword 'man'

function mand {
  if (( $# > 0 )); then
    zstyle -s ':prezto:module:osx:man' dash-keyword 'dashkw' || dashkw='manpages'
    open "dash-plugin://keys=$dashkw&query=$1" 2> /dev/null
    if (( $? != 0 )); then
      print "$0: Dash is not installed" >&2
      break
    fi
  else
    print 'What manual page do you want?' >&2
  fi

  unset dashkw
}