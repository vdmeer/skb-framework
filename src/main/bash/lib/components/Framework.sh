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
## Framework - single point of init and access to all Framework functionality
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


for file in ${SF_HOME}/lib/components/{actions,elements,objects,instances}/*.sh; do source ${file}; done; unset file


function Framework() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        Format help indentation 1; Format text yellow "Auto completion"; printf " work fo all components.\n"
        Format help indentation 1; printf "Completion is dynamic, using the framework itself as much as possible\n"
        Format help indentation 1; printf "Completion will show only available completions for any given request.\n\n"
        Format help indentation 1; printf "To exit, use bye, exit, or quit; or use the action Terminate\n\n"; return
    fi

    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" E801 2 "$#"; return; fi
    local cmd1="${1}"; shift
    case "${cmd1}" in
        has)
            case "${1}" in
                actions | elements | instances | objects)
                    local name count=0
                    for name in ${SF_HOME}/lib/components/${1}/*.sh; do
                        name="${name#${SF_HOME}/lib/components/${1}/*}"
                        if (( count > 0 )); then printf " "; fi
                        printf "%s" "${name%*.sh}"
                        count=$(( count + 1 ))
                    done ;;
                *) Report process error "${FUNCNAME[0]}" E803 "${cmd1} ${1}" ;;
            esac; return ;;
        task)
            Test existing task id "${1}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            Execute task ${@}; return ;;
        action | element | instance | object)
            Test existing ${cmd1} id "${1}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            $@; return ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmd1}"; return ;;
    esac
}
