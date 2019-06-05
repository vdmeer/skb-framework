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
## download-fw-tool - uses curl or wget to download the framework tool
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
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
ResetCounter errors
ResetCounter warnings


##
## set local variables
##
FORCE=false
SIMULATE=false
TOOL=curl



##
## set CLI options and parse CLI
##
CLI_OPTIONS=cfhsw
CLI_LONG_OPTIONS=curl,force,help,simulate,wget

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name download-fw-tool -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "download-fw-tool: unknown CLI options"
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
                printf "\n   tools\n"
                BuildTaskHelpLine c curl        "<none>"    "use 'curl' for download, default tool"                 $PRINT_PADDING
                BuildTaskHelpLine w wget        "<none>"    "use 'wget' for download"                               $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -c | --curl)
            shift
            TOOL=curl
            ;;
        -f | --force)
            shift
            FORCE=true
            ;;
        -s | --simulate)
            shift
            SIMULATE=true
            ;;
        -w | --wget)
            shift
            TOOL=wget
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "download-fw-tool: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI and settings
############################################################################################
case $TOOL in
    curl)
        if [[ "${RTMAP_DEP_STATUS["curl"]}" != "S" ]]; then
            ConsolePrint error "dfwt: dependency 'curl' requested but not loaded, cannot proceed"
            exit 60
        fi
        ;;
    wget)
        if [[ "${RTMAP_DEP_STATUS["wget"]}" != "S" ]]; then
            ConsolePrint error "dfwt: dependency 'wget' requested but not loaded, cannot proceed"
            exit 61
        fi
        ;;
    *)
        ConsolePrint error "dfwt: unknwon tool '$TOOL'"
        exit 62
        ;;
esac



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "dfwt: starting task"
ResetCounter errors

FW_TOOL_FILE="${CONFIG_MAP[SKB_FW_TOOL]}"
ConsolePrint debug "FW Tool file: $FW_TOOL_FILE"
if [[ -f "$FW_TOOL_FILE" && $SIMULATE == true ]]; then
    ConsolePrint message "  -> dfwt/simulate: tool file exists\n"
elif [[ -f "$FW_TOOL_FILE" && $FORCE == false ]]; then
    ConsolePrint warn "dfwt: tool file exists, use --force to overwrite"
    ConsolePrint message "  dfwt: tool file exists, use --force to overwrite"
    exit 0
fi

ConsolePrint info "create directory: ${CONFIG_MAP["FW_HOME"]}/lib/java"
if [[ ! -d "${CONFIG_MAP["FW_HOME"]}/lib/java" && $SIMULATE == true ]]; then
    ConsolePrint message "  -> dfwt/simulate: create directory: ${CONFIG_MAP["FW_HOME"]}/lib/java\n"
elif [[ ! -d "${CONFIG_MAP["FW_HOME"]}/lib/java" ]]; then
    mkdir -p ${CONFIG_MAP["FW_HOME"]}/lib/java
fi
if [[ ! -d "${CONFIG_MAP["FW_HOME"]}/lib/java" ]]; then
    ConsolePrint error "dfwt: lib directory ${CONFIG_MAP["FW_HOME"]}/lib/java does not exist"
    exit 63
fi

ConsolePrint info "calling $TOOL"
URL="https://dl.bintray.com/vdmeer/generic/${FW_TOOL_FILE##*/}"
ConsolePrint debug "URL: $URL"
case $TOOL in
    curl)
        if [[ $SIMULATE == true ]]; then
            ConsolePrint message "  -> dfwt/simulate: (cd ${CONFIG_MAP["FW_HOME"]}/lib/java; curl -L \"${URL}\" --output ${FW_TOOL_FILE##*/})\n"
        else
            (cd ${CONFIG_MAP["FW_HOME"]}/lib/java; curl -L "${URL}" --output ${FW_TOOL_FILE##*/})
        fi
        ;;
    wget)
        if [[ $SIMULATE == true ]]; then
            ConsolePrint message "  -> dfwt/simulate: (cd ${CONFIG_MAP["FW_HOME"]}/lib/java; wget ${URL})\n"
        else
            (cd ${CONFIG_MAP["FW_HOME"]}/lib/java; wget ${URL})
        fi
        ;;
esac

ConsolePrint info "dfwt: done"
exit $TASK_ERRORS
