unset JAVA_TOOL_OPTIONS
unset COMMAND_PROMPT
function __prompt_command() {
    PS1="\nskb> "
}
export PROMPT_COMMAND=__prompt_command

alias exit="Terminate framework 0"
alias quit="Terminate framework 0"
alias bye="Terminate framework 0"

trap "rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"; exit" SIGHUP SIGQUIT SIGILL SIGTERM
trap "rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"; exit" SIGHUP SIGQUIT SIGILL SIGTERM
trap "rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"; exit" SIGHUP SIGQUIT SIGILL SIGTERM
trap "rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}"; exit" SIGHUP SIGQUIT SIGILL SIGTERM
trap 'printf " --> please use exit/quit/bye to terminate the skb\n"' SIGINT
