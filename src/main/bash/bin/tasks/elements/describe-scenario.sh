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
## describe-scenario - describes a scenario or scenarios
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
source $FW_HOME/bin/functions/describe/scenario.sh
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
PRINT_MODE=
SCN_ID=
LOADED=
UNLOADED=
APP_MODE=
ORIGIN=
STATUS=
ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=ahi:lm:o:P:s:u
CLI_LONG_OPTIONS=all,mode:,help,id:,loaded,origin:,print-mode:,status:,unloaded

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-scenario -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "ds: unknown CLI options"
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
        -m | --mode)
            APP_MODE="$2"
            CLI_SET=true
            shift 2
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "describe-scenario")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"              $PRINT_PADDING
                printf "\n   filters\n"
                BuildTaskHelpLine a all         "<none>"    "all scenarios, disables all other filters"                 $PRINT_PADDING
                BuildTaskHelpLine i id          "ID"        "scenario identifier"                                       $PRINT_PADDING
                BuildTaskHelpLine l loaded      "<none>"    "only loaded scenarios"                                     $PRINT_PADDING
                BuildTaskHelpLine m mode        "MODE"      "only scenarios for application mode: dev, build, use"      $PRINT_PADDING
                BuildTaskHelpLine o origin      "ORIGIN"    "only scenarios from origin: f(w), a(pp)"                   $PRINT_PADDING
                BuildTaskHelpLine s status      "STATUS"    "only scenarios for status: success, warnings, errors"      $PRINT_PADDING
                BuildTaskHelpLine u unloaded    "<none>"    "only unloaded scenarios"                                   $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -i | --id)
            SCN_ID="$2"
            CLI_SET=true
            shift 2
            ;;
        -l | --loaded)
            LOADED=yes
            CLI_SET=true
            shift
            ;;
        -o | --origin)
            ORIGIN="$2"
            CLI_SET=true
            shift 2
            ;;
        -P | --print-mode)
            PRINT_MODE="$2"
            CLI_SET=true
            shift 2
            ;;
        -s | --status)
            STATUS="$2"
            CLI_SET=true
            shift 2
            ;;
        -u | --unloaded)
            UNLOADED=yes
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "ds: internal error (task): CLI parsing bug"
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
    SCN_ID=
    LOADED=
    UNLOADED=
    APP_MODE=
    ORIGIN=
    STATUS=
elif [[ $CLI_SET == false ]]; then
    APP_MODE=${CONFIG_MAP["APP_MODE"]}
    LOADED=yes
else
    if [[ -n "$SCN_ID" ]]; then
        ORIG_SCN=$SCN_ID
        SCN_ID=$(GetScenarioID $SCN_ID)
        if [[ -z ${SCN_ID:-} ]]; then
            ConsoleError " ->" "ds: unknown scenario: $ORIG_SCN"
            exit 60
        else
            if [[ -z ${DMAP_SCN_ORIGIN[$SCN_ID]:-} ]]; then
                ConsoleError " ->" "ds: unknown scenario: $ORIG_SCN"
                exit 61
            fi
        fi
    fi
    if [[ -n "$ORIGIN" ]]; then
        case $ORIGIN in
            F| f | fw | framework)
                ORIGIN=FW_HOME
                ;;
            A | a | app | application)
                ORIGIN=APP_HOME
                ;;
            *)
                case $ORIGIN in
                    *[!0-9]*)
                        ConsoleError " ->" "ds: unknown origin: $ORIGIN"
                        exit 62
                    ;;
                esac
        esac
    fi
    if [[ -n "$APP_MODE" ]]; then
        case $APP_MODE in
            A| a | All | all)
                APP_MODE=all
                ;;
            D| d | Dev | dev)
                APP_MODE=dev
                ;;
            B | b| Build | build)
                APP_MODE=build
                ;;
            U | u | Use | use)
                APP_MODE=use
                ;;
            *)
                ConsoleError "  ->" "ds: unknown application mode: $APP_MODE"
                exit 64
        esac
    fi
    if [[ -n "$STATUS" ]]; then
        case $STATUS in
            s | success)
                STATUS=S
                ;;
            e | errors | error)
                STATUS=E
                ;;
            w | warnings | warning)
                STATUS=W
                ;;
            *)
                ConsoleError "  ->" "ds: unknown status: $STATUS"
                exit 65
        esac
    fi
fi


############################################################################################
##
## ready to go
##
############################################################################################
ConsoleInfo "  -->" "ds: starting task"

for ID in ${!DMAP_SCN_ORIGIN[@]}; do
    if [[ -n "$SCN_ID" ]]; then
        if [[ ! "$SCN_ID" == "$ID" ]]; then
            continue
        fi
    fi
    if [[ -n "$LOADED" ]]; then
        if [[ -z "${RTMAP_SCN_LOADED[$ID]:-}" ]]; then
            continue
        fi
    fi
    if [[ -n "$UNLOADED" ]]; then
        if [[ -z "${RTMAP_SCN_UNLOADED[$ID]:-}" ]]; then
            continue
        fi

    fi
    if [[ -n "$STATUS" ]]; then
        case ${RTMAP_SCN_STATUS[$ID]} in
            $STATUS)
                ;;
            *)
                continue
                ;;
        esac
        #=
    fi
    if [[ -n "$APP_MODE" ]]; then
        if [[ "$APP_MODE" != "all" ]]; then
            case ${DMAP_SCN_MODES[$ID]} in
                *$APP_MODE*)
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
    fi
    if [[ -n "$ORIGIN" ]]; then
        if [[ ! "$ORIGIN" == "${DMAP_SCN_ORIGIN[$ID]}" ]]; then
            continue
        fi
    fi
    keys=(${keys[@]:-} $ID)
done
keys=($(printf '%s\n' "${keys[@]:-}"|sort))

for i in ${!keys[@]}; do
    ID=${keys[$i]}
    DescribeScenario $ID full "$PRINT_MODE line-indent" $PRINT_MODE
done

ConsoleInfo "  -->" "ds: done"
exit $TASK_ERRORS
