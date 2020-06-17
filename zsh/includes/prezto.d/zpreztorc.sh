#
# Sets Prezto options.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
#
# General
#
# The order matters.
preztoPlugins=(
  # Sets general shell options and defines environment variables.
  'environment'

  # Provides for easier use of 256 colors and effects.
  'spectrum'

  # Sets terminal window and tab titles.
  'terminal'

  # Sets key bindings.
  'editor'

  # Sets directory options and defines directory aliases.
  'directory'

  # Sets history options and defines history aliases.
  'history'

  # Defines general aliases and functions.
  'utility'

  # Loads and configures tab completion and provides additional completions from the zsh-completions project.
  # Must be loaded *after* the utility module
  'completion'

  # When you try to use a command that is not available locally, searches the package manager for a package offering that command and suggests the proper install command.
  #'command-not-found' # deactivated too slow

  # Enhances the Git distributed version control system by providing aliases, functions and by exposing repository status information to prompts.
  'git'

  # Defines Docker aliases and functions.
  'docker'

  # Defines macOS aliases and functions.
  'osx'

  # Provides for an easier use of GPG by setting up gpg-agent.
  'gpg'

  # Provides for an easier use of SSH by setting up ssh-agent.
  'ssh'

  # Customize prompt
  'prompt'

  # Integrates zsh-syntax-highlighting into Prezto.
  'fast-syntax-highlighting'

  # Integrates zsh-history-substring-search into Prezto, which implements the Fish shell's history search feature, where the user can type in any part of a previously entered command and press up and down to cycle through matching commands.
  # Should be loaded *after* 'syntax-highlighting'
  #'history-substring-search'

  # fast/unobtrusive autosuggestions
  # should be loaded *after* syntax-highlighting
  # should bbe loaded *after* history-substring-search
  'autosuggestions' # can be replaced by zgen tarruda/zsh-autosuggestions
)

ZSH_CONFIG_PREZTO_PLUGINS_PATH="${ZSH_CONFIG_PATH}/prezto.d/plugins.prezto.conf.d"

function sourcePluginConfigFile() {
  local configFilePath="${ZSH_CONFIG_PREZTO_PLUGINS_PATH}/$1$2.sh"
  if [ -f $configFilePath ]; then
    source "$configFilePath"
  else
    # Do not throw warning for config overrides
    if [ -z $2 ]; then
      $DEBUG && echo "  !!! Missing configuration file for prezto plugin $1..."
      $DEBUG && echo "$configFilePath not found"
    fi
  fi
}

function loadPreztoPlugins() {
  for plugin in "${preztoPlugins[@]}"
  do
    $DEBUG && echo "Loading prezto plugin: $plugin"
    sourcePluginConfigFile "$plugin"
    pmodload "$plugin"
    sourcePluginConfigFile "$plugin" '.override'
  done
  # Prevent that modules get loaded twice
  zstyle ':prezto:load' pmodule
}

# Set case-sensitivity for completion, history lookup, etc.
zstyle ':prezto:*:*' case-sensitive 'no'

# Color output (auto set to 'no' on dumb terminals).
zstyle ':prezto:*:*' color 'yes'

# Add additional directories to load prezto modules from
zstyle ':prezto:load' pmodule-dirs ${ZSH_CONFIG_PATH}/prezto.d/plugins.prezto.custom.d

# Set the Zsh modules to load (man zshmodules).
#zstyle ':prezto:load' zmodule 'attr'

# Set the Zsh functions to load (man zshcontrib).
zstyle ':prezto:load' zfunction 'zargs' 'zmv'

loadPreztoPlugins

