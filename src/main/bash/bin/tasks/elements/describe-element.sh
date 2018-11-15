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
## describe-element - describes the elements of an application
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.1
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
source $FW_HOME/bin/api/_include
source $FW_HOME/bin/api/describe/elements.sh
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
PARAMETERS=
SCENARIOS=
TASKS=
ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AhP:
CLI_LONG_OPTIONS=all,help,print-mode:
CLI_LONG_OPTIONS+=,cmd,dep,es,opt,param,scn,task

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-element -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "describe-element: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "describe-element")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"  $PRINT_PADDING

                printf "\n   filters\n"
                BuildTaskHelpLine A all             "<none>"   "all elements"               $PRINT_PADDING
                BuildTaskHelpLine "<none>" cmd      "<none>"   "include commands"           $PRINT_PADDING
                BuildTaskHelpLine "<none>" dep      "<none>"   "include dependencies"       $PRINT_PADDING
                BuildTaskHelpLine "<none>" es       "<none>"   "include exit status"        $PRINT_PADDING
                BuildTaskHelpLine "<none>" opt      "<none>"   "include options"            $PRINT_PADDING
                BuildTaskHelpLine "<none>" param    "<none>"   "include parameters"         $PRINT_PADDING
                BuildTaskHelpLine "<none>" scn      "<none>"   "include scenarios"          $PRINT_PADDING
                BuildTaskHelpLine "<none>" task     "<none>"   "include tasks "             $PRINT_PADDING
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
            ConsoleFatal "  ->" "describe-element: internal error (task): CLI parsing bug"
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

if [[ "$ALL" == "yes" || $CLI_SET == false ]]; then
    COMMANDS=yes
    DEPENDENCIES=yes
    EXITSTATUS=yes
    OPTIONS=yes
    PARAMETERS=yes
    SCENARIOS=yes
    TASKS=yes
fi



############################################################################################
##
## ready to go
##
############################################################################################
ConsoleInfo "  -->" "de: starting task"

if [[ "$OPTIONS" == "yes" ]]; then
    DescribeElementOptions
    DescribeElementOptionsRuntime
    DescribeElementOptionsExit
fi

if [[ "$PARAMETERS" == "yes" ]]; then 
    DescribeElementParameters
fi

if [[ "$TASKS" == "yes" ]]; then
    DescribeElementTasks
fi

if [[ "$DEPENDENCIES" == "yes" ]]; then
    DescribeElementDependencies
fi

if [[ "$COMMANDS" == "yes" ]]; then
    DescribeElementCommands
fi

if [[ "$EXITSTATUS" == "yes" ]]; then
    DescribeElementExitStatus
fi

if [[ "$SCENARIOS" == "yes" ]]; then
    DescribeElementScenarios
fi

ConsoleInfo "  -->" "de: done"
exit $TASK_ERRORS
