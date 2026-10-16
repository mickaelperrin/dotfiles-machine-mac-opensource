#!/usr/bin/env bash
# Wrapper for atuin daemon - cleans stale socket before starting
# Solves "Address already in use" crash loop when socket is orphaned
#
# Under launchd, PATH is /usr/bin:/bin:..., so env resolves to /bin/bash
# (3.2): keep this script free of Bash 4+ features (no inherit_errexit).
set -Eeuo pipefail

# Must match socket_path pinned in atuin config.toml (tiers 1 and 3) and
# MAC_ATUIN_SOCKET in the SwiftBar mac.config.sh (tier 3).
SOCKET="${HOME}/.local/share/atuin/atuin.sock"

# Remove stale socket if no process is listening on it
if [ -S "$SOCKET" ]; then
  if ! lsof -U "$SOCKET" >/dev/null 2>&1; then
    rm -f "$SOCKET"
  fi
fi

exec /opt/homebrew/bin/atuin daemon start
