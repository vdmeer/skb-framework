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
## function: GetLevel()
## - returns the (console, log, print) level depending on what part of app we run in (loader, shell, task)
##
GetLevel(){
    case ${CONFIG_MAP["RUNNING_IN"]} in
        loader) printf "${CONFIG_MAP["LOADER_LEVEL"]}";;
        shell)  printf "${CONFIG_MAP["SHELL_LEVEL"]}";;
        task)   printf "${CONFIG_MAP["TASK_LEVEL"]}";;
    esac
}



##
## function: GetQuiet()
## - returns the quiet setting depending on what part of app we run in (loader, shell, task)
##
GetQuiet(){
    case ${CONFIG_MAP["RUNNING_IN"]} in
        loader) printf "${CONFIG_MAP["LOADER_QUIET"]}";;
        shell)  printf "${CONFIG_MAP["SHELL_QUIET"]}";;
        task)   printf "${CONFIG_MAP["TASK_QUIET"]}";;
    esac
}



##
## function: IncreaseCounter()
## - increases a counter depending on what part of app we run in (loader, shell, task)
## $1: counter to increase, one of: errors, warnings
##
IncreaseCounter(){
    case $1 in
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
            ConsolePrint error "increase-counter: unknown counter $1"
            ;;
    esac
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
## function: ResetCounter()
## - resets a counter depending on what part of app we run in (loader, shell, task)
## $1: counter to reset, one of: errors, warnings
##
ResetCounter(){
    case $1 in
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
            ConsolePrint error "console-reset: unknown counter $1"
            ;;
    esac
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

    local ARTIFACT=$1
    local TYPE
    case $2 in
        f | file)               TYPE=file;;
        d | dir | directory)    TYPE=dir;;
        *)                      ConsolePrint error "$MSG_ADDON: unknown type $2"
            ;;
    esac
    local PROPERTIES=$3

    local MSG_ADDON="TestFS:"
    if [[ -n ${4:-} ]]; then
        MSG_ADDON="$4: "
    fi

    FIELD_SEAPARATOR=$IFS
    IFS=,
    for PROP in $PROPERTIES; do
        case $PROP in
            e | exists)
                case $TYPE in
                    file)
                        if [[ ! -f "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON file does not exist: $ARTIFACT"
                        fi
                        ;;
                    dir)
                        if [[ ! -d "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON directory does not exist: $ARTIFACT"
                        fi
                        ;;
                    *)
                        ConsolePrint error "$MSG_ADDON unknown type $TYPE"
                        ;;
                esac
                ;;
            r | read)
                case $TYPE in
                    file)
                        if [[ ! -r "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON file not readable: $ARTIFACT"
                        fi
                        ;;
                    dir)
                        if [[ ! -r "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON directory not readable: $ARTIFACT"
                        fi
                        ;;
                    *)
                        ConsolePrint error "$MSG_ADDON unknown type $TYPE"
                        ;;
                esac
                ;;
            w | write)
                case $TYPE in
                    file)
                        if [[ ! -r "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON file not writable: $ARTIFACT"
                        fi
                        ;;
                    dir)
                        if [[ ! -r "$ARTIFACT" ]]; then
                            ConsolePrint error "$MSG_ADDON directory not writable: $ARTIFACT"
                        fi
                        ;;
                    *)
                        ConsolePrint error "$MSG_ADDON unknown type $TYPE"
                        ;;
                esac
                ;;
            *)
                ConsolePrint error "$MSG_ADDON unknown property $PROP"
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


    declare -p DMAP_ES >> $file
    declare -p DMAP_ES_PROBLEM >> $file


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
    declare -p DMAP_ES_DESCR >> $file
    declare -p DMAP_OPT_DESCR >> $file
    declare -p DMAP_PARAM_DESCR >> $file
    declare -p DMAP_TASK_DESCR >> $file
    declare -p DMAP_SCN_DESCR >> $file
}
