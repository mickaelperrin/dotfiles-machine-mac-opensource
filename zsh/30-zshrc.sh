#!/opt/homebrew/bin/zsh
DEBUG=false
INSTALL=false
PERF=false
GDATE=/opt/homebrew/bin/gdate

if $PERF; then
  module_path+=( "$HOME/.zinit/bin/zmodules/Src" )
  zmodload zdharma/zplugin
fi

export ZSH_CONFIG_PATH="${HOME}/.zsh/includes"
export ZSH_GITHUB_PLUGINS_PATH="${ZSH_CONFIG_PATH}/plugins.github.d"

# Add profiling capabilities to source command
if $PERF || $DEBUG; then

  if $PERF; then
    PERF_FILE_PATH=~/zsh.perf.log
    PERF_START=$($GDATE +%s.%N)
    PERF_TOTAL_TIME=0
    PERF_LAST=0
    echo "Time :: Sourced file :: Source time :: Diff time" > "$PERF_FILE_PATH"
    zmodload zsh/zprof
  fi

  function source() {
    local file=$1
    $PERF && local start=$($GDATE +%s.%N)

    $DEBUG && echo "Sourcing $file..."
    if $DEBUG; then
      if [ ! -e "$file" ]; then
        echo "!!! Missing file $file"
      fi
    fi
    builtin source "$file"
    if $PERF; then
      local end=$($GDATE +%s.%N)
      echo "$((end-PERF_START)) :: $file :: $((end-start)) :: $((end-PERF_START-PERF_LAST)) " >> "$PERF_FILE_PATH"
      PERF_LAST=$((end-PERF_START))
    fi
  }

  function displayPerfResults() {
    if ! $PERF; then
      return
    fi

    zprof >> "$PERF_FILE_PATH"

    cat "$PERF_FILE_PATH" | column -t -s "::" | peco
}
fi

function loadIfExists() {
  local file="${ZSH_CONFIG_PATH}/$1.sh"
  local dir="${ZSH_CONFIG_PATH}/$1.d"

  if [ -e $file ]; then
    source "$file"
  fi

  if [ -d "$dir" ]; then
    find $dir/ -name '*.sh' -print0 | while IFS= read -r -d $'\0' file; do
      source "$file"
    done
  fi

  # First extend / override of a shared config
  if [ -d "$dir/shared" ]; then
    find $dir/shared/ -name '*.sh' -print0 | while IFS= read -r -d $'\0' file; do
      source "$file"
    done
  fi

  # Second extend / override for own config
  if [ -d "$dir/custom" ]; then
    find $dir/custom/ -name '*.sh' -print0 | while IFS= read -r -d $'\0' file; do
      source "$file"
    done
  fi
}


$INSTALL && loadIfExists requirements || true

loadIfExists env
loadIfExists functions
loadIfExists zinit #change plugin manager here zinit or zgen
loadIfExists plugins.custom
loadIfExists zsh.conf
loadIfExists alias

$PERF && displayPerfResults || true
