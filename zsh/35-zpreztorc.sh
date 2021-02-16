if [ "$ZSH_PLUGIN_MANAGER" = "zinit" ];  then
  source $ZSH_CONFIG_PATH/zpreztorc.zinit.sh
else
  source $ZSH_CONFIG_PATH/zpreztorc.zgen.sh
fi