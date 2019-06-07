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
## build-help - builds help files for loader and shell
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



## put bugs into errors, safer
set -o errexit -o pipefail -o noclobber -o nounset


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
##
source $FW_HOME/bin/api/_include


##
## set local variables
##
DO_CLEAN=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=ch
CLI_LONG_OPTIONS=clean,help

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name build-help -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "build-help: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -c | --clean)
            DO_CLEAN=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "build-help")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine c clean   "<none>"    "added by convention, does nothing"                 $PRINT_PADDING
                BuildTaskHelpLine h help    "<none>"    "print help screen and exit"                        $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "build-help: internal error (task): CLI parsing bug"
            exit 52
    esac
done




############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "bdh: starting task"
Counters reset errors


if [[ $DO_CLEAN == true ]]; then
    ## we do not do a clean on the help files
    ConsolePrint info "bdh: done"
    exit 0
fi

PRINT_MODES="ansi text"
ConsolePrint info "build help for options and commands"

if [[ ! -d "${CONFIG_MAP["FW_HOME"]}/etc" ]]; then
    ConsolePrint error "bdh: \$FW_HOME/etc does not exist"
fi
if [[ ! -d "${CONFIG_MAP["FW_HOME"]}/etc/help" ]]; then
    mkdir -p ${CONFIG_MAP["FW_HOME"]}/etc/help
fi

ConsolePrint debug "target: command help"
if [[ ! -z "${RTMAP_TASK_LOADED["list-commands"]}" ]]; then
    for MODE in $PRINT_MODES; do
        FILE=${CONFIG_MAP["FW_HOME"]}/etc/help/commands.$MODE
        if [[ -f $FILE ]]; then
            rm $FILE
        fi
        set +e
        ${DMAP_TASK_EXEC["list-commands"]} --print-mode $MODE > ${CONFIG_MAP["FW_HOME"]}/etc/help/commands.$MODE
        set -e
    done
else
    ConsolePrint error "bdh/cmd-list: did not find task 'list-commands', not loaded?"
fi

ConsolePrint debug "target: option help"
if [[ ! -z "${RTMAP_TASK_LOADED["list-options"]}" ]]; then
    for MODE in $PRINT_MODES; do
        FILE=${CONFIG_MAP["FW_HOME"]}/etc/help/options.$MODE
        if [[ -f $FILE ]]; then
            rm $FILE
        fi
        printf "\n%s - the %s\n\n" "${CONFIG_MAP["APP_SCRIPT"]}" "${CONFIG_MAP["APP_NAME"]}" > ${CONFIG_MAP["FW_HOME"]}/etc/help/options.$MODE
        printf "  Usage:  %s [options]\n" "${CONFIG_MAP["APP_SCRIPT"]}" >> ${CONFIG_MAP["FW_HOME"]}/etc/help/options.$MODE
        set +e
        ${DMAP_TASK_EXEC["list-options"]} --all --print-mode $MODE >> ${CONFIG_MAP["FW_HOME"]}/etc/help/options.$MODE
        set -e
    done
else
    ConsolePrint error "bdh/opt-list: did not find task 'list-options', not loaded?"
fi

ConsolePrint info "bdh: done"
exit $TASK_ERRORS
