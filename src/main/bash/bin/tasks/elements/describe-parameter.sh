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
## describe-parameter - describes a parameter or parameters
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
source $FW_HOME/bin/functions/describe/parameter.sh
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
PRINT_MODE=
PARAM_ID=
DEFAULT=
ORIGIN=
REQUESTED=
STATUS=
ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=adhi:o:P:rs:
CLI_LONG_OPTIONS=all,default,help,id:,origin:,print-mode:,requested,status:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-parameter -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "dp: unknown CLI options"
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
        -d | --default)
            DEFAULT=yes
            CLI_SET=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "describe-parameter")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"  $PRINT_PADDING

                printf "\n   filters\n"
                BuildTaskHelpLine a all         "<none>"    "all parameters, disables all other filters"            $PRINT_PADDING
                BuildTaskHelpLine d default     "<none>"    "only parameters with a defined default value"          $PRINT_PADDING
                BuildTaskHelpLine i id          "ID"        "parameter identifier"                                  $PRINT_PADDING
                BuildTaskHelpLine o origin      "ORIGIN"    "only parameters from origin: f(w), a(pp)"              $PRINT_PADDING
                BuildTaskHelpLine r requested   "<none>"    "only requested dependencies"                           $PRINT_PADDING
                BuildTaskHelpLine s status      "STATUS"    "only parameter for status: o, f, e, d"                 $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -i | --id)
            PARAM_ID="${2^^}"
            CLI_SET=true
            shift 2
            ;;
        -o | --origin)
            ORIGIN="$2"
            CLI_SET=true
            shift 2
            ;;
        -P | --print-mode)
            PRINT_MODE="$2"
            shift 2
            ;;
        -r | --requested)
            REQUESTED=yes
            CLI_SET=true
            shift
            ;;
        -s | --status)
            STATUS="$2"
            CLI_SET=true
            shift 2
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "dp: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI
############################################################################################
if [[ ! -n "$PRINT_MODE" ]]; then
    PRINT_MODE=${CONFIG_MAP["PRINT_MODE"]}
fi

if [[ "$ALL" == "yes" || $CLI_SET == false ]]; then
    PARAM_ID=
    DEFAULT=
    ORIGIN=
    REQUESTED=
    STATUS=
else
    if [[ -n "$PARAM_ID" ]]; then
        if [[ -z ${DMAP_PARAM_ORIGIN[$PARAM_ID]:-} ]]; then
            ConsoleError " ->" "dp: unknown parameter: $PARAM_ID"
            exit 60
        fi
    fi
    if [[ -n "$ORIGIN" ]]; then
        case $ORIGIN in
            F| f | fw | framework)
                ORIGIN=FW_HOME
                ;;
            A | a | app | application)
                ORIGIN=${CONFIG_MAP["FLAVOR"]}_HOME
                ;;
            *)
                ConsoleError " ->" "dp: unknown origin: $ORIGIN"
                exit 61
        esac
    fi
    if [[ -n "$STATUS" ]]; then
        case $STATUS in
            O | o | option)
                STATUS=O
                ;;
            E | e | env | environment)
                STATUS=E
                ;;
            F | f | file)
                STATUS=F
                ;;
            D | d | default)
                STATUS=D
                ;;
            *)
                ConsoleError "  ->" "dp: unknown status: $STATUS"
                exit 62
        esac
    fi
fi


############################################################################################
##
## ready to go
##
############################################################################################
ConsoleInfo "  -->" "dp: starting task"

for ID in ${!DMAP_PARAM_ORIGIN[@]}; do
    if [[ -n "$PARAM_ID" ]]; then
        if [[ ! "$PARAM_ID" == "$ID" ]]; then
            continue
        fi
    fi
    if [[ -n "$REQUESTED" ]]; then
        if [[ -z "${RTMAP_REQUESTED_PARAM[$ID]:-}" ]]; then
            continue
        fi
    fi
    if [[ -n "$DEFAULT" ]]; then
        if [[ ! -n "${DMAP_PARAM_DEFVAL[$PARAM_ID]:-}" ]]; then
            continue
        fi
    fi
    if [[ -n "$STATUS" ]]; then
        case ${RTMAP_PARAM_STATUS[$ID]} in
            $STATUS)
                ;;
            *)
                continue
                ;;
        esac
        #=
    fi
    if [[ -n "$ORIGIN" ]]; then
        if [[ ! "$ORIGIN" == "${DMAP_PARAM_ORIGIN[$ID]}" ]]; then
            continue
        fi
    fi
    keys=(${keys[@]:-} $ID)
done
keys=($(printf '%s\n' "${keys[@]:-}"|sort))

for i in ${!keys[@]}; do
    ID=${keys[$i]}
    DescribeParameter $ID full "$PRINT_MODE line-indent" $PRINT_MODE
done

ConsoleInfo "  -->" "dp: done"
exit $TASK_ERRORS
