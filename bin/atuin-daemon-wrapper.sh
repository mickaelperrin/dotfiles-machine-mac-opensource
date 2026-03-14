#!/bin/bash
# Wrapper for atuin daemon - cleans stale socket before starting
# Solves "Address already in use" crash loop when socket is orphaned

SOCKET="${HOME}/.local/share/atuin/atuin.sock"

# Remove stale socket if no process is listening on it
if [ -S "$SOCKET" ]; then
  if ! lsof -U "$SOCKET" >/dev/null 2>&1; then
    rm -f "$SOCKET"
  fi
fi

exec /opt/homebrew/bin/atuin daemon
