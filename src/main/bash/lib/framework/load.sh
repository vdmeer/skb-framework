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
## load - loads settings and other items once framework is started
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.1
##


set -o pipefail -o noclobber -o nounset
#set -o errexit 
#shopt -s globstar


printf "\n"
source ${SF_HOME}/lib/framework/Framework.sh
Report process message "loading and initializing"
Load framework completions

trap "rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"; exit" SIGHUP SIGQUIT SIGILL SIGTERM
trap "rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"; exit" SIGHUP SIGQUIT SIGILL SIGTERM
trap "rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"; exit" SIGHUP SIGQUIT SIGILL SIGTERM
trap "rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}"; exit" SIGHUP SIGQUIT SIGILL SIGTERM
trap 'printf " --> please use exit/quit/bye to terminate the skb\n"' SIGINT

unset JAVA_TOOL_OPTIONS
unset COMMAND_PROMPT
function __prompt_command() {
    PS1="\nskb> "
}
export PROMPT_COMMAND=__prompt_command

alias exit="Terminate 0"
alias quit="Terminate 0"
alias bye="Terminate 0"

Modules search
Load module Core

Set current phase File
if [[ -r "${FW_OBJECT_SET_VAL["CONFIG_FILE"]:-}" ]]; then
    Load settings from file "${FW_OBJECT_SET_VAL["CONFIG_FILE"]}"
elif [[ -r "${FW_OBJECT_CFG_VAL["USER_CONFIG"]:-}" ]]; then
    Load settings from file "${FW_OBJECT_CFG_VAL["USER_CONFIG"]}"
fi
if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate 1; fi

Set current phase Env; Load settings from environment
if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate 1; fi

Verify everything
Set current phase Load

Write fast config; Write slow config

if [[ -n "${FW_CLI_EXEC_TASK:-}" ]]; then
    set -o errexit
    Execute task ${FW_CLI_EXEC_TASK} ${FW_CLI_EXEC_ARGS:-}
    errno=$?
    Terminate ${errno}
fi
if [[ -n "${FW_CLI_EXEC_SCENARIO:-}" ]]; then
    set -o errexit
    Execute scenario ${FW_CLI_EXEC_SCENARIO}
    errno=$?
    Terminate ${errno}
fi
if [[ -n "${FW_CLI_EXEC_COMMAND:-}" ]]; then
    set -o errexit
    cmd="${FW_CLI_EXEC_COMMAND}"; object=""
    for index in ${SF_HOME}/lib/framework/{commands,elements,objects,instances}/*.sh; do index=${index##*/}; if [[ "${index}" != "Framework" ]]; then objects+="${index%%.sh} "; fi; done
    case $objects in
        *" ${cmd} "*)   ${cmd} ${FW_CLI_EXEC_ARGS:-}
                        errno=$?
                        Terminate ${errno}
                        ;;
        *) Report application fatalerror E803 "${cmd}" ;;
    esac
fi

Set current phase Shell
FW_OBJECT_SET_VAL["AUTO_VERIFY"]=true
Set auto write true

Report process message "framework started, ready to go"
