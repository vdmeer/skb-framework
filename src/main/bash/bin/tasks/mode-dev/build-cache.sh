#!/usr/bin/env bash

#-------------------------------------------------------------------------------
# ============LICENSE_START=======================================================
#  Copyright (C) 2018 Sven van der Meer. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# SPDX-License-Identifier: Apache-2.0
# ============LICENSE_END=========================================================
#-------------------------------------------------------------------------------

##
## build-cache - builds cache for maps and screens
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.3
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##

## put bugs into errors, safer
set -o errexit -o pipefail -o noclobber -o nounset

## we want files recursivey
shopt -s globstar



##
## Test if we are run from parent with configuration
## - load configuration
##
if [[ -z ${FW_HOME:-} || -z ${FW_L1_CONFIG-} ]]; then
    printf " ==> please run from framework or application\n\n"
    exit 50
fi
source $FW_L1_CONFIG
CONFIG_MAP["RUNNING_IN"]="task"


##
## load main functions
## - reset errors and warnings
##
source $FW_HOME/bin/api/_include
source $FW_HOME/bin/api/describe/_include
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
DO_BUILD=false
DO_CLEAN=false
DO_ALL=false
DO_DECL=false
DO_TAB=false
DO_FULL=false
TARGET=""



##
## set CLI options and parse CLI
##
CLI_OPTIONS=Abcdfht
CLI_LONG_OPTIONS=all,build,clean,decl,full,help,tab
CLI_LONG_OPTIONS+=,cmd-decl,cmd-tab
CLI_LONG_OPTIONS+=,dep-decl,dep-tab
CLI_LONG_OPTIONS+=,es-decl,es-tab
CLI_LONG_OPTIONS+=,opt-decl,opt-tab
CLI_LONG_OPTIONS+=,param-tab
CLI_LONG_OPTIONS+=,task-decl,task-tab
CLI_LONG_OPTIONS+=,tasks

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name build-cache -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "build-cache: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -b | --build)
            shift
            DO_BUILD=true
            ;;
        -c | --clean)
            DO_CLEAN=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "build-cache")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine b build   "<none>"    "builds cache, requires a target"                   $PRINT_PADDING
                BuildTaskHelpLine c clean   "<none>"    "removes all cached maps and screens"               $PRINT_PADDING
                BuildTaskHelpLine h help    "<none>"    "print help screen and exit"                        $PRINT_PADDING

                printf "\n   target options\n"
                BuildTaskHelpLine A all     "<none>"    "set all targets, except tasks"                         $PRINT_PADDING
                BuildTaskHelpLine d decl    "<none>"    "set all declaration targets"                           $PRINT_PADDING
                BuildTaskHelpLine f full    "<none>"    "set all targets, including tasks"                      $PRINT_PADDING
                BuildTaskHelpLine t tab     "<none>"    "set all table targets"                                 $PRINT_PADDING

                printf "\n   targets\n"
                BuildTaskHelpLine "<none>" cmd-decl     "<none>"    "target: command declarations"              $PRINT_PADDING
                BuildTaskHelpLine "<none>" cmd-tab      "<none>"    "target: command table"                     $PRINT_PADDING

                BuildTaskHelpLine "<none>" es-decl      "<none>"    "target: exit-status declarations"          $PRINT_PADDING
                BuildTaskHelpLine "<none>" es-tab       "<none>"    "target: exit-status table"                 $PRINT_PADDING

                BuildTaskHelpLine "<none>" opt-decl     "<none>"    "target: option declarations"               $PRINT_PADDING
                BuildTaskHelpLine "<none>" opt-tab      "<none>"    "target: option table"                      $PRINT_PADDING

                BuildTaskHelpLine "<none>" dep-decl     "<none>"    "target: dependency declarations"           $PRINT_PADDING
                BuildTaskHelpLine "<none>" dep-tab      "<none>"    "target: dependency table"                  $PRINT_PADDING

                BuildTaskHelpLine "<none>" param-tab    "<none>"    "target: parameter table"                   $PRINT_PADDING

                BuildTaskHelpLine "<none>" task-decl    "<none>"    "target: task declarations"                 $PRINT_PADDING
                BuildTaskHelpLine "<none>" task-tab     "<none>"    "target: task table"                        $PRINT_PADDING

                BuildTaskHelpLine "<none>" tasks        "<none>"    "target: help screens for all(!) tasks"     $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -A | --all)
            shift
            DO_ALL=true
            ;;
        -d | --decl)
            shift
            DO_DECL=true
            ;;
        -f | --full)
            shift
            DO_FULL=true
            ;;
        -t | --tab)
            shift
            DO_TAB=true
            ;;

        --cmd-decl)
            shift
            TARGET=$TARGET" cmd-decl"
            ;;
        --cmd-tab)
            shift
            TARGET=$TARGET" cmd-tab"
            ;;

        --es-decl)
            shift
            TARGET=$TARGET" es-decl"
            ;;
        --es-tab)
            shift
            TARGET=$TARGET" es-tab"
            ;;

        --opt-decl)
            shift
            TARGET=$TARGET" opt-decl"
            ;;
        --opt-tab)
            shift
            TARGET=$TARGET" opt-tab"
            ;;

        --dep-decl)
            shift
            TARGET=$TARGET" dep-decl"
            ;;
        --dep-tab)
            shift
            TARGET=$TARGET" dep-tab"
            ;;

        --param-tab)
            shift
            TARGET=$TARGET" param-tab"
            ;;

        --task-decl)
            shift
            TARGET=$TARGET" task-decl"
            ;;
        --task-tab)
            shift
            TARGET=$TARGET" task-tab"
            ;;

        --tasks)
            shift
            TARGET=$TARGET" tasks"
            ;;


        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "build-cache: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI and settings
############################################################################################

if [[ $DO_DECL == true ]]; then
    TARGET="cmd-decl dep-decl es-decl opt-decl task-decl"
fi
if [[ $DO_TAB == true ]]; then
    TARGET="cmd-tab dep-tab es-tab opt-tab param-tab task-tab"
fi
if [[ $DO_ALL == true ]]; then
    TARGET="cmd-decl cmd-tab dep-decl dep-tab es-decl es-tab opt-decl opt-tab param-tab task-decl task-tab"
fi
if [[ $DO_FULL == true ]]; then
    TARGET="cmd-decl cmd-tab dep-decl dep-tab es-decl es-tab opt-decl opt-tab param-tab task-decl task-tab tasks"
fi
if [[ $DO_BUILD == true ]]; then
    if [[ ! -n "$TARGET" ]]; then
        ConsoleError " ->" "build required, but no target set"
        exit 60
    fi
fi



############################################################################################
##
## ready to go
##
############################################################################################
ConsoleInfo "  -->" "bdc: starting task"
ConsoleResetErrors


PRINT_MODES="ansi text"

if [[ $DO_CLEAN == true ]]; then
    if [[ -d ${CONFIG_MAP["CACHE_DIR"]} ]]; then
        for file in ${CONFIG_MAP["CACHE_DIR"]}/**; do
            if [[ -f $file ]]; then
                rm $file
            fi
        done
    fi
    if [[ -d ${CONFIG_MAP["CACHE_DIR"]}/tasks ]]; then
        rm -r ${CONFIG_MAP["CACHE_DIR"]}/tasks
    fi
fi

if [[ $DO_BUILD == true ]]; then
    ConsoleInfo "  -->" "build for target(s): $TARGET"

    if [[ ! -d "${CONFIG_MAP["CACHE_DIR"]}" ]]; then
        mkdir -p ${CONFIG_MAP["CACHE_DIR"]}
    fi
    if [[ ! -d "${CONFIG_MAP["CACHE_DIR"]}" ]]; then
        ConsoleError " ->" "bdc: cache directory ${CONFIG_MAP["CACHE_DIR"]} does not exist"
    else
        for TODO in $TARGET; do
            ConsoleDebug "target: $TODO"
            case $TODO in
                cmd-decl)
                    FILE=${CONFIG_MAP["CACHE_DIR"]}/cmd-decl.map
                    if [[ -f $FILE ]]; then
                        rm $FILE
                    fi
                    declare -p DMAP_CMD > $FILE
                    declare -p DMAP_CMD_SHORT >> $FILE
                    declare -p DMAP_CMD_ARG >> $FILE
                    declare -p DMAP_CMD_DESCR >> $FILE
                    ;;
                cmd-tab)
                    for MODE in $PRINT_MODES; do
                        FILE=${CONFIG_MAP["CACHE_DIR"]}/cmd-tab.$MODE
                        if [[ -f $FILE ]]; then
                            rm $FILE
                        fi
                        declare -A COMMAND_TABLE
                        for ID in ${!DMAP_CMD[@]}; do
                            COMMAND_TABLE[$ID]=$(CommandInTable $ID $MODE)
                        done
                        declare -p COMMAND_TABLE > $FILE
                    done
                    ;;

                es-decl)
                    FILE=${CONFIG_MAP["CACHE_DIR"]}/es-decl.map
                    if [[ -f $FILE ]]; then
                        rm $FILE
                    fi
                    declare -p DMAP_ES > $FILE
                    declare -p DMAP_ES_PROBLEM >> $FILE
                    declare -p DMAP_ES_DESCR >> $FILE
                    ;;
                es-tab)
                    for MODE in $PRINT_MODES; do
                        FILE=${CONFIG_MAP["CACHE_DIR"]}/es-tab.$MODE
                        if [[ -f $FILE ]]; then
                            rm $FILE
                        fi
                        declare -A ES_TABLE
                        for ID in ${!DMAP_ES[@]}; do
                            ES_TABLE[$ID]=$(ExitstatusInTable $ID $MODE)
                        done
                        declare -p ES_TABLE > $FILE
                    done
                    ;;

                opt-decl)
                    FILE=${CONFIG_MAP["CACHE_DIR"]}/opt-decl.map
                    if [[ -f $FILE ]]; then
                        rm $FILE
                    fi
                    declare -p DMAP_OPT_ORIGIN > $FILE
                    declare -p DMAP_OPT_SHORT >> $FILE
                    declare -p DMAP_OPT_ARG >> $FILE
                    declare -p DMAP_OPT_DESCR >> $FILE
                    ;;
                opt-tab)
                    for MODE in $PRINT_MODES; do
                        FILE=${CONFIG_MAP["CACHE_DIR"]}/opt-tab.$MODE
                        if [[ -f $FILE ]]; then
                            rm $FILE
                        fi
                        declare -A OPTION_TABLE
                        for ID in ${!DMAP_OPT_ORIGIN[@]}; do
                            OPTION_TABLE[$ID]=$(OptionInTable $ID $MODE)
                        done
                        declare -p OPTION_TABLE > $FILE
                    done
                    ;;

                dep-decl)
                    FILE=${CONFIG_MAP["CACHE_DIR"]}/dep-decl.map
                    if [[ -f $FILE ]]; then
                        rm $FILE
                    fi
                    declare -p DMAP_DEP_ORIGIN > $FILE
                    declare -p DMAP_DEP_DECL >> $FILE
                    declare -p DMAP_DEP_REQ_DEP >> $FILE
                    declare -p DMAP_DEP_CMD >> $FILE
                    declare -p DMAP_DEP_DESCR >> $FILE
                    ;;
                dep-tab)
                    for MODE in $PRINT_MODES; do
                        FILE=${CONFIG_MAP["CACHE_DIR"]}/dep-tab.$MODE
                        if [[ -f $FILE ]]; then
                            rm $FILE
                        fi
                        declare -A DEP_TABLE
                        for ID in ${!DMAP_DEP_ORIGIN[@]}; do
                            DEP_TABLE[$ID]=$(DependencyInTable $ID $MODE)
                        done
                        declare -p DEP_TABLE > $FILE
                    done
                    ;;

                param-tab)
                    for MODE in $PRINT_MODES; do
                        FILE=${CONFIG_MAP["CACHE_DIR"]}/param-tab.$MODE
                        if [[ -f $FILE ]]; then
                            rm $FILE
                        fi
                        declare -A PARAM_TABLE
                        for ID in ${!DMAP_PARAM_ORIGIN[@]}; do
                            PARAM_TABLE[$ID]=$(ParameterInTable $ID $MODE)
                        done
                        declare -p PARAM_TABLE > $FILE
                    done
                    ;;

                task-decl)
                    FILE=${CONFIG_MAP["CACHE_DIR"]}/task-decl.map
                    if [[ -f $FILE ]]; then
                        rm $FILE
                    fi
                    declare -p DMAP_TASK_ORIGIN > $FILE
                    declare -p DMAP_TASK_DECL >> $FILE
                    declare -p DMAP_TASK_EXEC >> $FILE
                    declare -p DMAP_TASK_MODES >> $FILE
                    declare -p DMAP_TASK_SHORT >> $FILE
                    declare -p DMAP_TASK_DESCR >> $FILE

                    declare -p DMAP_TASK_REQ_PARAM_MAN >> $FILE
                    declare -p DMAP_TASK_REQ_PARAM_OPT >> $FILE
                    declare -p DMAP_TASK_REQ_DEP_MAN >> $FILE
                    declare -p DMAP_TASK_REQ_DEP_OPT >> $FILE
                    declare -p DMAP_TASK_REQ_TASK_MAN >> $FILE
                    declare -p DMAP_TASK_REQ_TASK_OPT >> $FILE
                    declare -p DMAP_TASK_REQ_DIR_MAN >> $FILE
                    declare -p DMAP_TASK_REQ_DIR_OPT >> $FILE
                    declare -p DMAP_TASK_REQ_FILE_MAN >> $FILE
                    declare -p DMAP_TASK_REQ_FILE_OPT >> $FILE
                    ;;
                task-tab)
                    for MODE in $PRINT_MODES; do
                        FILE=${CONFIG_MAP["CACHE_DIR"]}/task-tab.$MODE
                        if [[ -f $FILE ]]; then
                            rm $FILE
                        fi
                        declare -A TASK_TABLE
                        for ID in ${!DMAP_TASK_ORIGIN[@]}; do
                            TASK_TABLE[$ID]=$(TaskInTable $ID $MODE)
                        done
                        declare -p TASK_TABLE > $FILE
                    done
                    ;;

                tasks)
                    if [[ ! -d ${CONFIG_MAP["CACHE_DIR"]}/tasks ]]; then
                        mkdir ${CONFIG_MAP["CACHE_DIR"]}/tasks
                    fi
                    REMPATH=${APP_PATH_MAP["TASK_DECL"]}    # needed for substitutions
                    TMP_FILE=$(mktemp)                      # need tmp file to avoid recursive -h in tasks
                    for ID in ${!DMAP_TASK_ORIGIN[@]}; do
                        TPATH=${DMAP_TASK_DECL[$ID]}
                        TPATH=${TPATH#*$REMPATH/}
                        TPATH=${TPATH%/*}
                        if [[ ! -d ${CONFIG_MAP["CACHE_DIR"]}/tasks/$TPATH ]]; then
                            mkdir ${CONFIG_MAP["CACHE_DIR"]}/tasks/$TPATH
                        fi
                        TMP_PRINT_MODE=${CONFIG_MAP["PRINT_MODE"]}
                        for MODE in $PRINT_MODES; do
                            CONFIG_MAP["PRINT_MODE"]=$MODE
                            FILE=${CONFIG_MAP["CACHE_DIR"]}/tasks/$TPATH/$ID.$MODE
                            ConsoleDebug "caching task $ID to $FILE"
                            if [[ -f $FILE ]]; then
                                rm $FILE
                            fi
                            rm $TMP_FILE
                            ${DMAP_TASK_EXEC[$ID]} -h > $TMP_FILE
                            cat $TMP_FILE > $FILE
                        done
                        CONFIG_MAP["PRINT_MODE"]=$TMP_PRINT_MODE
                    done
                    ;;

                *)
                    ConsoleError " ->" "bdc: unknown target $TODO"
            esac
            ConsoleDebug "done target - $TODO"
        done
    fi
    ConsoleInfo "  -->" "done build"
fi

ConsoleInfo "  -->" "bdc: done"
exit $TASK_ERRORS
