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
## statistics - prints statistics
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
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
PRINT_MODE=
COMMANDS=
DEPENDENCIES=
EXITSTATUS=
OPTIONS=
OVERVIEW=
PARAMETERS=
SCENARIOS=
TASKS=
ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=ahP:
CLI_LONG_OPTIONS=all,help,print-mode:
CLI_LONG_OPTIONS+=,all,ov,cmd,dep,es,opt,param,scn,task

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name statistics -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "stats: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "statistics")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"  $PRINT_PADDING

                printf "\n   filters\n"
                BuildTaskHelpLine a all             "<none>"   "activate all filters"       $PRINT_PADDING
                BuildTaskHelpLine "<none>" cmd      "<none>"   "for commands"               $PRINT_PADDING
                BuildTaskHelpLine "<none>" dep      "<none>"   "for dependencies"           $PRINT_PADDING
                BuildTaskHelpLine "<none>" es       "<none>"   "for exit status"            $PRINT_PADDING
                BuildTaskHelpLine "<none>" opt      "<none>"   "for options"                $PRINT_PADDING
                BuildTaskHelpLine "<none>" ov       "<none>"   "overview"                   $PRINT_PADDING
                BuildTaskHelpLine "<none>" param    "<none>"   "for parameters"             $PRINT_PADDING
                BuildTaskHelpLine "<none>" scn      "<none>"   "for scenarios"              $PRINT_PADDING
                BuildTaskHelpLine "<none>" task     "<none>"   "for tasks"                  $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -P | --print-mode)
            PRINT_MODE="$2"
            shift 2
            ;;

        -a | --all)
            ALL=yes
            CLI_SET=true
            shift
            ;;
        --cmd)
            COMMANDS=yes
            CLI_SET=true
            shift
            ;;
        --dep)
            DEPENDENCIES=yes
            CLI_SET=true
            shift
            ;;
        --es)
            EXITSTATUS=yes
            CLI_SET=true
            shift
            ;;
        --opt)
            OPTIONS=yes
            CLI_SET=true
            shift
            ;;
        --ov)
            OVERVIEW=yes
            CLI_SET=true
            shift
            ;;
        --param)
            PARAMETERS=yes
            CLI_SET=true
            shift
            ;;
        --scn)
            SCENARIOS=yes
            CLI_SET=true
            shift
            ;;
        --task)
            TASKS=yes
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "stats: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI
############################################################################################
if [[ ! -n "$PRINT_MODE" ]]; then
    PRINT_MODE=${CONFIG_MAP["PRINT_MODE"]}
fi
TARGET=$PRINT_MODE

if [[ "$ALL" == "yes" ]]; then
    COMMANDS=yes
    DEPENDENCIES=yes
    EXITSTATUS=yes
    OPTIONS=yes
    OVERVIEW=yes
    PARAMETERS=yes
    SCENARIOS=yes
    TASKS=yes
elif [[ $CLI_SET == false ]]; then
    OVERVIEW=yes
fi



############################################################################################
##
## ready to go
##
############################################################################################
ConsoleInfo "  -->" "stats: starting task"

if [[ "$OVERVIEW" == "yes" ]]; then
    DEP_TESTED=0
    for DEP in ${!RTMAP_DEP_STATUS[@]}; do
        case ${RTMAP_DEP_STATUS[$DEP]} in
            E | W | S)  DEP_TESTED=$((DEP_TESTED + 1)) ;;
        esac
    done

    COUNT_PARAM_DEFVAL=0
    for PARAM in ${!DMAP_PARAM_DEFVAL[@]}; do
        if [[ -n "${DMAP_PARAM_DEFVAL[$PARAM]:-}" ]]; then
            COUNT_PARAM_DEFVAL=$((COUNT_PARAM_DEFVAL + 1))
        fi
    done

    printf "\n  "
    PrintEffect bold Statistics
    printf "\n"
    printf "  ───────────────────────────────      ───────────────────────────────\n"
    printf "   Tasks declared:           % 3s        Scenarios declared:       % 3s\n" "${#DMAP_TASK_DECL[@]}"         "${#DMAP_SCN_DECL[@]}"
    printf "   Tasks loaded:             % 3s        Scenarios loaded:         % 3s\n" "${#RTMAP_TASK_LOADED[@]}"      "${#RTMAP_SCN_LOADED[@]}"
    printf "  ───────────────────────────────      ───────────────────────────────\n"
    printf "   Dependencies declared:    % 3s        Parameters declared:      % 3s\n" "${#DMAP_DEP_DECL[@]}"          "${#DMAP_PARAM_DECL[@]}"
    printf "   Dependencies requested:   % 3s        Parameters requested:     % 3s\n" "${#RTMAP_REQUESTED_DEP[@]}"    "${#RTMAP_REQUESTED_PARAM[@]}"
    printf "   Dependencies tested:      % 3s        Parameters w/default val: % 3s\n" "$DEP_TESTED"                   "$COUNT_PARAM_DEFVAL"
    printf "  ───────────────────────────────      ───────────────────────────────\n"
    printf "   Configuration settings:   % 3s        Exit Status:              % 3s\n" "${#CONFIG_MAP[@]}"             "${#DMAP_ES[@]}"
    printf "   Options:                  % 3s        Commands:                 % 3s\n" "${#DMAP_OPT_ORIGIN[@]}"        "${#DMAP_CMD[@]}"
    printf "  ───────────────────────────────      ───────────────────────────────\n"
    printf "\n"
fi

if [[ "$OPTIONS" == "yes" ]]; then
    COUNT_OPT_ARG=0
    for OPT in ${!DMAP_OPT_ARG[@]}; do
        if [[ -n "${DMAP_OPT_ARG[$OPT]:-}" ]]; then
            COUNT_OPT_ARG=$((COUNT_OPT_ARG + 1))
        fi
    done
    COUNT_OPT_EXIT=0
    COUNT_OPT_RUN=0
    for OPT in ${!DMAP_OPT_ORIGIN[@]}; do
        if [[ "${DMAP_OPT_ORIGIN[$OPT]}" == "exit" ]]; then
            COUNT_OPT_EXIT=$((COUNT_OPT_EXIT + 1))
        fi
        if [[ "${DMAP_OPT_ORIGIN[$OPT]}" == "run" ]]; then
            COUNT_OPT_RUN=$((COUNT_OPT_RUN + 1))
        fi
    done

    printf "\n  "
    PrintEffect bold "Options"
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_OPT_ORIGIN[@]}"
    printf "   - as exit option:         % 3s        - with short:             % 3s\n" "$COUNT_OPT_EXIT"   "${#DMAP_OPT_SHORT[@]}"
    printf "   - as runtime option:      % 3s        - with argument:          % 3s\n" "$COUNT_OPT_RUN"    "$COUNT_OPT_ARG"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
fi

if [[ "$PARAMETERS" == "yes" ]]; then 
    printf "\n  "
    PrintEffect bold "Parameters"
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_PARAM_ORIGIN[@]}"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
fi

if [[ "$TASKS" == "yes" ]]; then
    printf "\n  "
    PrintEffect bold "Tasks"
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_TASK_ORIGIN[@]}"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
fi

if [[ "$DEPENDENCIES" == "yes" ]]; then
    COUNT_DEP_FW=0
    COUNT_DEP_APP=0
    for DEP in ${!DMAP_DEP_ORIGIN[@]}; do
        if [[ "${DMAP_DEP_ORIGIN[$DEP]}" == "FW_HOME" ]]; then
            COUNT_DEP_FW=$((COUNT_DEP_FW + 1))
        fi
        if [[ "${DMAP_DEP_ORIGIN[$DEP]}" == "APP_HOME" ]]; then
            COUNT_DEP_APP=$((COUNT_DEP_APP + 1))
        fi
    done
    COUNT_DEP_REQ_DEP=0
    for DEP in ${!DMAP_DEP_REQ_DEP[@]}; do
        if [[ -n "${DMAP_DEP_REQ_DEP[$DEP]}" ]]; then
            COUNT_DEP_REQ_DEP=$((COUNT_DEP_REQ_DEP + 1))
        fi
    done

    DEP_TESTED=0
    DEP_NOT_TESTED=0
    COUNT_DEP_ERROR=0
    COUNT_DEP_WARN=0
    COUNT_DEP_SUCCESS=0
    for DEP in ${!RTMAP_DEP_STATUS[@]}; do
        case ${RTMAP_DEP_STATUS[$DEP]} in
            N)  DEP_NOT_TESTED=$((DEP_NOT_TESTED + 1)) ;;
            E)
                COUNT_DEP_ERROR=$((COUNT_DEP_ERROR + 1))
                DEP_TESTED=$((DEP_TESTED + 1))
                ;;
            W)
                COUNT_DEP_WARN=$((COUNT_DEP_WARN + 1))
                DEP_TESTED=$((DEP_TESTED + 1))
                ;;
            S)
                COUNT_DEP_SUCCESS=$((COUNT_DEP_SUCCESS + 1))
                DEP_TESTED=$((DEP_TESTED + 1))
                ;;
        esac
    done

    printf "\n  "
    PrintEffect bold "Dependencies"
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s        Not tested:               % 3s\n" "${#DMAP_DEP_ORIGIN[@]}"         "$DEP_NOT_TESTED"
    printf "   - origin: framework:      % 3s        Tested:                   % 3s\n" "$COUNT_DEP_FW"                  "$DEP_TESTED"
    printf "   - origin: app:            % 3s          -- with error:          % 3s\n" "$COUNT_DEP_APP"                 "$COUNT_DEP_ERROR"
    printf "   - requires dependency:    % 3s          -- with warning:        % 3s\n" "$COUNT_DEP_REQ_DEP"             "$COUNT_DEP_WARN"
    printf "   Requested:                % 3s          -- with success:        % 3s\n" "${#RTMAP_REQUESTED_DEP[@]}"     "$COUNT_DEP_SUCCESS"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
fi

if [[ "$COMMANDS" == "yes" ]]; then
    COUNT_CMD_ARG=0
    for CMD in ${!DMAP_CMD_ARG[@]}; do
        if [[ -n "${DMAP_CMD_ARG[$CMD]:-}" ]]; then
            COUNT_CMD_ARG=$((COUNT_CMD_ARG + 1))
        fi
    done

    printf "\n  "
    PrintEffect bold "Commands"
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s        - with short:             % 3s\n" "${#DMAP_CMD[@]}"   "${#DMAP_CMD_SHORT[@]}"
    printf "                                        - with argument:          % 3s\n"                      "$COUNT_CMD_ARG"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
fi

if [[ "$EXITSTATUS" == "yes" ]]; then
    COUNT_ES_ALL=0
    COUNT_ES_APP=0
    COUNT_ES_FW=0
    COUNT_ES_LOADER=0
    COUNT_ES_SHELL=0
    COUNT_ES_TASK=0
    for ES in ${!DMAP_ES[@]}; do
        case ${DMAP_ES[$ES]} in
            all)        COUNT_ES_ALL=$((COUNT_ES_ALL + 1)) ;;
            app)        COUNT_ES_APP=$((COUNT_ES_APP + 1)) ;;
            fw)         COUNT_ES_FW=$((COUNT_ES_FW + 1)) ;;
            loader)     COUNT_ES_LOADER=$((COUNT_ES_LOADER + 1)) ;;
            shell)      COUNT_ES_SHELL=$((COUNT_ES_SHELL + 1)) ;;
            task)       COUNT_ES_TASK=$((COUNT_ES_TASK + 1)) ;;
            *)          ConsoleError " ->" "stats/exit-status - unknown origin '${DMAP_ES[$ES]}'"
        esac
    done

    COUNT_ES_INT=0
    COUNT_ES_EXT=0
    for ES in ${!DMAP_ES_PROBLEM[@]}; do
        case ${DMAP_ES_PROBLEM[$ES]} in
            external)   COUNT_ES_INT=$((COUNT_ES_INT + 1)) ;;
            internal)   COUNT_ES_EXT=$((COUNT_ES_EXT + 1)) ;;
            *)          ConsoleError " ->" "stats/exit-status - unknown '${DMAP_ES_PROBLEM[$ES]}'"
        esac
    done

    printf "\n  "
    PrintEffect bold "Exit Status"
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_ES[@]}"
    printf "   - origin: all:            % 3s        - internal problem:       % 3s\n" "$COUNT_ES_ALL"     "$COUNT_ES_INT"
    printf "   - origin: app:            % 3s        - external problem:       % 3s\n" "$COUNT_ES_APP"     "$COUNT_ES_EXT"
    printf "   - origin: framework:      % 3s\n"                                       "$COUNT_ES_FW"
    printf "   - origin: loader:         % 3s\n"                                       "$COUNT_ES_LOADER"
    printf "   - origin: shell:          % 3s\n"                                       "$COUNT_ES_SHELL"
    printf "   - origin: task:           % 3s\n"                                       "$COUNT_ES_TASK"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
fi

if [[ "$SCENARIOS" == "yes" ]]; then
    printf "\n  "
    PrintEffect bold "Scenarios"
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_SCN_ORIGIN[@]}"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
fi

ConsoleInfo "  -->" "stats: done"
exit $TASK_ERRORS
