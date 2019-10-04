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

alias exit="Terminate framework 0"
alias quit="Terminate framework 0"
alias bye="Terminate framework 0"

Modules search
Load module Core

Set current phase File
if [[ -r "${FW_OBJECT_SET_VAL["CONFIG_FILE"]:-}" ]]; then
    Load settings from file "${FW_OBJECT_SET_VAL["CONFIG_FILE"]}"
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 10; fi
elif [[ -r "${FW_OBJECT_CFG_VAL["USER_CONFIG"]:-}" ]]; then
    Load settings from file "${FW_OBJECT_CFG_VAL["USER_CONFIG"]}"
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 11; fi
fi

Set current phase Env; Load settings from environment
if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 12; fi

Verify everything
Set current phase Load

Write fast config; Write slow config


if [[ "${FW_ELEMENT_OPT_SET["execute-task"]}" == "yes" ]]; then
    Execute task "${FW_ELEMENT_OPT_VAL["execute-task"]}" ${FW_ELEMENT_OPT_EXTRA}
    if (( $(Get object phase Task error count) > 0 )); then printf "\n"; Terminate framework 13; else Terminate framework 0; fi
fi

if [[ "${FW_ELEMENT_OPT_SET["execute-scenario"]}" == "yes" ]]; then
    Execute scenario "${FW_ELEMENT_OPT_VAL["execute-scenario"]}"
    if (( $(Get object phase Scenario error count) > 0 )); then printf "\n"; Terminate framework 14; else Terminate framework 0; fi
fi

if [[ "${FW_ELEMENT_OPT_SET["execute-command"]}" == "yes" ]]; then
    cmd="${FW_ELEMENT_OPT_VAL["execute-command"]}"
    case "$(Framework has actions) $(Framework has elements) $(Framework has instances) $(Framework has objects)" in
        *" ${cmd} "*)   ${cmd} ${FW_ELEMENT_OPT_EXTRA}
                        if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 16; else Terminate framework 0; fi ;;
        *)              Report application fatalerror E803 "${cmd}"; Terminate framework 15 ;;
    esac
fi


Set current phase Shell
FW_OBJECT_SET_VAL["AUTO_VERIFY"]=true
Set auto write true

Report process message "framework started, ready to go"
