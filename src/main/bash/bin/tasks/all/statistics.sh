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
COMMANDS=
DEPENDENCIES=
ERRORCODES=
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
CLI_OPTIONS=AhP:cdeopst
CLI_LONG_OPTIONS=all,help,print-mode:
CLI_LONG_OPTIONS+=,all,ov,cmd,dep,ec,opt,param,scn,task

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name statistics -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "statistics: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "statistics")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start options
                printf "   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"  $PRINT_PADDING
                BuildTaskHelpTag end options

                printf "\n"
                BuildTaskHelpTag start filters
                printf "   filters\n"
                BuildTaskHelpLine A all             "<none>"   "activate all filters"       $PRINT_PADDING
                BuildTaskHelpLine c cmd             "<none>"   "for commands"               $PRINT_PADDING
                BuildTaskHelpLine d dep             "<none>"   "for dependencies"           $PRINT_PADDING
                BuildTaskHelpLine e ec              "<none>"   "for error codes"            $PRINT_PADDING
                BuildTaskHelpLine o opt             "<none>"   "for options"                $PRINT_PADDING
                BuildTaskHelpLine "<none>" ov       "<none>"   "overview"                   $PRINT_PADDING
                BuildTaskHelpLine p param           "<none>"   "for parameters"             $PRINT_PADDING
                BuildTaskHelpLine s scn             "<none>"   "for scenarios"              $PRINT_PADDING
                BuildTaskHelpLine t task            "<none>"   "for tasks"                  $PRINT_PADDING
                BuildTaskHelpTag end filters
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -P | --print-mode)
            PRINT_MODE="$2"
            shift 2
            ;;

        -A | --all)
            ALL=yes
            CLI_SET=true
            shift
            ;;
        -c | --cmd)
            COMMANDS=yes
            CLI_SET=true
            shift
            ;;
        -d | --dep)
            DEPENDENCIES=yes
            CLI_SET=true
            shift
            ;;
        -e | --ec)
            ERRORCODES=yes
            CLI_SET=true
            shift
            ;;
        -o | --opt)
            OPTIONS=yes
            CLI_SET=true
            shift
            ;;
        --ov)
            OVERVIEW=yes
            CLI_SET=true
            shift
            ;;
        -p | --param)
            PARAMETERS=yes
            CLI_SET=true
            shift
            ;;
        -s | --scn)
            SCENARIOS=yes
            CLI_SET=true
            shift
            ;;
        -t | --task)
            TASKS=yes
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "statistics: internal error (task): CLI parsing bug"
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
    COMMANDS=yes
    DEPENDENCIES=yes
    ERRORCODES=yes
    OPTIONS=yes
    OVERVIEW=yes
    PARAMETERS=yes
    SCENARIOS=yes
    TASKS=yes
elif [[ $CLI_SET == false ]]; then
    OVERVIEW=yes
fi



############################################################################################
## statistics OVERVIEW
############################################################################################
StatsOverview(){
    local DEP_TESTED=0
    for DEP in ${!RTMAP_DEP_STATUS[@]}; do
        case ${RTMAP_DEP_STATUS[$DEP]} in
            E | W | S)  DEP_TESTED=$((DEP_TESTED + 1)) ;;
        esac
    done

    local COUNT_PARAM_DEFVAL=0
    for PARAM in ${!DMAP_PARAM_DEFVAL[@]}; do
        if [[ -n "${DMAP_PARAM_DEFVAL[$PARAM]:-}" ]]; then
            COUNT_PARAM_DEFVAL=$((COUNT_PARAM_DEFVAL + 1))
        fi
    done

    printf "\n  "
    PrintEffect bold Statistics $PRINT_MODE
    printf "\n"
    printf "  ───────────────────────────────      ───────────────────────────────\n"
    printf "   Tasks declared:           % 3s        Scenarios declared:       % 3s\n" "${#DMAP_TASK_DECL[@]}"         "${#DMAP_SCN_DECL[@]}"
    printf "   Tasks loaded:             % 3s        Scenarios loaded:         % 3s\n" "${#RTMAP_TASK_LOADED[@]}"      "${#RTMAP_SCN_LOADED[@]}"
    printf "  ───────────────────────────────      ───────────────────────────────\n"
    printf "   Dependencies declared:    % 3s        Parameters declared:      % 3s\n" "${#DMAP_DEP_DECL[@]}"          "${#DMAP_PARAM_DECL[@]}"
    printf "   Dependencies requested:   % 3s        Parameters requested:     % 3s\n" "${#RTMAP_REQUESTED_DEP[@]}"    "${#RTMAP_REQUESTED_PARAM[@]}"
    printf "   Dependencies tested:      % 3s        Parameters w/default val: % 3s\n" "$DEP_TESTED"                   "$COUNT_PARAM_DEFVAL"
    printf "  ───────────────────────────────      ───────────────────────────────\n"
    printf "   Configuration settings:   % 3s        Error Codes:              % 3s\n" "${#CONFIG_MAP[@]}"             "${#DMAP_EC[@]}"
    printf "   Options:                  % 3s        Commands:                 % 3s\n" "${#DMAP_OPT_ORIGIN[@]}"        "${#DMAP_CMD[@]}"
    printf "  ───────────────────────────────      ───────────────────────────────\n"
    printf "\n"
}



############################################################################################
## statistics COMMANDS
############################################################################################
StatsCommands(){
    local COUNT_CMD_ARG=0
    for CMD in ${!DMAP_CMD_ARG[@]}; do
        if [[ -n "${DMAP_CMD_ARG[$CMD]:-}" ]]; then
            COUNT_CMD_ARG=$((COUNT_CMD_ARG + 1))
        fi
    done

    printf "\n  "
    PrintEffect bold Commands $PRINT_MODE
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s        - with short:             % 3s\n" "${#DMAP_CMD[@]}"   "${#DMAP_CMD_SHORT[@]}"
    printf "                                        - with argument:          % 3s\n"                      "$COUNT_CMD_ARG"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
}



############################################################################################
## statistics DEPENDENCIES
############################################################################################
StatsDependencies(){
    local COUNT_DEP_FW=0
    local COUNT_DEP_APP=0
    for DEP in ${!DMAP_DEP_ORIGIN[@]}; do
        if [[ "${DMAP_DEP_ORIGIN[$DEP]}" == "FW_HOME" ]]; then
            COUNT_DEP_FW=$((COUNT_DEP_FW + 1))
        fi
        if [[ "${DMAP_DEP_ORIGIN[$DEP]}" == "APP_HOME" ]]; then
            COUNT_DEP_APP=$((COUNT_DEP_APP + 1))
        fi
    done

    local COUNT_DEP_REQ_DEP=0
    for DEP in ${!DMAP_DEP_REQ_DEP[@]}; do
        if [[ -n "${DMAP_DEP_REQ_DEP[$DEP]}" ]]; then
            COUNT_DEP_REQ_DEP=$((COUNT_DEP_REQ_DEP + 1))
        fi
    done

    local DEP_TESTED=0
    local DEP_NOT_TESTED=0
    local COUNT_DEP_ERROR=0
    local COUNT_DEP_WARN=0
    local COUNT_DEP_SUCCESS=0
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
    PrintEffect bold Dependencies $PRINT_MODE
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s        Not tested:               % 3s\n" "${#DMAP_DEP_ORIGIN[@]}"         "$DEP_NOT_TESTED"
    printf "   - origin: framework:      % 3s        Tested:                   % 3s\n" "$COUNT_DEP_FW"                  "$DEP_TESTED"
    printf "   - origin: app:            % 3s          -- with error:          % 3s\n" "$COUNT_DEP_APP"                 "$COUNT_DEP_ERROR"
    printf "   - requires dependency:    % 3s          -- with warning:        % 3s\n" "$COUNT_DEP_REQ_DEP"             "$COUNT_DEP_WARN"
    printf "   Requested:                % 3s          -- with success:        % 3s\n" "${#RTMAP_REQUESTED_DEP[@]}"     "$COUNT_DEP_SUCCESS"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
}



############################################################################################
## statistics ERRORCODES
############################################################################################
StatsErrorcodes(){
    local COUNT_EC_ALL=0
    local COUNT_EC_APP=0
    local COUNT_EC_FW=0
    local COUNT_EC_LOADER=0
    local COUNT_EC_SHELL=0
    local COUNT_EC_TASK=0
    for ES in ${!DMAP_EC[@]}; do
        case ${DMAP_EC[$ES]} in
            all)        COUNT_EC_ALL=$((COUNT_EC_ALL + 1)) ;;
            app)        COUNT_EC_APP=$((COUNT_EC_APP + 1)) ;;
            fw)         COUNT_EC_FW=$((COUNT_EC_FW + 1)) ;;
            loader)     COUNT_EC_LOADER=$((COUNT_EC_LOADER + 1)) ;;
            shell)      COUNT_EC_SHELL=$((COUNT_EC_SHELL + 1)) ;;
            task)       COUNT_EC_TASK=$((COUNT_EC_TASK + 1)) ;;
            *)          ConsolePrint error "stats/errorcodes - unknown origin '${DMAP_EC[$ES]}'"
        esac
    done

    local COUNT_EC_INT=0
    local COUNT_EC_EXT=0
    for ES in ${!DMAP_EC_PROBLEM[@]}; do
        case ${DMAP_EC_PROBLEM[$ES]} in
            external)   COUNT_EC_INT=$((COUNT_EC_INT + 1)) ;;
            internal)   COUNT_EC_EXT=$((COUNT_EC_EXT + 1)) ;;
            *)          ConsolePrint error "stats/errorcodes - unknown '${DMAP_EC_PROBLEM[$ES]}'"
        esac
    done

    printf "\n  "
    PrintEffect bold "Error Codes" $PRINT_MODE
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_EC[@]}"
    printf "   - origin: all:            % 3s        - internal problem:       % 3s\n" "$COUNT_EC_ALL"     "$COUNT_EC_INT"
    printf "   - origin: app:            % 3s        - external problem:       % 3s\n" "$COUNT_EC_APP"     "$COUNT_EC_EXT"
    printf "   - origin: framework:      % 3s\n"                                       "$COUNT_EC_FW"
    printf "   - origin: loader:         % 3s\n"                                       "$COUNT_EC_LOADER"
    printf "   - origin: shell:          % 3s\n"                                       "$COUNT_EC_SHELL"
    printf "   - origin: task:           % 3s\n"                                       "$COUNT_EC_TASK"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
}



############################################################################################
## statistics OPTIONS
############################################################################################
StatsOptions(){
    local COUNT_OPT_ARG=0
    for OPT in ${!DMAP_OPT_ARG[@]}; do
        if [[ -n "${DMAP_OPT_ARG[$OPT]:-}" ]]; then
            COUNT_OPT_ARG=$((COUNT_OPT_ARG + 1))
        fi
    done

    local COUNT_OPT_EXIT=0
    local COUNT_OPT_RUN=0
    for OPT in ${!DMAP_OPT_ORIGIN[@]}; do
        if [[ "${DMAP_OPT_ORIGIN[$OPT]}" == "exit" ]]; then
            COUNT_OPT_EXIT=$((COUNT_OPT_EXIT + 1))
        fi
        if [[ "${DMAP_OPT_ORIGIN[$OPT]}" == "run" ]]; then
            COUNT_OPT_RUN=$((COUNT_OPT_RUN + 1))
        fi
    done

    printf "\n  "
    PrintEffect bold Options $PRINT_MODE
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_OPT_ORIGIN[@]}"
    printf "   - as exit option:         % 3s        - with short:             % 3s\n" "$COUNT_OPT_EXIT"   "${#DMAP_OPT_SHORT[@]}"
    printf "   - as runtime option:      % 3s        - with argument:          % 3s\n" "$COUNT_OPT_RUN"    "$COUNT_OPT_ARG"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
}



############################################################################################
## statistics PARAMETERS
############################################################################################
StatsParameters(){
    local COUNT_PARAM_DEFVAL=0
    for PARAM in ${!DMAP_PARAM_DEFVAL[@]}; do
        if [[ -n "${DMAP_PARAM_DEFVAL[$PARAM]:-}" ]]; then
            COUNT_PARAM_DEFVAL=$((COUNT_PARAM_DEFVAL + 1))
        fi
    done

    local COUNT_PARAM_FW=0
    local COUNT_PARAM_APP=0
    for PARAM in ${!DMAP_PARAM_ORIGIN[@]}; do
        if [[ "${DMAP_PARAM_ORIGIN[$PARAM]}" == "FW_HOME" ]]; then
            COUNT_PARAM_FW=$((COUNT_PARAM_FW + 1))
        fi
        if [[ "${DMAP_PARAM_ORIGIN[$PARAM]}" == "APP_HOME" ]]; then
            COUNT_PARAM_APP=$((COUNT_PARAM_APP + 1))
        fi
    done

    local COUNT_PARAM_SET=0
    local COUNT_PARAM_SET_NOT=0
    local COUNT_PARAM_SET_OPTION=0
    local COUNT_PARAM_SET_ENV=0
    local COUNT_PARAM_SET_FILE=0
    local COUNT_PARAM_SET_DEFVAL=0
    for PARAM in ${!DMAP_PARAM_ORIGIN[@]}; do
        if [[ -z "${CONFIG_SRC[$PARAM]:-}" ]]; then
            COUNT_PARAM_SET_NOT=$((COUNT_PARAM_SET_NOT + 1))
        else
            case ${CONFIG_SRC[$PARAM]} in
                O)
                    COUNT_PARAM_SET=$((COUNT_PARAM_SET + 1))
                    COUNT_PARAM_SET_OPTION=$((COUNT_PARAM_SET_OPTION + 1))
                    ;;
                E)
                    COUNT_PARAM_SET=$((COUNT_PARAM_SET + 1))
                    COUNT_PARAM_SET_ENV=$((COUNT_PARAM_SET_ENV + 1))
                    ;;
                F)
                    COUNT_PARAM_SET=$((COUNT_PARAM_SET + 1))
                    COUNT_PARAM_SET_FILE=$((COUNT_PARAM_SET_FILE + 1))
                    ;;
                D)
                    COUNT_PARAM_SET=$((COUNT_PARAM_SET + 1))
                    COUNT_PARAM_SET_DEFVAL=$((COUNT_PARAM_SET_DEFVAL + 1))
                    ;;
            esac
        fi
    done

    printf "\n  "
    PrintEffect bold Parameters $PRINT_MODE
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_PARAM_ORIGIN[@]}"
    printf "   - with default value:     % 3s        Values set:               % 3s\n" "$COUNT_PARAM_DEFVAL"            "$COUNT_PARAM_SET"
    printf "   - origin: framework:      % 3s        - from option:            % 3s\n" "$COUNT_PARAM_FW"                "$COUNT_PARAM_SET_OPTION"
    printf "   - origin: app:            % 3s        - from environment:       % 3s\n" "$COUNT_PARAM_APP"               "$COUNT_PARAM_SET_ENV"
    printf "   Requested                 % 3s        - from file:              % 3s\n" "${#RTMAP_REQUESTED_PARAM[@]}"   "$COUNT_PARAM_SET_FILE"
    printf "   Not set                   % 3s        - as default value:       % 3s\n" "$COUNT_PARAM_SET_NOT"           "$COUNT_PARAM_SET_DEFVAL"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
}



############################################################################################
## statistics TASKS
############################################################################################
StatsTasks(){
    local COUNT_TASK_FW=0
    local COUNT_TASK_APP=0
    local COUNT_TASK_DEV=0
    local COUNT_TASK_BUILD=0
    local COUNT_TASK_USE=0
    local COUNT_TASK_LOAD_N=0
    local COUNT_TASK_LOAD_E=0
    local COUNT_TASK_LOAD_W=0
    local COUNT_TASK_LOAD_S=0
    for TASK in ${!DMAP_TASK_ORIGIN[@]}; do
        if [[ "${DMAP_TASK_ORIGIN[$TASK]}" == "FW_HOME" ]]; then
            COUNT_TASK_FW=$((COUNT_TASK_FW + 1))
        fi
        if [[ "${DMAP_TASK_ORIGIN[$TASK]}" == "APP_HOME" ]]; then
            COUNT_TASK_APP=$((COUNT_TASK_APP + 1))
        fi

        case "${DMAP_TASK_MODES[$TASK]}" in
            *dev*)      COUNT_TASK_DEV=$((COUNT_TASK_DEV + 1)) ;;
        esac
        case "${DMAP_TASK_MODES[$TASK]}" in
            *build*)    COUNT_TASK_BUILD=$((COUNT_TASK_BUILD + 1)) ;;
        esac
        case "${DMAP_TASK_MODES[$TASK]}" in
            *use*)      COUNT_TASK_USE=$((COUNT_TASK_USE + 1)) ;;
        esac

        case ${RTMAP_TASK_STATUS[$TASK]} in
            N)      COUNT_TASK_LOAD_N=$((COUNT_TASK_LOAD_N + 1)) ;;
            E)      COUNT_TASK_LOAD_E=$((COUNT_TASK_LOAD_E + 1)) ;;
            W)      COUNT_TASK_LOAD_W=$((COUNT_TASK_LOAD_W + 1)) ;;
            S)      COUNT_TASK_LOAD_S=$((COUNT_TASK_LOAD_S + 1)) ;;
        esac
    done

    printf "\n  "
    PrintEffect bold Tasks $PRINT_MODE
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s        Not loaded:               % 3s\n" "${#DMAP_TASK_ORIGIN[@]}"        "$COUNT_TASK_LOAD_N"
    printf "   - origin: framework:      % 3s        Unloaded:                 % 3s\n" "$COUNT_TASK_FW"                 "$((${#RTMAP_TASK_UNLOADED[@]} -1))"
    printf "   - origin: app:            % 3s        Loaded:                   % 3s\n" "$COUNT_TASK_APP"                "${#RTMAP_TASK_LOADED[@]}"
    printf "   - mode: dev:              % 3s        - errors:                 % 3s\n" "$COUNT_TASK_DEV"                "$COUNT_TASK_LOAD_E"
    printf "   - mode: build:            % 3s        - warnings:               % 3s\n" "$COUNT_TASK_BUILD"              "$COUNT_TASK_LOAD_W"
    printf "   - mode: use:              % 3s        - success:                % 3s\n" "$COUNT_TASK_USE"                "$COUNT_TASK_LOAD_S"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
}



############################################################################################
## statistics SCENARIOS
############################################################################################
StatsScenarios(){
    printf "\n  "
    PrintEffect bold Scenarios $PRINT_MODE
    printf "\n"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "   Declared:                 % 3s\n" "${#DMAP_SCN_ORIGIN[@]}"
    printf "  ────────────────────────────────────────────────────────────────────\n"
    printf "\n"
}



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "stats: starting task"

if [[ "$OVERVIEW" == "yes" ]]; then
    StatsOverview
fi

if [[ "$COMMANDS" == "yes" ]]; then
    StatsCommands
fi

if [[ "$DEPENDENCIES" == "yes" ]]; then
    StatsDependencies
fi

if [[ "$ERRORCODES" == "yes" ]]; then
    StatsErrorcodes
fi

if [[ "$OPTIONS" == "yes" ]]; then
    StatsOptions
fi

if [[ "$PARAMETERS" == "yes" ]]; then 
    StatsParameters
fi

if [[ "$TASKS" == "yes" ]]; then
    StatsTasks
fi

if [[ "$SCENARIOS" == "yes" ]]; then
    StatsScenarios
fi

ConsolePrint info "stats: done"
exit $TASK_ERRORS
