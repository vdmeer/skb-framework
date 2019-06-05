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
## make-target-sets - runs build on one or more specified target sets
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
DO_CLEAN=false
DO_LIST=false
DO_TARGETS=
ALL=
TARGET_SET_ID=



##
## set CLI options and parse CLI
##
CLI_OPTIONS=Achi:lt:
CLI_LONG_OPTIONS=all,clean,help,id:,list
CLI_LONG_OPTIONS+=,targets:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name make-target-sets -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "make-target-sets: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=24
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "make-target-sets")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine c clean   "<none>"        "cleans target set(s) (all or given ID)"    $PRINT_PADDING
                BuildTaskHelpLine h help    "<none>"        "print help screen and exit"                $PRINT_PADDING
                BuildTaskHelpLine l list    "<none>"        "list target sets"                          $PRINT_PADDING
                BuildTaskHelpLine t targets "<targets>"     "list of targets, separated by comma"       $PRINT_PADDING

                printf "\n   filters\n"
                BuildTaskHelpLine A all     "<none>"    "all target sets"                               $PRINT_PADDING
                BuildTaskHelpLine i id      "ID"        "target set identifier for building"            $PRINT_PADDING
                printf "\n   Notes\n"
                printf "For all available targets use target 'all'\n"

            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -A | --all)
            ALL=yes
            shift
            ;;
        -c | --clean)
            DO_CLEAN=true
            shift
            ;;
        -i | --id)
            TARGET_SET_ID="$2"
            shift 2
            ;;
        -l | --list)
            DO_LIST=true
            shift
            ;;

        -t | --targets)
            DO_TARGETS="$2"
            shift 2
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "make-target-sets: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI and settings
############################################################################################
if [[ -z "${CONFIG_MAP["MAKE_TARGET_SETS"]:-}" ]]; then
    ConsolePrint error "mts: no settings found for MAKE_TARGET_SETS, cannot proceed"
    exit 61
fi



############################################################################################
## local print functions: $1 TS ID, $2 message (target list or single target)
############################################################################################
PrintTargetsetStart(){
    local SPRINT

    case $LEVEL in
        all | info | debug | trace)
            printf "\n\n        ========================================\n\n" 1>&2
            printf "        [" 1>&2
            SPRINT=$(PrintColor light-green "$1")
            printf %b "$SPRINT" 1>&2
            printf "] - building targets: %s" "$2"
            printf "\n" 1>&2
            ;;
        *)
            ;;
    esac
}

PrintTargetsetEnd(){
    local SPRINT

    case $LEVEL in
        all | info | debug | trace)
            printf "\n        [" 1>&2
            SPRINT=$(PrintColor light-green "$1")
            printf %b "$SPRINT" 1>&2
            printf "] - finished targets: %s" "$2" 1>&2
            printf "\n\n        ========================================\n\n" 1>&2
            printf "\n" 1>&2
            ;;
        *)
            ;;
    esac
}

PrintTargetStart(){
    local SPRINT

    case $LEVEL in
        all | info | debug | trace)
            printf "\n\n" 1>&2
            printf "        [" 1>&2
            SPRINT=$(PrintColor light-green "$1")
            printf %b "$SPRINT" 1>&2
            printf "] - start %s" "$2" 1>&2
            printf "\n\n        ----------------------------------------\n\n" 1>&2
            ;;
        *)
            ;;
    esac
}

PrintTargetEnd(){
    local SPRINT

    case $LEVEL in
        all | info | debug | trace)
            printf "\n\n" 1>&2
            printf "        [" 1>&2
            SPRINT=$(PrintColor light-green "$1")
            printf %b "$SPRINT" 1>&2
            printf "] - finished %s" "$2" 1>&2
            printf "\n\n        ----------------------------------------\n\n" 1>&2
            ;;
        *)
            ;;
    esac
}



############################################################################################
## load target sets function
############################################################################################
LoadTargetsets(){
    local ID=
    local DESCRIPTION=
    local TARGETS=
    local HAVE_TARGET_CLEAN=false

    if [[ ! -d "$1" ]]; then
        ConsolePrint error "mts: not a directory: '$1'"
        return
    fi
    if [[ ! -f "$1/skb-ts.id" ]]; then
        ConsolePrint error "mts: no ID file in directory: '$1', looking for 'skb-ts'"
        return
    fi
    source $1/skb-ts.id

    if [[ -z "${ID:-}" ]]; then
        ConsolePrint error "mts: no ID in 'skb-ts' in directory '$1'"
        return
    fi
    if [[ -z "${DESCRIPTION:-}" ]]; then
        ConsolePrint error "mts: no DESCRIPTION in 'skb-ts' in directory '$1'"
        return
    fi
    if [[ -z "${TARGETS:-}" ]]; then
        ConsolePrint error "mts: no TARGETS in 'skb-ts' in directory '$1'"
        return
    fi

    for TGT in $TARGETS; do
        case $TGT in
            clean)
                HAVE_TARGET_CLEAN=true
                ;;
            *)
                ;;
        esac
    done

    if [[ ${HAVE_TARGET_CLEAN} == false ]]; then
        ConsolePrint error "mts: 'skb-ts' in directory '$1' does not define a target 'clean'"
        return
    fi

    TARGET_SET_TARGETS[$ID]=$TARGETS
    TARGET_SET_LIST[$ID]=$DESCRIPTION
    TARGET_SET_PATH[$ID]=$1

    if [[ ! -r ${TARGET_SET_PATH[$ID]}/skb-ts-scripts.skb ]]; then
        ConsolePrint error "mts: no script file in directory: '$1', looking for 'skb-ts-scripts'"
    fi

    ConsolePrint debug "found target set '$ID' described as '$DESCRIPTION'"
    ConsolePrint debug "found target set '$ID' with targets '$TARGETS'"
}



############################################################################################
## test targets function
############################################################################################
TestTargets(){
    local ID=$1

    if [[ "${DO_TARGETS}" == "all" ]]; then
        return
    fi

    FIELD_SEAPARATOR=$IFS
    IFS=,
    for TGT_USER in $DO_TARGETS; do
        IFS=$FIELD_SEAPARATOR
        FOUND=false
        for TGT in ${TARGET_SET_TARGETS[$ID]}; do
            if [[ "$TGT_USER" == "$TGT" ]]; then
                FOUND=true
            fi
        done
        if [[ $FOUND == false ]]; then
            ConsolePrint error "mts: requested target '$TGT_USER' not in target set '$ID'"
        fi
        IFS=,
    done
    IFS=$FIELD_SEAPARATOR
    ExitOnTaskErrors
}



############################################################################################
## build target set function
############################################################################################
BuildTargetSet(){
    local ID=$1
    source ${TARGET_SET_PATH[$ID]}/skb-ts-scripts.skb

    PrintTargetsetStart $ID $DO_TARGETS
    if [[ "${DO_TARGETS}" == "all" ]]; then
        for TGT in ${TARGET_SET_TARGETS[$ID]}; do
            PrintTargetStart $ID $TGT
            (cd ${TARGET_SET_PATH[$ID]}; TsRunTargets $TGT)
            PrintTargetEnd $ID $TGT
        done
    else
        FIELD_SEAPARATOR=$IFS
        for TGT in ${TARGET_SET_TARGETS[$ID]}; do
            IFS=,
            for TGT_USER in $DO_TARGETS; do
                if [[ "$TGT" == "$TGT_USER" ]]; then
                    PrintTargetStart $ID $TGT
                    (cd ${TARGET_SET_PATH[$ID]}; TsRunTargets $TGT)
                    PrintTargetEnd $ID $TGT
                    ExitOnTaskErrors
                fi
            done
            IFS=$FIELD_SEAPARATOR
        done
        PrintTargetsetEnd $ID $DO_TARGETS
        IFS=$FIELD_SEAPARATOR
    fi
    ExitOnTaskErrors
}



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "mts: starting task"
ResetCounter errors
LEVEL=${CONFIG_MAP["TASK_LEVEL"]}   ## get task level for local prints



declare -A TARGET_SET_LIST
declare -A TARGET_SET_PATH
declare -A TARGET_SET_TARGETS
for ts in ${CONFIG_MAP["MAKE_TARGET_SETS"]}; do
    LoadTargetsets $ts
done



if [[ -n "$TARGET_SET_ID" ]]; then
    if [[ -z "${TARGET_SET_LIST[$TARGET_SET_ID]:-}" ]]; then
        ConsolePrint error "mts: unknown target set ID '$TARGET_SET_ID'"
    fi
fi
ExitOnTaskErrors



if [[ $DO_LIST == true ]]; then
    printf "\n  Target Sets\n"
    for ID in ${!TARGET_SET_LIST[@]}; do
        printf "    - %s - %s - %s\n      --> with target(s): %s\n\n" "$ID" "${TARGET_SET_LIST[$ID]}" "${TARGET_SET_PATH[$ID]}" "${TARGET_SET_TARGETS[$ID]}"
    done
    printf "\n"
fi



if [[ $DO_CLEAN == true ]]; then
    if [[ "$ALL" == "yes" ]]; then
        for ID in ${!TARGET_SET_LIST[@]}; do
            PrintTargetStart $ID "clean"
            source ${TARGET_SET_PATH[$ID]}/skb-ts-scripts.skb
            (cd ${TARGET_SET_PATH[$ID]}; TsRunTargets clean)
            PrintTargetEnd $ID "clean"
        done
    elif [[ -n "$TARGET_SET_ID" ]]; then
        PrintTargetStart $ID "clean"
        source ${TARGET_SET_PATH[$TARGET_SET_ID]}/skb-ts-scripts.skb
        (cd ${TARGET_SET_PATH[$TARGET_SET_ID]}; TsRunTargets clean)
        PrintTargetEnd $ID "clean"
    else
        ConsolePrint error "mts: no target set given for clean, use --all or --id ID"
    fi
fi
ExitOnTaskErrors



## test all targets for all requested sets first
if [[ -n "${DO_TARGETS}" ]]; then
    if [[ "$ALL" == "yes" ]]; then
        for ID in ${!TARGET_SET_LIST[@]}; do
            TestTargets $ID
        done
    elif [[ -n "$TARGET_SET_ID" ]]; then
        TestTargets $TARGET_SET_ID
    else
        ConsolePrint error "mts: no target set given for targets, use --all or --id ID"
    fi
fi
ExitOnTaskErrors



## now build all targets for all requested target sets
if [[ -n "${DO_TARGETS}" ]]; then
    if [[ "$ALL" == "yes" ]]; then
        for ID in ${!TARGET_SET_LIST[@]}; do
            BuildTargetSet $ID
        done
    elif [[ -n "$TARGET_SET_ID" ]]; then
        BuildTargetSet $TARGET_SET_ID
    else
        ConsolePrint error "mts: no target set given for targets, use --all or --id ID"
    fi
fi

ConsolePrint info "mts: done"
exit $TASK_ERRORS
