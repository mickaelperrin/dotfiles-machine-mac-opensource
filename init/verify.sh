#!/usr/bin/env bash
# Post-install assertions for tier 1.
# Dotbot reports a failed link as a warning and keeps going, so an unmet
# post-condition scrolls past unnoticed — this turns it into a visible failure.
# Deliberately free of Bash 4+ features: dotbot may invoke it under macOS' 3.2.
set -Eeuo pipefail

trap 'echo "Error at line $LINENO: $BASH_COMMAND" >&2' ERR

FAILURES=0

if [ -t 1 ]; then
  OK_MARK=$'\033[32m✓\033[0m'
  KO_MARK=$'\033[31m✗\033[0m'
else
  OK_MARK='✓'
  KO_MARK='✗'
fi

# check LABEL COMMAND [ARG...] — runs COMMAND silently, reports, counts failures.
check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf '  %s %s\n' "$OK_MARK" "$label"
  else
    printf '  %s %s\n' "$KO_MARK" "$label"
    FAILURES=$((FAILURES + 1))
  fi
}

printf '\n\n===================================================================\n'
printf 'Vérification des post-conditions\n'
printf '===================================================================\n\n'

check "atuin installé" command -v atuin
check "LaunchAgent atuin lié" test -L "$HOME/Library/LaunchAgents/com.atuin.daemon.plist"
check "daemon atuin chargé" launchctl print "gui/$(id -u)/com.atuin.daemon"
check "includes zsh liés" test -L "$HOME/.zsh/includes"

printf '\n'

if [ "$FAILURES" -ne 0 ]; then
  printf '%d post-condition(s) non satisfaite(s) — corrigez avant de considérer\n' "$FAILURES" >&2
  printf "l'installation du tier 1 comme terminée.\n" >&2
  exit 1
fi

printf 'Toutes les post-conditions sont satisfaites.\n'
