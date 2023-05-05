#
# Prompt
#

# Set the prompt theme to load.
# Setting it to 'random' loads a random theme.
# Auto set to 'off' on dumb terminals.
zstyle ':prezto:module:prompt' theme 'powerlevel10k'

# Set the working directory prompt display length.
# By default, it is set to 'short'. Set it to 'long' (without '~' expansion)
# for longer or 'full' (with '~' expansion) for even longer prompt display.
zstyle ':prezto:module:prompt' pwd-length 'short'

# Set the prompt to display the return code along with an indicator for non-zero
# return codes. This is not supported by all prompts.
zstyle ':prezto:module:prompt' show-return-val 'yes'


export DEFAULT_USER=$(whoami)

function prompt_my_docker_host() {
  if [ ! -z "$(docker_context_show)" ] && [[ $(docker_context_show) != 'default' ]]; then
    p10k segment -f $POWERLEVEL9K_FG_DARK_BG_COLOR -b blue -i "🐳" -t $(docker_context_show)
  fi
}

function prompt_my_current_arch() {
  if [[ $(uname -m) != 'arm64' ]]; then
    p10k segment -f $POWERLEVEL9K_FG_DARK_BG_COLOR -b red -t $(uname -m)
  fi
}


function prompt_my_os_icon() {
  if [[ $(uname -m) != 'arm64' ]]; then
    p10k segment -f $POWERLEVEL9K_FG_COLOR -b red -t "x86_64"
  else
    p10k segment -f $POWERLEVEL9K_FG_COLOR -b $POWERLEVEL9K_BG_COLOR -t $(print_icon 'APPLE_ICON')
  fi
}

POWERLEVEL9K_BG_COLOR="none"
if [ "$ITERM_PROFILE" = "Light" ]; then
  POWERLEVEL9K_FG_COLOR="white"
  POWERLEVEL9K_FG_DARK_BG_COLOR="black"
else
  POWERLEVEL9K_FG_DARK_BG_COLOR="white"
  POWERLEVEL9K_FG_COLOR="249"
fi
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(my_os_icon context dir dir_writable virtualenv vcs my_docker_host )
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(icons_test)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time_joined)
#POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
#POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_DIR_HOME_BACKGROUND="$POWERLEVEL9K_BG_COLOR"
POWERLEVEL9K_DIR_HOME_FOREGROUND="$POWERLEVEL9K_FG_COLOR"
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$POWERLEVEL9K_BG_COLOR"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="red"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$POWERLEVEL9K_BG_COLOR"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$POWERLEVEL9K_FG_COLOR"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$POWERLEVEL9K_BG_COLOR"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$POWERLEVEL9K_FG_COLOR"
POWERLEVEL9K_STATUS_OK_BACKGROUND="$POWERLEVEL9K_BG_COLOR"
POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$POWERLEVEL9K_BG_COLOR"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
POWERLEVEL9K_TIME_BACKGROUND="$POWERLEVEL9K_BG_COLOR"
POWERLEVEL9K_TIME_FOREGROUND="$POWERLEVEL9K_FG_COLOR"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_HOME_ICON=''
#POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_VCS_GIT_ICON=''
#POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=
#POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$POWERLEVEL9K_BG_COLOR"
POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=" "
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_DIR_PACKAGE_FILES=(package.json composer.json)
POWERLEVEL9K_SHORTEN_FOLDER_MARKER='.autoenv.zsh'
POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR=''
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_with_folder_marker'
POWERLEVEL9K_RIGHT_SEGMENT_END_SEPARATOR=''