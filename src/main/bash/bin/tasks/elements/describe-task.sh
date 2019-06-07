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
## describe-task - describes a task or tasks
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
PRINT_MODE=
D_FORMAT=descr

TASK_ID=
LOADED=
UNLOADED=
APP_MODE=
ORIGIN=
STATUS=
ALL=
INSTALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=ADhi:Ilm:o:P:s:u
CLI_LONG_OPTIONS=all,debug,mode:,help,id:,install,loaded,origin:,print-mode:,status:,unloaded

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-task -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "describe-task: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -A | --all)
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
            CACHED_HELP=$(TaskGetCachedHelp "describe-task")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine D debug       "<none>"    "print debug information instead of description"    $PRINT_PADDING
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                        $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"                      $PRINT_PADDING

                printf "\n   filters\n"
                BuildTaskHelpLine A all         "<none>"    "all tasks, disables all other filters"                                     $PRINT_PADDING
                BuildTaskHelpLine i id          "ID"        "task identifier"                                                           $PRINT_PADDING
                BuildTaskHelpLine I install     "<none>"    "only tasks declared for application mode flavor 'install'"                 $PRINT_PADDING
                BuildTaskHelpLine l loaded      "<none>"    "only loaded tasks"                                                         $PRINT_PADDING
                BuildTaskHelpLine m mode        "MODE"      "only tasks for application mode: all, dev, build, use"                     $PRINT_PADDING
                BuildTaskHelpLine o origin      "ORIGIN"    "only tasks from origin: f(w), a(pp)"                                       $PRINT_PADDING
                BuildTaskHelpLine s status      "STATUS"    "only tasks for status: (s)uccess, (w)arning, (e)rror, (n)ot attempted"     $PRINT_PADDING
                BuildTaskHelpLine u unloaded    "<none>"    "only unloaded tasks"                                                       $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -D | --debug)
            shift
            D_FORMAT=debug
            ;;
        -i | --id)
            TASK_ID="$2"
            CLI_SET=true
            shift 2
            ;;
        -l | --loaded)
            LOADED=yes
            CLI_SET=true
            shift
            ;;
        -I | --install)
            INSTALL=yes
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
            ConsolePrint fatal "describe-task: internal error (task): CLI parsing bug"
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
    TASK_ID=
    LOADED=
    UNLOADED=
    APP_MODE=all
    ORIGIN=
    STATUS=
    INSTALL=all
elif [[ $CLI_SET == false ]]; then
    APP_MODE=${CONFIG_MAP["APP_MODE"]}
    LOADED=yes
else
    if [[ -n "$TASK_ID" ]]; then
        ORIG_TASK=$TASK_ID
        TASK_ID=$(GetTaskID $TASK_ID)
        if [[ -z ${TASK_ID:-} ]]; then
            ConsolePrint error "dt: unknown task: $ORIG_TASK"
            exit 60
        else
            if [[ -z ${DMAP_TASK_ORIGIN[$TASK_ID]:-} ]]; then
                ConsolePrint error "dt: unknown task: $ORIG_TASK"
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
                ConsolePrint error "dt: unknown origin: $ORIGIN"
                exit 62
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
                ConsolePrint error "dt: unknown application mode: $APP_MODE"
                exit 64
        esac
    fi
    if [[ -n "$STATUS" ]]; then
        case $STATUS in
            S | s | success)
                STATUS=S
                ;;
            E | e | errors | error)
                STATUS=E
                ;;
            W | w | warnings | warning)
                STATUS=W
                ;;
            N | n | not-attepmted)
                STATUS=N
                ;;
            *)
                ConsolePrint error "dt: unknown status: $STATUS"
                exit 65
        esac
    fi
fi
case $D_FORMAT in
    descr | debug)
        ;;
    *)
        ConsolePrint fatal "dt: internal error: unknown describe format '$D_FORMAT'"
        exit 69
        ;;
esac


############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "dt: starting task"

for ID in ${!DMAP_TASK_ORIGIN[@]}; do
    if [[ -n "$TASK_ID" ]]; then
        if [[ ! "$TASK_ID" == "$ID" ]]; then
            continue
        fi
    fi
    if [[ -n "$LOADED" ]]; then
        if [[ -z "${RTMAP_TASK_LOADED[$ID]:-}" ]]; then
            continue
        fi
    fi
    if [[ -n "$UNLOADED" ]]; then
        if [[ -z "${RTMAP_TASK_UNLOADED[$ID]:-}" ]]; then
            continue
        fi

    fi
    if [[ -n "$STATUS" ]]; then
        case ${RTMAP_TASK_STATUS[$ID]} in
            $STATUS)
                ;;
            *)
                continue
                ;;
        esac
    fi
    if [[ -n "$INSTALL" && "$INSTALL" == "yes" ]]; then
        if [[ "${DMAP_TASK_MODE_FLAVOR[$ID]}" != "install" ]]; then
            continue
        fi
    fi
    if [[ -n "$APP_MODE" ]]; then
        if [[ "$APP_MODE" != "all" ]]; then
            case ${DMAP_TASK_MODES[$ID]} in
                *$APP_MODE*)
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
    fi
    if [[ -n "$ORIGIN" ]]; then
        if [[ ! "$ORIGIN" == "${DMAP_TASK_ORIGIN[$ID]}" ]]; then
            continue
        fi
    fi
    keys=(${keys[@]:-} $ID)
done
keys=($(printf '%s\n' "${keys[@]:-}"|sort))

for i in ${!keys[@]}; do
    ID=${keys[$i]}
    case $D_FORMAT in
        descr)
            DescribeTask $ID full "$PRINT_MODE line-indent" $PRINT_MODE ;;
        debug)
            DebugTask $ID ;;
    esac
done

ConsolePrint info "dt: done"
exit $TASK_ERRORS
