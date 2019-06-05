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
## describe-dependency - describes a dependency or dependencies
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
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
source $FW_HOME/bin/api/_include
ResetCounter errors
ResetCounter warnings


##
## set local variables
##
PRINT_MODE=
D_FORMAT=descr

DEP_ID=
TESTED=
ORIGIN=
REQUESTED=
STATUS=
INSTALL=

CLI_SET=false
ALL=



##
## set CLI options and parse CLI
##
CLI_OPTIONS=ADhi:Io:P:rs:t
CLI_LONG_OPTIONS=all,debug,help,id:,install,origin:,print-mode:,status:,tested,requested

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-dependency -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "describe-dependency: unknown CLI options"
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
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "describe-dependency")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine D debug       "<none>"    "print debug information instead of description"    $PRINT_PADDING
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"  $PRINT_PADDING
                printf "\n   filters\n"
                BuildTaskHelpLine A all         "<none>"    "all dependencies, disables all other filters"                                      $PRINT_PADDING
                BuildTaskHelpLine i id          "ID"        "dependency identifier"                                                             $PRINT_PADDING
                BuildTaskHelpLine I install     "<none>"    "only dependencies required only by install tasks"                                  $PRINT_PADDING
                BuildTaskHelpLine o origin      "ORIGIN"    "only dependencies from origin: f(w), a(pp)"                                        $PRINT_PADDING
                BuildTaskHelpLine r requested   "<none>"    "only requested dependencies"                                                       $PRINT_PADDING
                BuildTaskHelpLine s status      "STATUS"    "only dependencies with status: (s)uccess, (w)arning, (e)rror, (n)ot attempted"     $PRINT_PADDING
                BuildTaskHelpLine t tested      "<none>"    "only tested dependencies"                                                          $PRINT_PADDING
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
            DEP_ID="$2"
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
            CLI_SET=true
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
        -t | --tested)
            TESTED=yes
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "describe-dependency: internal error (task): CLI parsing bug"
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
    DEP_ID=
    TESTED=
    ORIGIN=
    REQUESTED=
    STATUS=
    INSTALL=
elif [[ $CLI_SET == false ]]; then
    TESTED=yes
else
    if [[ -n "$DEP_ID" ]]; then
        if [[ -z ${DMAP_DEP_ORIGIN[$DEP_ID]:-} ]]; then
            ConsolePrint error "dd: unknown dependency: $DEP_ID"
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
                ConsolePrint error "dd: unknown origin: $ORIGIN"
                exit 60
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
            N | n | not-attempted)
                STATUS=N
                ;;
            *)
                ConsolePrint error "dd: unknown status: $STATUS"
                exit 61
        esac
    fi
fi
case $D_FORMAT in
    descr | debug)
        ;;
    *)
        ConsolePrint fatal "dd: internal error: unknown describe format '$D_FORMAT'"
        exit 69
        ;;
esac



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "dd: starting task"

for ID in ${!DMAP_DEP_ORIGIN[@]}; do
    if [[ -n "$DEP_ID" ]]; then
        if [[ ! "$DEP_ID" == "$ID" ]]; then
            continue
        fi
    fi
    if [[ -n "$REQUESTED" ]]; then
        if [[ -z "${RTMAP_REQUESTED_DEP[$ID]:-}" ]]; then
            continue
        fi
    fi
    if [[ -n "$TESTED" ]]; then
        if [[ "${RTMAP_DEP_STATUS[$ID]:-}" != "S" ]]; then
            continue
        fi
    fi
    if [[ -n "$STATUS" ]]; then
        case ${RTMAP_DEP_STATUS[$ID]} in
            $STATUS)
                ;;
            *)
                continue
                ;;
        esac
    fi
    if [[ -n "$ORIGIN" ]]; then
        if [[ ! "$ORIGIN" == "${DMAP_DEP_ORIGIN[$ID]}" ]]; then
            continue
        fi
    fi
    if [[ "$INSTALL" == "yes" ]]; then
        found=false
        ## install set, so show all dependencies _only_ in 'install' tasks
        ## so go through DMAP_TASK_REQ_DEP_MAN and DMAP_TASK_REQ_DEP_OPT until we find an 'install' task
        for TASK_ID in ${!DMAP_TASK_REQ_DEP_MAN[@]}; do
            for TDEP in ${DMAP_TASK_REQ_DEP_MAN[$TASK_ID]}; do
                if [[ "$TDEP" == "$ID" && "${DMAP_TASK_MODE_FLAVOR[$TASK_ID]:-}" == "install" ]]; then
                    found=true
                    break
                fi
            done
            if [[ $found == true ]]; then
                break
            fi
        done
        if [[ $found == false ]]; then
            for TASK_ID in ${!DMAP_TASK_REQ_DEP_OPT[@]}; do
                for TDEP in ${DMAP_TASK_REQ_DEP_OPT[$TASK_ID]}; do
                    if [[ "$TDEP" == "$ID" && "${DMAP_TASK_MODE_FLAVOR[$TASK_ID]:-}" == "install" ]]; then
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
            DescribeDependency $ID full "$PRINT_MODE line-indent" $PRINT_MODE ;;
        debug)
            DebugDependency $ID ;;
    esac
done

ConsolePrint info "dd: done"
exit $TASK_ERRORS
