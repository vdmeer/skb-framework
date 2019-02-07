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
## download-fw-tool - uses curl to download the framework tool
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.3
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##

## put bugs into errors, safer
set -o errexit -o pipefail -o noclobber -o nounset

## we want files recursivey
shopt -s globstar



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
source $FW_HOME/bin/api/describe/_include
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
FORCE=false
SIMULATE=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=fhs
CLI_LONG_OPTIONS=force,help,simulate

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name download-fw-tool -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "download-fw-tool: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "download-fw-tool")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine f force       "<none>"    "force download"                                        $PRINT_PADDING
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                            $PRINT_PADDING
                BuildTaskHelpLine s simulate    "<none>"    "print only, downloades nothing, overwrites force"      $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -f | --force)
            shift
            FORCE=true
            ;;
        -s | --simulate)
            shift
            SIMULATE=true
            ;;


        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "download-fw-tool: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI and settings
############################################################################################



############################################################################################
##
## ready to go
##
############################################################################################
ConsoleInfo "  -->" "dfwt: starting task"
ConsoleResetErrors

FW_TOOL_FILE="${CONFIG_MAP[SKB_FW_TOOL]}"
ConsoleDebug "FW Tool file: $FW_TOOL_FILE"
if [[ -f "$FW_TOOL_FILE" && $SIMULATE == true ]]; then
    ConsoleMessage "  -> dfwt/simulate: tool file exists\n"
elif [[ -f "$FW_TOOL_FILE" && $FORCE == false ]]; then
    ConsoleWarn " ->" "dfwt: tool file exists, use --force to overwrite"
    exit 0
fi

ConsoleInfo "  -->" "create directory: ${CONFIG_MAP["FW_HOME"]}/lib/java"
if [[ ! -d "${CONFIG_MAP["FW_HOME"]}/lib/java" && $SIMULATE == true ]]; then
    ConsoleMessage "  -> dfwt/simulate: create directory: ${CONFIG_MAP["FW_HOME"]}/lib/java\n"
elif [[ ! -d "${CONFIG_MAP["FW_HOME"]}/lib/java" ]]; then
    mkdir -p ${CONFIG_MAP["FW_HOME"]}/lib/java
fi
if [[ ! -d "${CONFIG_MAP["FW_HOME"]}/lib/java" ]]; then
    ConsoleError " ->" "dfwt: lib directory ${CONFIG_MAP["FW_HOME"]}/lib/java does not exist"
    exit 61
fi

ConsoleInfo "  -->" "calling curl"
CURL_URL="https://dl.bintray.com/vdmeer/generic/${FW_TOOL_FILE##*/}"
ConsoleDebug "curl URL: $CURL_URL"
if [[ $SIMULATE == true ]]; then
    ConsoleMessage "  -> dfwt/simulate: curl -L --output $FW_TOOL_FILE $CURL_URL\n"
else
    curl -L --output $FW_TOOL_FILE $CURL_URL
fi

ConsoleInfo "  -->" "dfwt: done"
exit $TASK_ERRORS
