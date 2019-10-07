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
## Ask - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Ask_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Ask)            retval="has log print project task scenario" ;;

        has)            retval="warnings? errors?" ;;
        print | log)    retval="level?" ;;
        level?)         retval="$(Levels has)" ;;

        project | task | scenario)  retval="in" ;;
        in)                         retval="mode?" ;;

        *)              if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "task" && "${COMP_WORDS[COMP_CWORD-2]}" == "in" && "${COMP_WORDS[COMP_CWORD-1]}" == "mode?" ]]; then
                            retval="$(Tasks has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "scenario" && "${COMP_WORDS[COMP_CWORD-2]}" == "in" && "${COMP_WORDS[COMP_CWORD-1]}" == "mode?" ]]; then
                            retval="$(Scenarios has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "project" && "${COMP_WORDS[COMP_CWORD-2]}" == "in" && "${COMP_WORDS[COMP_CWORD-1]}" == "mode?" ]]; then
                            retval="$(Projects has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "in" && "${COMP_WORDS[COMP_CWORD-2]}" == "mode?" ]]; then
                            retval="$(Modes has)"
                        fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Ask_completions Ask
