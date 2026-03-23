# p10k.docker-status.sh
# Custom powerlevel10k segment that replaces the Apple os_icon with a Docker
# whale when PHP_IN_DOCKER=1, showing container health via background color.
#
# States:
#   UP      - all containers running  -> light background (same as os_icon)
#   PARTIAL - some containers running -> orange background
#   DOWN    - no containers running   -> red background
#
# Performance: results cached in $TMPDIR/.p10k-docker-<project> with a 10s TTL.
# Stale cache is served immediately while a background refresh runs asynchronously.

# Compute Docker container state by querying the daemon.
# Prints: UP | PARTIAL | DOWN
# Returns non-zero on Docker error.
function _p10k_docker_compute_state() {
  local ps_output line total=0 running=0

  # Single docker ps call to get all containers (running + stopped) for this project
  ps_output=$(command docker ps -a \
    --filter "name=^${PROJECT_NAME_SANITISED}-" \
    --format '{{.Status}}' 2>/dev/null) || return 1

  while IFS= read -r line; do
    (( total++ ))
    [[ "$line" == Up* ]] && (( running++ ))
  done <<< "$ps_output"

  if (( total == 0 )); then
    print 'DOWN'
  elif (( running == total )); then
    print 'UP'
  elif (( running > 0 )); then
    print 'PARTIAL'
  else
    print 'DOWN'
  fi
}

# Write state to cache file atomically to avoid race conditions between sessions.
function _p10k_docker_write_cache() {
  local cache_file="$1" state="$2"
  print "$state" > "${cache_file}.tmp" && command mv "${cache_file}.tmp" "$cache_file"
}

# Powerlevel10k custom segment: docker_status
# Called on every prompt render by p10k.
function prompt_docker_status() {
  # Non-Docker project or missing project name: fall back to Apple icon
  if [[ "${PHP_IN_DOCKER}" != '1' ]] || [[ -z "${PROJECT_NAME_SANITISED}" ]]; then
    p10k segment -b 7 -f 232 -i $'\uF179'
    return
  fi

  # Docker not available on this machine: graceful degradation to Apple icon
  if (( ! $+commands[docker] )); then
    p10k segment -b 7 -f 232 -i $'\uF179'
    return
  fi

  local cache_file="${TMPDIR:-/tmp}/.p10k-docker-${PROJECT_NAME_SANITISED}"
  local state=''

  if [[ -f "$cache_file" ]]; then
    local cache_mtime cache_age
    cache_mtime=$(command stat -f %m "$cache_file" 2>/dev/null) || cache_mtime=0
    cache_age=$(( EPOCHSECONDS - cache_mtime ))

    if (( cache_age < 10 )); then
      # Cache is fresh: use it directly
      state=$(<"$cache_file")
    else
      # Cache is stale: serve stale value immediately, refresh in background
      state=$(<"$cache_file")
      {
        local new_state
        new_state=$(_p10k_docker_compute_state) \
          && _p10k_docker_write_cache "$cache_file" "$new_state"
      } &!
    fi
  fi

  if [[ -z "$state" ]]; then
    # No cache yet: compute synchronously (first run in a new project)
    state=$(_p10k_docker_compute_state) || state='DOWN'
    _p10k_docker_write_cache "$cache_file" "$state"
  fi

  local bg fg
  case "$state" in
    UP)      bg=7;   fg=232 ;;
    PARTIAL) bg=208; fg=232 ;;
    *)       bg=196; fg=255 ;;   # DOWN or unknown
  esac

  p10k segment -b $bg -f $fg -i $'\uF308'
}

# Replace os_icon with docker_status in the left prompt elements.
# Guard: only execute if os_icon is present (prevents double-execution on re-source).
if [[ -v POWERLEVEL9K_LEFT_PROMPT_ELEMENTS ]] \
  && (( ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[(Ie)os_icon]} )); then
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]/os_icon/docker_status}"
  )
  # Reload p10k so it picks up the new segment and styling variables
  (( $+functions[p10k] )) && p10k reload
fi
