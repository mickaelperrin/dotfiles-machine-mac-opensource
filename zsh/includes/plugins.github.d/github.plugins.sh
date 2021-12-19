githubPlugins=(
  # cd with fuzzy search
  b4b4r07/enhancd

  # Blackbox subset of command to manage secrets in git
  stackexchange/blackbox

  # automatically sources .autoenv.zsh files, typically used in project root directories.
  Tarrasch/zsh-autoenv

  # Track terminal activity in wakatime
  wbingli/zsh-wakatime

  # posts desktop notifications when a command terminates
  marzocchi/zsh-notify

  # Colorization of various programs
  zpm-zsh/colors

  # Enable 256 colors (not sure if needed, TERM seems to be already in 256 colors)
  #chrissicool/zsh-256color

  # Highlight syntax in commands written in terminal
  zdharma/fast-syntax-highlighting

  # fast/unobtrusive autosuggestions
  # should be loaded *after* syntax-highlighting
  # should bbe loaded *after* history-substring-search
  #tarruda/zsh-autosuggestions # replaced by prezto

  # Synchronize ZLE clipboard buffer with system clipboard.
  kutsan/zsh-system-clipboard

  # Good-lookin' diffs. Actually… nah… The best-lookin' diffs.
  zdharma/zsh-diff-so-fancy

  # Improved zsh vim mode (bindkey -v) plugin
  #laurenkt/zsh-vimto

  # Support for opening vi file at line vi file:123
  #nviennot/zsh-vim-plugin

  # Auto switch create to virtual env
  MichaelAquilina/zsh-autoswitch-virtualenv

  # Fzf wrapper around git commands
  wfxr/forgit

  #Aliases for exa (ls replacement)
  DarrinTisdale/zsh-aliases-exa

  # auto-closes, deletes and skips over matching delimiters
  hlissner/zsh-autopair

  # Yarn completion
  g-plane/zsh-yarn-autocompletions

  # Docker completions
  greymd/docker-zsh-completion

)

if [[ "$(uname -m)" == "arm64" ]]; then
githubPlugins+=(
  # Show alias if use a command which is aliased
  djui/alias-tips
)
fi