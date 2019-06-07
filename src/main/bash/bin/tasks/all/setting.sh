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
## setting - change setting
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
CHANGE_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=hp:sS:T:
CLI_LONG_OPTIONS=help
CLI_LONG_OPTIONS+=,pm:,shell-level:,snp,sq,strict,task-level:,tq

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name setting -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "setting: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "setting")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                $PRINT_PADDING

                printf "\n   options for changing settings\n"
                BuildTaskHelpLine p         pm              "MODE"      "print mode to: ansi, text, text-anon"          $PRINT_PADDING
                BuildTaskHelpLine S         shell-level     "LEVEL"     "change shell level to LEVEL"                   $PRINT_PADDING
                BuildTaskHelpLine "<none>"  snp             "<none>"    "toggle shell prompt mode"          $PRINT_PADDING
                BuildTaskHelpLine "<none>"  sq              "<none>"    "toggle shell quiet mode"           $PRINT_PADDING
                BuildTaskHelpLine s         strict          "<none>"    "toggle strict mode"                $PRINT_PADDING
                BuildTaskHelpLine T         task-level      "LEVEL"     "change task level to LEVEL"        $PRINT_PADDING
                BuildTaskHelpLine "<none>"  tq              "<none>"    "toggle task quiet mode"            $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -p | --pm)
            case "$2" in
                ansi | text | text-anon)
                    CONFIG_MAP["PRINT_MODE"]=$2
                    ConsolePrint message "  set print mode to ${CONFIG_MAP["PRINT_MODE"]}\n"
                    CHANGE_SET=true
                    ;;
                *)
                    ConsolePrint error "setting: unknown print mode '$2'"
                    ;;
            esac
            shift 2
            ;;
        -S | --shell-level)
            case "$2" in
                all | fatal | error | warn-strict | warn | info | debug | trace | off)
                    CONFIG_MAP["SHELL_LEVEL"]=$2
                    ConsolePrint message "  set shell level to ${CONFIG_MAP["SHELL_LEVEL"]}\n"
                    CHANGE_SET=true
                    ;;
                *)
                    ConsolePrint error "setting: unknown shell level '$2'"
                    ;;
            esac
            shift 2
            ;;
        --snp)
            if [[ "${CONFIG_MAP["SHELL_SNP"]}" == "off" ]]; then
                CONFIG_MAP["SHELL_SNP"]="on"
            else
                CONFIG_MAP["SHELL_SNP"]="off"
            fi
            ConsolePrint message "  set shell prompt mode to ${CONFIG_MAP["SHELL_SNP"]}\n"
            CHANGE_SET=true
            shift
            ;;
        --sq)
            if [[ "${CONFIG_MAP["SHELL_QUIET"]}" == "off" ]]; then
                CONFIG_MAP["SHELL_QUIET"]="on"
            else
                CONFIG_MAP["SHELL_QUIET"]="off"
            fi
            ConsolePrint message "  set shell quiet mode to ${CONFIG_MAP["SHELL_QUIET"]}\n"
            CHANGE_SET=true
            shift
            ;;
        -s | --strict)
            if [[ "${CONFIG_MAP["STRICT"]}" == "off" ]]; then
                CONFIG_MAP["STRICT"]="on"
            else
                CONFIG_MAP["STRICT"]="off"
            fi
            ConsolePrint message "  set strict to ${CONFIG_MAP["STRICT"]}\n"
            CHANGE_SET=true
            shift
            ;;
        -T | --task-level)
            case "$2" in
                all | fatal | error | warn-strict | warn | info | debug | trace | off)
                    CONFIG_MAP["TASK_LEVEL"]=$2
                    ConsolePrint message "  set task level to ${CONFIG_MAP["TASK_LEVEL"]}\n"
                    CHANGE_SET=true
                    ;;
                *)
                    ConsolePrint error "setting: unknown task level '$2'"
                    ;;
            esac
            shift 2
            ;;
        --tq)
            if [[ "${CONFIG_MAP["TASK_QUIET"]}" == "off" ]]; then
                CONFIG_MAP["TASK_QUIET"]="on"
            else
                CONFIG_MAP["TASK_QUIET"]="off"
            fi
            ConsolePrint message "  set task quiet mode to ${CONFIG_MAP["TASK_QUIET"]}\n"
            CHANGE_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "setting: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "set: starting task"

if [[ $CHANGE_SET == true ]]; then
    WriteRuntimeConfig
    ConsolePrint debug "wrote L1 configuration due to settings changes"
fi

ConsolePrint info "set: done"
exit $TASK_ERRORS
