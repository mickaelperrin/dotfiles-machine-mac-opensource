#!/usr/local/bin/zsh
DEBUG=false
INSTALL=false
PERF=false

export ZSH_CONFIG_PATH=~/.zsh/includes

# Add profiling capabilities to source command
if $PERF || $DEBUG; then

  if $PERF; then
    PERF_FILE_PATH=~/zsh.perf.log
    PERF_START=$(gdate +%s.%N)
    PERF_TOTAL_TIME=0
    PERF_LAST=0
    echo "Time :: Sourced file :: Source time :: Diff time" > "$PERF_FILE_PATH"
    zmodload zsh/zprof
  fi

  function source() {
    local file=$1
    $PERF && local start=$(gdate +%s.%N)

    $DEBUG && echo "Sourcing $file..."
    if $DEBUG; then
      if [ ! -e "$file" ]; then
        echo "!!! Missing file $file"
      fi
    fi
    builtin source "$file"
    if $PERF; then
      local end=$(gdate +%s.%N)
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
    find $dir -name '*.sh' -print0 | while IFS= read -r -d $'\0' file; do
      source "$file"
    done
  fi
}


$INSTALL && loadIfExists requirements

loadIfExists env
loadIfExists functions
loadIfExists zgen
loadIfExists plugins.manual.conf
loadIfExists zsh.conf
loadIfExists alias

$PERF && displayPerfResults