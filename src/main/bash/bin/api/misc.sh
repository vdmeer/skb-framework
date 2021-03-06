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
## Miscellaneous functions.
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## function: Counters()
## - manages counters
## $1: action: get, reset, increase
## $2: counter: errors, warnings
## return: print on get
##
Counters(){
    case $1 in
        get)
            local COUNTER
            case $2 in
                errors)
                    case ${CONFIG_MAP["RUNNING_IN"]} in
                        loader) COUNTER=$LOADER_ERRORS ;;
                        shell)  COUNTER=$SHELL_ERRORS;;
                        task)   COUNTER=$TASK_ERRORS;;
                    esac
                    printf $COUNTER
                    return
                    ;;
                warnings)
                    case ${CONFIG_MAP["RUNNING_IN"]} in
                        loader) COUNTER=$LOADER_WARNINGS;;
                        shell)  COUNTER=$SHELL_WARNINGS;;
                        task)   COUNTER=$TASK_WARNINGS;;
                    esac
                    printf $COUNTER
                    return
                    ;;
                *)
                    ConsolePrint error "counters/get: unknown counter $2"
                    printf ""
                    ;;
            esac
            ;;
        increase)
            case $2 in
                errors)
                    case ${CONFIG_MAP["RUNNING_IN"]} in
                        loader) LOADER_ERRORS=$(($LOADER_ERRORS + 1));;
                        shell)  SHELL_ERRORS=$(($SHELL_ERRORS + 1));;
                        task)   TASK_ERRORS=$(($TASK_ERRORS + 1));;
                    esac
                    ;;
                warnings)
                    case ${CONFIG_MAP["RUNNING_IN"]} in
                        loader) LOADER_WARNINGS=$(($LOADER_WARNINGS + 1));;
                        shell)  SHELL_WARNINGS=$(($SHELL_WARNINGS + 1));;
                        task)   TASK_WARNINGS=$(($TASK_WARNINGS + 1));;
                    esac
                    ;;
                *)
                    ConsolePrint error "counters/increase: unknown counter $2"
                    ;;
            esac
            ;;
        reset)
            case $2 in
                errors)
                    case ${CONFIG_MAP["RUNNING_IN"]} in
                        loader) LOADER_ERRORS=0 ;;
                        shell)  SHELL_ERRORS=0 ;;
                        task)   TASK_ERRORS=0 ;;
                    esac
                    ;;
                warnings)
                    case ${CONFIG_MAP["RUNNING_IN"]} in
                        loader) LOADER_WARNINGS=0 ;;
                        shell)  SHELL_WARNINGS=0 ;;
                        task)   TASK_WARNINGS=0 ;;
                    esac
                    ;;
                *)
                    ConsolePrint error "counters/reset: unknown counter $2"
                    ;;
            esac
            ;;
    esac
}
Counters reset errors
Counters reset warnings



##
## function: ExecuteApiFunction()
## - executes an API function with optional arguments.
## $1: full command line for the API function, first word being the function name
##
ExecuteApiFunction(){
    local FUNCTION=$(echo $1 | cut -d' ' -f1)

    local FARG="$(echo $1 | cut -d' ' -f2-)"
    if [[ "$FARG" == "$FUNCTION" ]]; then
        FARG=
    fi

    if [[ $(type -t ${FUNCTION}) == "function" ]]; then
        if [[ -n "${FARG}" ]]; then
            ConsolePrint debug "api: execute API function $FUNCTION with arguments '$FARG'"
            $FUNCTION $FARG
        else
            ConsolePrint debug "api: execute API function $FUNCTION without arguments"
            $FUNCTION
        fi
        printf "\n"
    else
        ConsolePrint error "unknown API function '$FUNCTION'"
        printf "\n"
        return
    fi
}



##
## function: GetSetting()
## - returns the a requested setting.
## $1: the setting, one of: level, quiet
## return
## - for "level": the (console, log, print) level depending on what part of app we run in (loader, shell, task)
## - for "quiet": the (console, log, print) level depending on what part of app we run in (loader, shell, task)
##
GetSetting(){
    case $1 in
        level)
            case ${CONFIG_MAP["RUNNING_IN"]} in
                loader) printf "${CONFIG_MAP["LOADER_LEVEL"]}";;
                shell)  printf "${CONFIG_MAP["SHELL_LEVEL"]}";;
                task)   printf "${CONFIG_MAP["TASK_LEVEL"]}";;
            esac
            ;;
        quiet)
            case ${CONFIG_MAP["RUNNING_IN"]} in
                loader) printf "${CONFIG_MAP["LOADER_QUIET"]}";;
                shell)  printf "${CONFIG_MAP["SHELL_QUIET"]}";;
                task)   printf "${CONFIG_MAP["TASK_QUIET"]}";;
            esac
            ;;
        *)
            ConsolePrint error "get-setting: unknown setting $1"
            ;;
    esac
}



##
## function: ListFunctions()
## - lists all defined API functions.
## $1: set to anything to print one function per line
##
ListFunctions(){
    local FUNCTIONS=$(declare -F -p | cut -d " " -f 3)

    printf "\n"
    if [[ ! -n ${1:-} ]]; then
        echo ${FUNCTIONS}
    else
        printf "%s" "$FUNCTIONS"
     fi
}



##
## function: PathToSystemPath()
## - converts a path to Cygwin
## $1: path to convert
## return: converted path, original if not on a cygwin OS
## use: VARIABLE=$(PathToSystemPath "path")
##
PathToSystemPath() {
    if [[ ${CONFIG_MAP["SYSTEM"]} == "CYGWIN" ]]; then
        echo "`cygpath -m $1`"
    else
        echo $1
    fi
}



##
## function: TestFS()
## - tests an artifact in the file-system for some properties
## - tests an artifact $1 of type $2 has properties $3, with an optional error message add-on string $4
## $1: directory or filename, including path if required
## $2: type: f|file for file, d|dir|directory for directory
## $3: property, separated by comma, tested in given order, one of: e|exists,r|read,w|write
## $4: optional addition to error message, e.g. the calling function or task
##
TestFS() {
    if [[ -z ${1:-} ]]; then
        ConsolePrint error "TestFS: no artifact given"
        return
    fi
    if [[ -z ${2:-} ]]; then
        ConsolePrint error "TestFS: no type given"
        return
    fi
    if [[ -z ${3:-} ]]; then
        ConsolePrint error "TestFS: no properties given"
        return
    fi
    local MSG_ADDON=${4:-TestFS:}

    local ARTIFACT=$1
    local TYPE
    case $2 in
        f | file)               TYPE=file;;
        d | dir | directory)    TYPE=dir;;
        *)                      ConsolePrint error "$MSG_ADDON: unknown type $2"
            ;;
    esac
    local PROPERTIES=$3

    FIELD_SEAPARATOR=$IFS
    IFS=,
    for PROP in $PROPERTIES; do
        case $PROP in
            e | exists)
                case $TYPE in
                    file)
                        if [[ ! -f "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON: file does not exist: $ARTIFACT"
                        fi
                        ;;
                    dir)
                        if [[ ! -d "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON: directory does not exist: $ARTIFACT"
                        fi
                        ;;
                    *)
                        ConsolePrint error "$MSG_ADDON: unknown type $TYPE"
                        ;;
                esac
                ;;
            r | read)
                case $TYPE in
                    file)
                        if [[ ! -r "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON: file not readable: $ARTIFACT"
                        fi
                        ;;
                    dir)
                        if [[ ! -r "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON: directory not readable: $ARTIFACT"
                        fi
                        ;;
                    *)
                        ConsolePrint error "$MSG_ADDON: unknown type $TYPE"
                        ;;
                esac
                ;;
            w | write)
                case $TYPE in
                    file)
                        if [[ ! -r "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON: file not writable: $ARTIFACT"
                        fi
                        ;;
                    dir)
                        if [[ ! -r "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON: directory not writable: $ARTIFACT"
                        fi
                        ;;
                    *)
                        ConsolePrint error "$MSG_ADDON: unknown type $TYPE"
                        ;;
                esac
                ;;
            *)
                ConsolePrint error "$MSG_ADDON: unknown property $PROP"
                ;;
        esac
    done
    IFS=$FIELD_SEAPARATOR
}



##
## function: WriteRuntimeConfig()
## - writes the runtime configuration file
##
WriteRuntimeConfig() {
    local file=${CONFIG_MAP["FW_L1_CONFIG"]}
    rm $file
    touch $file

    declare -p CONFIG_MAP >> $file
    declare -p CONFIG_SRC >> $file
    declare -p FW_PATH_MAP >> $file
    declare -p APP_PATH_MAP >> $file

    declare -p CHAR_MAP >> $file
    declare -p COLORS >> $file
    declare -p EFFECTS >> $file


    declare -p DMAP_OPT_ORIGIN >> $file
    declare -p DMAP_OPT_SHORT >> $file
    declare -p DMAP_OPT_ARG >> $file


    declare -p DMAP_EC >> $file
    declare -p DMAP_EC_PROBLEM >> $file


    declare -p DMAP_CMD >> $file
    declare -p DMAP_CMD_SHORT >> $file
    declare -p DMAP_CMD_ARG >> $file


    declare -p DMAP_PARAM_ORIGIN >> $file
    declare -p DMAP_PARAM_DECL >> $file
    declare -p DMAP_PARAM_DEFVAL >> $file
    declare -p DMAP_PARAM_IS >> $file


    declare -p DMAP_DEP_ORIGIN >> $file
    declare -p DMAP_DEP_DECL >> $file
    declare -p DMAP_DEP_REQ_DEP >> $file
    declare -p DMAP_DEP_CMD >> $file

    declare -p RTMAP_DEP_STATUS >> $file


    declare -p DMAP_TASK_ORIGIN >> $file
    declare -p DMAP_TASK_DECL >> $file
    declare -p DMAP_TASK_SHORT >> $file
    declare -p DMAP_TASK_EXEC >> $file
    declare -p DMAP_TASK_MODES >> $file
    declare -p DMAP_TASK_MODE_FLAVOR >> $file

    declare -p DMAP_TASK_REQ_PARAM_MAN >> $file
    declare -p DMAP_TASK_REQ_PARAM_OPT >> $file
    declare -p DMAP_TASK_REQ_DEP_MAN >> $file
    declare -p DMAP_TASK_REQ_DEP_OPT >> $file
    declare -p DMAP_TASK_REQ_TASK_MAN >> $file
    declare -p DMAP_TASK_REQ_TASK_OPT >> $file
    declare -p DMAP_TASK_REQ_DIR_MAN >> $file
    declare -p DMAP_TASK_REQ_DIR_OPT >> $file
    declare -p DMAP_TASK_REQ_FILE_MAN >> $file
    declare -p DMAP_TASK_REQ_FILE_OPT >> $file

    declare -p RTMAP_TASK_STATUS >> $file
    declare -p RTMAP_TASK_LOADED >> $file
    declare -p RTMAP_TASK_UNLOADED >> $file


    declare -p DMAP_SCN_ORIGIN >> $file
    declare -p DMAP_SCN_DECL >> $file
    declare -p DMAP_SCN_SHORT >> $file
    declare -p DMAP_SCN_EXEC >> $file
    declare -p DMAP_SCN_MODES >> $file
    declare -p DMAP_SCN_MODE_FLAVOR >> $file


    declare -p DMAP_SCN_REQ_TASK_MAN >> $file
    declare -p DMAP_SCN_REQ_TASK_OPT >> $file

    declare -p RTMAP_SCN_STATUS >> $file
    declare -p RTMAP_SCN_LOADED >> $file
    declare -p RTMAP_SCN_UNLOADED >> $file


    declare -p RTMAP_REQUESTED_DEP >> $file
    declare -p RTMAP_REQUESTED_PARAM >> $file

    declare -p DMAP_CMD_DESCR >> $file
    declare -p DMAP_DEP_DESCR >> $file
    declare -p DMAP_EC_DESCR >> $file
    declare -p DMAP_OPT_DESCR >> $file
    declare -p DMAP_PARAM_DESCR >> $file
    declare -p DMAP_TASK_DESCR >> $file
    declare -p DMAP_SCN_DESCR >> $file
}
