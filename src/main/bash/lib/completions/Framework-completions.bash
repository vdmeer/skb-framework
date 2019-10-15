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
## Framework - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


for file in ${SF_HOME}/lib/completions/{actions,elements,objects,instances}/*.bash; do source ${file}; done; unset file


function __Framework_component_completions(){
    local retval="" index taskName taskCompletion

    case "${#COMP_WORDS[@]}" in
        1)  ;;
        2)  retval="action element has instance object task"
            COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[1]}")) ;;
        3)  case ${COMP_WORDS[COMP_CWORD-1]} in
                action)     COMPREPLY=($(compgen -W "$(Framework has actions)" --                       "${COMP_WORDS[2]}")) ;;
                element)    COMPREPLY=($(compgen -W "$(Framework has elements)" --                      "${COMP_WORDS[2]}")) ;;
                has)        COMPREPLY=($(compgen -W "actions elements instances objects components" --  "${COMP_WORDS[2]}")) ;;
                instance)   COMPREPLY=($(compgen -W "$(Framework has instances)" --                     "${COMP_WORDS[2]}")) ;;
                object)     COMPREPLY=($(compgen -W "$(Framework has objects)" --                       "${COMP_WORDS[2]}")) ;;
                task)       COMPREPLY=($(compgen -W "$(Tasks has)" --                                   "${COMP_WORDS[2]}")) ;;
            esac ;;
        4)  case "${COMP_LINE}" in
                "Framework has "*)  ;;
                "Framework task "*) taskName="${COMP_WORDS[2]//-/_}"
                                    taskCompletion="__skb_task_${taskName}_words"
                                    if [[ -n "$(type -t $taskCompletion)" && "$(type -t $taskCompletion)" = "function" ]]; then retval="$(${taskCompletion})"; fi
                                    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi ;;
                *)                  __skb_${COMP_WORDS[2]}_completions
            esac ;;
        *)  __skb_${COMP_WORDS[2]}_completions ;;
    esac
}
complete -F __Framework_component_completions Framework
