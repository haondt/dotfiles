haondt_prompt_leader() {
  if [[ $HAONDT_RETVAL -ne 0 ]]; then
     echo -n "%{%F{red}%}"
  else
     echo -n "%{%F{9}%}"
  fi

  echo -n " %{%B%}"

  if [[ "$(vi_mode_prompt_info)" == "N" ]]; then 
    echo -n ">"
  else
    echo -n "~"
  fi
  
  echo -n "%{%f%k%b%} "
}

haondt_virtual_env() {
  if [[ -n ${VIRTUAL_ENV} ]] || return
  echo -n " %{%F{yellow}%B%}~%{%f%k%b%}"
}

haondt_build_prompt() {
  HAONDT_RETVAL=$?
  echo -n "%{%B%F{6}%}%1c%{%b%f%}"
  echo -n "$(git_prompt_info)"
  echo -n "$(haondt_virtual_env)"
  haondt_prompt_leader
}
  
PROMPT='%{%f%k%}$(haondt_build_prompt)'
RPROMPT=""

ZSH_THEME_GIT_PROMPT_PREFIX=" %{%F{8}%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%)%{%f%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{0}%}*%{%F{8}%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
MODE_INDICATOR="N"
INSERT_MODE_INDICATOR="I"
