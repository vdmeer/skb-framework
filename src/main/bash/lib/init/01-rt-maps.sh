## settings for writing runtime configuration maps

declare -x FW_RUNTIME_MAPS_FAST=""    ## fast changing maps, such as settings, phases
declare -x FW_RUNTIME_MAPS_MEDIUM=""  ## medium changing maps, such as status and status comments
declare -x FW_RUNTIME_MAPS_SLOW=""    ## slow chaning maps, such as themes, theme items, messages
declare -x FW_RUNTIME_MAPS_LOAD=""    ## maps written only at load time, such as options and known theme items
