## maps for data objects


##
## CONFIGURATION Maps - CFG
##
declare -A -g FW_OBJECT_CFG_LONG    ## [long]="description"
declare -A -g FW_OBJECT_CFG_VAL     ## [long]="value"

FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_CFG_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_CFG_LONG"


##
## FORMATS Maps - FMT
##
declare -A FW_OBJECT_FMT_LONG       ## [long]="description"
declare -A FW_OBJECT_FMT_PATH       ## [long]="path to description"

FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_FMT_LONG FW_OBJECT_FMT_PATH"


##
## LEVELS Maps - LVL
##
declare -A FW_OBJECT_LVL_LONG       ## [long]="description"
declare -A FW_OBJECT_LVL_PATH       ## [long]="path to description"
declare -A FW_OBJECT_LVL_CHAR_ABBR  ## [long]="char for abbbreviating level, e.g. in tables"
declare -A FW_OBJECT_LVL_STRING_THM ## [long]="theme string"

FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_LVL_LONG FW_OBJECT_LVL_PATH FW_OBJECT_LVL_CHAR_ABBR FW_OBJECT_LVL_STRING_THM"


##
## MESSAGES Maps - MSG
##
declare -A FW_OBJECT_MSG_LONG       ## [long]="description"
declare -A FW_OBJECT_MSG_TYPE       ## [long]="error | warning"]
declare -A FW_OBJECT_MSG_CAT        ## [long]="category
declare -A FW_OBJECT_MSG_ARGS       ## [long]="number of arguments"
declare -A FW_OBJECT_MSG_TEXT       ## [long]="text with arg replacement string"
declare -A FW_OBJECT_MSG_PATH       ## [long]="path to description"

FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_MSG_LONG FW_OBJECT_MSG_TYPE FW_OBJECT_MSG_CAT FW_OBJECT_MSG_ARGS FW_OBJECT_MSG_TEXT FW_OBJECT_MSG_PATH"


##
## MODES Maps - MOD
##
declare -A FW_OBJECT_MOD_LONG       ## [long]="description"
declare -A FW_OBJECT_MOD_PATH       ## [long]="path to description"

FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_MOD_LONG FW_OBJECT_MOD_PATH"


##
## PHASES Maps - PHA
##
declare -A FW_OBJECT_PHA_LONG       ## [long]="description"
declare -A FW_OBJECT_PHA_PRT_LVL    ## [long]=" print levels "
declare -A FW_OBJECT_PHA_LOG_LVL    ## [long]=" log levels "
declare -A FW_OBJECT_PHA_ERRCNT     ## [long]="error count, integer"
declare -A FW_OBJECT_PHA_WRNCNT     ## [long]="warning count, integer"
declare -A FW_OBJECT_PHA_ERRCOD     ## [long]="list of recorded error codes"
declare -A FW_OBJECT_PHA_PATH       ## [long]="path to description"

FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_PHA_PRT_LVL FW_OBJECT_PHA_LOG_LVL FW_OBJECT_PHA_ERRCNT FW_OBJECT_PHA_WRNCNT FW_OBJECT_PHA_ERRCOD"
FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_PHA_LONG FW_OBJECT_PHA_PATH"


##
## SETTINGS Maps - SET
##
declare -A FW_OBJECT_SET_LONG       ## [long]="description"
declare -A FW_OBJECT_SET_PHA        ## [long]="phase that did set the value"
declare -A FW_OBJECT_SET_VAL        ## [long]="the value"

FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_SET_PHA FW_OBJECT_SET_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_SET_LONG"


##
## THEME Maps - THM
##
declare -A FW_OBJECT_THM_LONG       ## [long]=description
declare -A FW_OBJECT_THM_PATH       ## [long]=path

FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_THM_LONG FW_OBJECT_THM_PATH"


##
## THEMEITEM Maps - TIM
##
declare -A FW_OBJECT_TIM_LONG       ## [long]=description
declare -A FW_OBJECT_TIM_SOURCE     ## [long]=source of setting, theme long
declare -A FW_OBJECT_TIM_VAL        ## [long]=value, item settings

FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_TIM_SOURCE FW_OBJECT_TIM_VAL"
FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_TIM_LONG"

