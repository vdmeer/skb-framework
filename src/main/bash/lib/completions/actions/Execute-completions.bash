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
## Execute - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Execute_completions(){
    local retval="" taskName taskCompletion
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Execute)        retval="application project scenario script site task" ;;

        application)    retval="$(Applications has)" ;;
        project)        retval="$(Projects has)" ;;
        scenario)       retval="$(Scenarios has)" ;;
        script)         retval="$(Scripts has)" ;;
        site)           retval="$(Sites has)" ;;
        task)           retval="$(Tasks has)" ;;

        *)  if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "Execute" && "${COMP_WORDS[COMP_CWORD-2]}" == "scenario" ]]; then
                retval="-D --describe"
            elif [[ "${COMP_WORDS[COMP_CWORD-4]}" == "Execute" && "${COMP_WORDS[COMP_CWORD-3]}" == "scenario" ]]; then
                retval=""
            elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "Execute" && "${COMP_WORDS[COMP_CWORD-2]}" == "site" ]]; then
                retval="-D --describe"
            elif [[ "${COMP_WORDS[COMP_CWORD-4]}" == "Execute" && "${COMP_WORDS[COMP_CWORD-3]}" == "site" ]]; then
                retval=""
            elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "Execute" && "${COMP_WORDS[COMP_CWORD-2]}" == "script" ]]; then
                retval="-D --describe"
            elif [[ "${COMP_WORDS[COMP_CWORD-4]}" == "Execute" && "${COMP_WORDS[COMP_CWORD-3]}" == "script" ]]; then
                retval=""
            else
                case "$COMP_LINE" in
                    "Execute task "*)
                        taskName="${COMP_WORDS[2]//-/_}"
                        taskCompletion="__skb_task_${taskName}_words"
                        if [[ -n "$(type -t $taskCompletion)" && "$(type -t $taskCompletion)" = "function" ]]; then retval="$(${taskCompletion})"; fi ;;
                    "Framework action Execute task "*)
                        taskName="${COMP_WORDS[4]//-/_}"
                        taskCompletion="__skb_task_${taskName}_words"
                        if [[ -n "$(type -t $taskCompletion)" && "$(type -t $taskCompletion)" = "function" ]]; then retval="$(${taskCompletion})"; fi ;;
                esac
            fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Execute_completions Execute
