# Mani completion - https://github.com/alajmo/mani
# Chargement dynamique de l'autocomplétion
if command -v mani &>/dev/null; then
  eval "$(mani completion zsh)"
fi
