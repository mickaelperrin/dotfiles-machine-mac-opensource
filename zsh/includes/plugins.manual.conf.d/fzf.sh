# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"


_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  # Comment and uncomment below for the light theme.

  # Solarized Dark color scheme for fzf
  #export FZF_DEFAULT_OPTS="
  #  --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
  #  --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  #"
  ## Solarized Light color scheme for fzf
  #export FZF_DEFAULT_OPTS="
  #  --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
  #  --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
  #"

  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=\"hl:#00FF00,fg+:#111111,bg+:#00FF00,hl+:#FF0000,info:#98c379,prompt:#83d267,pointer:#cc0000,marker:#000000,spinner:#61afef,header:#83d267\""
}
_gen_fzf_default_opts
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --no-sort --reverse --prompt='>> ' --inline-info --no-height --exact"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

if which fd > /dev/null; then
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
fi

# We need to use a global variable to share
# fzf completions results to traditionnal completion
export FZF_SUBCMDS=()

FZF_COMPLETIONS_DIR="$ZSH_CONFIG_PATH/completions.fzf.d"

if [ -d "$FZF_COMPLETIONS_DIR" ]; then
  find $FZF_COMPLETIONS_DIR -name '*.sh' -print0 | while IFS= read -r -d $'\0' file; do
    source "$file"
    done
fi

# Keep using percol for histopry search
#bindkey '^R' percol_select_history
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --reverse --prompt='>> ' --inline-info --exact"

# Trigger fzf completion
export FZF_COMPLETION_TRIGGER='@@'

#TODO: bindkey not working ?
bindkey '^O' fzf-completion
bindkey '^P' $fzf_default_completion