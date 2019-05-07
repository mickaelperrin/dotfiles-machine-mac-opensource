ZGEN_PATH="${HOME}/.zsh/zgen/zgen.zsh"
ZSH_CONFIG_PLUGINS_PATH="${ZSH_CONFIG_PATH}/plugins.zgen.conf.d"

source "$ZGEN_PATH"

githubPlugins=(
  # cd with fuzzy search
  b4b4r07/enhancd

  # Blackbox subset of command to manage secrets in git
  stackexchange/blackbox

  # automatically sources .autoenv.zsh files, typically used in project root directories.
  Tarrasch/zsh-autoenv

  # Track terminal activity in wakatime
  wbingli/zsh-wakatime

  # Show alias if use a command which is aliased
  djui/alias-tips

  # posts desktop notifications when a command terminates
  marzocchi/zsh-notify

  # Colorization of various programs
  zpm-zsh/colors

  # Enable 256 colors (not sure if needed, TERM seems to be already in 256 colors)
  #chrissicool/zsh-256color

  # Highlight syntax in commands written in terminal
  #zdharma/fast-syntax-highlighting # replaced by prezto

  # fast/unobtrusive autosuggestions
  # should be loaded *after* syntax-highlighting
  # should bbe loaded *after* history-substring-search
  #tarruda/zsh-autosuggestions # replaced by prezto

  # Synchronize ZLE clipboard buffer with system clipboard.
  kutsan/zsh-system-clipboard

  # Good-lookin' diffs. Actually… nah… The best-lookin' diffs.
  zdharma/zsh-diff-so-fancy

  # Improved zsh vim mode (bindkey -v) plugin
  laurenkt/zsh-vimto

  # Support for opening vi file at line vi file:123
  nviennot/zsh-vim-plugin

  # Auto switch create to virtual env
  MichaelAquilina/zsh-autoswitch-virtualenv

)

function sourcePluginConfigFile() {
  local configFilePath="${ZSH_CONFIG_PLUGINS_PATH}/$1.sh"
  if [ -f $configFilePath ];then
    source "$configFilePath"
  else
    $DEBUG && echo "  !!! Missing $configFilePath"
  fi
}

function loadGithubPlugins() {

 for plugin in "${githubPlugins[@]}"
  do
    $DEBUG && echo "Loading ZSH plugin: $plugin"
    pluginName=$(echo "$plugin" | cut -d'/' -f 2)
    [ "$1" = 'conf' ] && sourcePluginConfigFile "$pluginName"
    [ "$1" = 'plugin' ] && zgen load "$plugin"
  done
}

loadGithubPlugins conf

if zgen saved; then
  return
fi

$DEBUG && echo "Loading prezto"
zgen prezto
loadGithubPlugins plugin
zgen save


