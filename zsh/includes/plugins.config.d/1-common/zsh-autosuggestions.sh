# Style mono-attribut UNIQUEMENT (pas de ,italic / ,bold...). Un style multi-attributs
# est réémis sous une forme non canonique pendant le cycle de re-highlight, si bien que
# _zsh_autosuggest_highlight_reset (purge par égalité de chaîne exacte sur
# _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT) ne retrouve plus l'entrée region_highlight : le texte
# accepté d'une suggestion reste alors gris au lieu d'être recoloré.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
