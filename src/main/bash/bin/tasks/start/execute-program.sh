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
## execute-program - executes a program with several options
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
XTERM=false
TITLE=
BACKGROUND=false
PROGRAM=
ARGS=


##
## set CLI options and parse CLI
##
CLI_OPTIONS=bhtx
CLI_LONG_OPTIONS=background,help,title:,xterm

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name execute-program -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "execute-program: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -b | --background)
            BACKGROUND=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "execute-program")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine b background  "<none>"    "run program in background"                     $PRINT_PADDING
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                    $PRINT_PADDING
                BuildTaskHelpLine t title       "TITLE"     "title for the XTerm, default: program name"    $PRINT_PADDING
                BuildTaskHelpLine x xterm       "<none>"    "start a new XTerm and execute program"         $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -t | --title)
            TITLE="$2"
            shift 2
            ;;
        -x | --xterm)
            XTERM=true
            shift
            ;;
        --)
            shift
            if [[ -z ${1:-} ]]; then
                break
            fi
            PROGRAM=$1
            shift
            ARGS=$(printf '%s' "$*")
            break
            ;;
        *)
            ConsolePrint fatal "execute-program: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
##
## ready to go
##
############################################################################################
ERRNO=0
ConsolePrint info "ep: starting task"

if [[ -z $PROGRAM ]]; then
    ConsolePrint error "ep: no program given to execute"
    exit 60
fi

if [[ $XTERM == true ]]; then
    if [[ ! -n "$TITLE" ]]; then
        TITLE=$PROGRAM
    fi
    if [[ ! -z "${RTMAP_TASK_LOADED["start-xterm"]}" ]]; then
        set +e
        ${DMAP_TASK_EXEC["start-xterm"]} --title $TITLE -- $PROGRAM $ARGS
        ERRNO=$?
        set -e
    else
        ConsolePrint error "ep: cannot start xterm, task 'start-xterm' not loaded"
        ConsolePrint info "ep: done"
        exit 61
    fi
else
    SCRIPT=$PROGRAM" "$ARGS
    if [[ $BACKGROUND == true ]]; then
        SCRIPT+=" &"
    fi
    set +e
    $SCRIPT
    ERRNO=$?
    set -e
fi

ConsolePrint info "ep: done"
exit $ERRNO
