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
## describe-command - describes a command or commands
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
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
## - reset errors and warnings
##
source $FW_HOME/bin/functions/_include
source $FW_HOME/bin/functions/describe/command.sh
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
PRINT_MODE=
CMD_ID=
ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=ahi:P:
CLI_LONG_OPTIONS=all,help,id:,print-mode:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-command -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -a | --all)
            ALL=yes
            CLI_SET=true
            shift
            ;;
        -h | --help)
            printf "\n   options\n"
            BuildTaskHelpLine h help        "<none>"    "print help screen and exit"    $PRINT_PADDING
            BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"  $PRINT_PADDING
            printf "\n   filters\n"
            BuildTaskHelpLine a all         "<none>"    "all commands, disables all other filters"  $PRINT_PADDING
            BuildTaskHelpLine i id          "ID"        "command identifier"                        $PRINT_PADDING
            exit 0
            ;;
        -i | --id)
            CMD_ID="$2"
            CLI_SET=true
            shift 2
            ;;
        -P | --print-mode)
            PRINT_MODE="$2"
            shift 2
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI
############################################################################################
if [[ ! -n "$PRINT_MODE" ]]; then
    PRINT_MODE=${CONFIG_MAP["PRINT_MODE"]}
fi

if [[ "$ALL" == "yes" ]]; then
    CMD_ID=
else
    if [[ -n "$CMD_ID" ]]; then
        if [[ "${DMAP_CMD[$CMD_ID]:-}" == "--" ]]; then
            if [[ ! -z "${DMAP_CMD_SHORT[$CMD_ID]:-}" ]]; then
                CMD_ID="${DMAP_CMD_SHORT[$CMD_ID]}"
            fi
        fi
        if [[ ! -n "${DMAP_CMD[$CMD_ID]:-}" ]]; then
            ConsoleError " ->" "describe-command - unknown command ID '$CMD_ID'"
            return
        fi
    fi
fi


############################################################################################
##
## ready to go
##
############################################################################################
ConsoleInfo "  -->" "dc: starting task"

for ID in ${!DMAP_CMD[@]}; do
    if [[ -n "$CMD_ID" ]]; then
        if [[ ! "$CMD_ID" == "$ID" ]]; then
            continue
        fi
    fi
    keys=(${keys[@]:-} $ID)
done
keys=($(printf '%s\n' "${keys[@]:-}"|sort))

for i in ${!keys[@]}; do
    ID=${keys[$i]}
    DescribeCommand $ID full "$PRINT_MODE line-indent" $PRINT_MODE
done

ConsoleInfo "  -->" "dc: done"
exit $TASK_ERRORS
