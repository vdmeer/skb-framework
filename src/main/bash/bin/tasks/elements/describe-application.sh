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
## describe-application - describes the application
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
APP=
AUTHORS=
BUGS=
COPYING=
RESOURCES=
SECURITY=
ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AhP:
CLI_LONG_OPTIONS=all,help,print-mode:
CLI_LONG_OPTIONS+=,app,authors,bugs,copying,resources,security

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name describe-application -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "describe-application: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "describe-application")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"  $PRINT_PADDING

                printf "\n   filters\n"
                BuildTaskHelpLine A all               "<none>"   "all application aspects"              $PRINT_PADDING
                BuildTaskHelpLine "<none>" app        "<none>"   "include application description"      $PRINT_PADDING
                BuildTaskHelpLine "<none>" authors    "<none>"   "include authors"                      $PRINT_PADDING
                BuildTaskHelpLine "<none>" bugs       "<none>"   "include bugs"                         $PRINT_PADDING
                BuildTaskHelpLine "<none>" copying    "<none>"   "include copying"                      $PRINT_PADDING
                BuildTaskHelpLine "<none>" resources  "<none>"   "include resources"                    $PRINT_PADDING
                BuildTaskHelpLine "<none>" security   "<none>"   "include security"                     $PRINT_PADDING
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
        --app)
            APP=yes
            CLI_SET=true
            shift
            ;;
        --authors)
            AUTHORS=yes
            CLI_SET=true
            shift
            ;;
        --bugs)
            BUGS=yes
            CLI_SET=true
            shift
            ;;
        --copying)
            COPYING=yes
            CLI_SET=true
            shift
            ;;
        --resources)
            RESOURCES=yes
            CLI_SET=true
            shift
            ;;
        --security)
            SECURITY=yes
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "describe-application: internal error (task): CLI parsing bug"
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
    APP=yes
    AUTHORS=yes
    BUGS=yes
    COPYING=yes
    RESOURCES=yes
    SECURITY=yes
fi



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "da: starting task"

if [[ "$APP" == "yes" ]]; then
    DescribeApplication description $PRINT_MODE
fi

if [[ "$SECURITY" == "yes" ]]; then
    DescribeApplication security $PRINT_MODE
fi

if [[ "$BUGS" == "yes" ]]; then
    DescribeApplication bugs $PRINT_MODE
fi

if [[ "$AUTHORS" == "yes" ]]; then
    DescribeApplication authors $PRINT_MODE
fi

if [[ "$RESOURCES" == "yes" ]]; then
    DescribeApplication resources $PRINT_MODE
fi

if [[ "$COPYING" == "yes" ]]; then
    DescribeApplication copying $PRINT_MODE
fi

ConsolePrint info "da: done"
exit $TASK_ERRORS
