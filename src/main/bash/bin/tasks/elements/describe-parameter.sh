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

PARAM_ID=
DEFAULT=
ORIGIN=
REQUESTED=
STATUS=
INSTALL=

CLI_SET=false
ALL=



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AdDhi:Io:P:rs:
CLI_LONG_OPTIONS=all,debug,default,help,id:,install,origin:,print-mode:,requested,status:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-parameter -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "describe-parameter: unknown CLI options"
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
        -d | --default)
            DEFAULT=yes
            CLI_SET=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "describe-parameter")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start standard-options
                printf "   standard describe options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                        $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"                      $PRINT_PADDING
                BuildTaskHelpTag end standard-options

                printf "\n"
                BuildTaskHelpTag start task-options
                printf "   task options\n"
                BuildTaskHelpLine D debug       "<none>"    "print debug information instead of description"    $PRINT_PADDING
                BuildTaskHelpTag end task-options

                printf "\n"
                BuildTaskHelpTag start standard-filters
                printf "   standard describe filters\n"
                BuildTaskHelpLine A all         "<none>"    "all entries, disables all other filters"           $PRINT_PADDING
                BuildTaskHelpTag end standard-filters

                printf "\n"
                BuildTaskHelpTag start task-filters
                printf "   task filters\n"
                BuildTaskHelpLine d default     "<none>"    "with a declared default value"                                 $PRINT_PADDING
                BuildTaskHelpLine i id          "ID"        "parameter identifier, any upper/lower case spelling"           $PRINT_PADDING
                BuildTaskHelpLine I install     "<none>"    "required only by install tasks"                                $PRINT_PADDING
                BuildTaskHelpLine o origin      "ORIGIN"    "from origin: f(w), a(pp)"                                      $PRINT_PADDING
                BuildTaskHelpLine r requested   "<none>"    "requested"                                                     $PRINT_PADDING
                BuildTaskHelpLine s status      "STATUS"    "with status: for status: (o)ption, (f)ile, (e)nv, (d)efault"   $PRINT_PADDING
                BuildTaskHelpTag end task-filters
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
            PARAM_ID="${2^^}"
            CLI_SET=true
            shift 2
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
            ConsolePrint fatal "describe-parameter: internal error (task): CLI parsing bug"
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
    INSTALL=
else
    if [[ -n "$PARAM_ID" ]]; then
        if [[ -z ${DMAP_PARAM_ORIGIN[$PARAM_ID]:-} ]]; then
            ConsolePrint error "dp: unknown parameter: $PARAM_ID"
            exit 60
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
                ConsolePrint error "dp: unknown origin: $ORIGIN"
                exit 61
        esac
    fi
    if [[ -n "$STATUS" ]]; then
        case $STATUS in
            N | n | notset)
                STATUS=N
                ;;
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
                ConsolePrint error "dp: unknown status: $STATUS"
                exit 62
        esac
    fi
fi
case $D_FORMAT in
    descr | debug)
        ;;
    *)
        ConsolePrint fatal "dp: internal error: unknown describe format '$D_FORMAT'"
        exit 69
        ;;
esac


############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "dp: starting task"

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
        if [[ ! -n "${DMAP_PARAM_DEFVAL[$ID]:-}" ]]; then
            continue
        fi
    fi
    if [[ -n "$STATUS" ]]; then
        if [[ -z "${CONFIG_SRC[$ID]:-}" ]]; then
            if [[ "$STATUS" != "N" ]]; then
                continue
            fi
        else
            case ${CONFIG_SRC[$ID]} in
                $STATUS)
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
    fi
    if [[ -n "$ORIGIN" ]]; then
        if [[ ! "$ORIGIN" == "${DMAP_PARAM_ORIGIN[$ID]}" ]]; then
            continue
        fi
    fi
    if [[ "$INSTALL" == "yes" ]]; then
        found=false
        ## install set, so only all parameters _only_ in 'install' tasks
        ## so go through DMAP_TASK_REQ_PARAM_MAN and DMAP_TASK_REQ_PARAM_OPT until we find an 'install' task
        for TASK_ID in ${!DMAP_TASK_REQ_PARAM_MAN[@]}; do
            for TPARAM in ${DMAP_TASK_REQ_PARAM_MAN[$TASK_ID]}; do
                if [[ "$TPARAM" == "$ID" && "${DMAP_TASK_MODE_FLAVOR[$TASK_ID]:-}" == "install" ]]; then
                    found=true
                    break
                fi
            done
            if [[ $found == true ]]; then
                break
            fi
        done
        if [[ $found == false ]]; then
            for TASK_ID in ${!DMAP_TASK_REQ_PARAM_OPT[@]}; do
                for TPARAM in ${DMAP_TASK_REQ_PARAM_OPT[$TASK_ID]}; do
                    if [[ "$TPARAM" == "$ID" && "${DMAP_TASK_MODE_FLAVOR[$TASK_ID]:-}" == "install" ]]; then
                        found=true
                        break
                    fi
                done
                if [[ $found == true ]]; then
                    break
                fi
            done
        fi
        if [[ $found == false ]]; then
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
            DescribeParameter $ID full "$PRINT_MODE line-indent" $PRINT_MODE ;;
        debug)
            DebugParameter $ID ;;
    esac
done

ConsolePrint info "dp: done"
exit $TASK_ERRORS
