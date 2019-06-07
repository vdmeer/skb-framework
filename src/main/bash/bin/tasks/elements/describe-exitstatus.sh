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
## describe-exitstatus - describes an exit-status or multiple of them
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
ES_ID=
ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=Ahi:P:
CLI_LONG_OPTIONS=all,help,id:,print-mode:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-exitstatus -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "describe-exitstatus: unknown CLI options"
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
            CACHED_HELP=$(TaskGetCachedHelp "describe-exitstatus")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"  $PRINT_PADDING
                printf "\n   filters\n"
                BuildTaskHelpLine A all         "<none>"    "all exit-status, disables all other filters"       $PRINT_PADDING
                BuildTaskHelpLine i id          "ID"        "exit-status identifier"                            $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -i | --id)
            ES_ID="$2"
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
            ConsolePrint fatal "describe-exitstatus: internal error (task): CLI parsing bug"
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
    ES_ID=
else
    if [[ -n "$ES_ID" ]]; then
        if [[ ! -n "${DMAP_ES[$ES_ID]:-}" ]]; then
            ConsolePrint error "des: unknown exit status ID '$ES_ID'"
            exit 60
        fi
    fi
fi


############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "des: starting task"

for ID in ${!DMAP_ES[@]}; do
    if [[ -n "$ES_ID" ]]; then
        if [[ ! "$ES_ID" == "$ID" ]]; then
            continue
        fi
    fi
    keys=(${keys[@]:-} $ID)
done
keys=($(printf '%s\n' "${keys[@]:-}"|sort))

for i in ${!keys[@]}; do
    ID=${keys[$i]}
    DescribeExitstatus $ID full "$PRINT_MODE line-indent" $PRINT_MODE
done

ConsolePrint info "des: done"
exit $TASK_ERRORS
