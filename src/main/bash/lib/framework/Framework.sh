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


if [[ -n "${SF_HOME:-}" ]]; then
## backup for IFS
###    if [[ -z "${SF_FIELD_SEPARATOR:-}" ]]; then SF_FIELD_SEPARATOR="$IFS"; declare -r -g -x SF_FIELD_SEPARATOR; fi

    if [[ -n "${FW_INIT:-}" ]]; then
        declare -x FW_RUNTIME_MAPS_FAST=""    ## fast changing maps, such as settings, phases
        declare -x FW_RUNTIME_MAPS_MEDIUM=""  ## medium changing maps, such as status and status comments
        declare -x FW_RUNTIME_MAPS_SLOW=""    ## slow chaning maps, such as themes, theme items, messages
        declare -x FW_RUNTIME_MAPS_LOAD=""    ## maps written only at load time, such as options and known theme items
    fi

    declare -A -g FW_TABLES_COL1 FW_TABLES_EXTRAS
        FW_TABLES_COL1["action"]=Action;     FW_TABLES_EXTRAS["action"]=""
        FW_TABLES_COL1["element"]=Element;   FW_TABLES_EXTRAS["element"]=""
        FW_TABLES_COL1["instance"]=Instance; FW_TABLES_EXTRAS["instance"]=""
        FW_TABLES_COL1["object"]=Object;     FW_TABLES_EXTRAS["object"]=""

    declare -A -g FW_TAGS_ACTIONS FW_TAGS_ELEMENTS FW_TAGS_INSTANCES FW_TAGS_OBJECTS

    for file in ${SF_HOME}/lib/framework/{actions,elements,objects,instances}/*.sh; do source ${file}; done; unset file

    if [[ -n "${FW_INIT:-}" ]]; then
        # start
        Test getopt
        source ${SF_HOME}/lib/framework/load/initialization.sh
        source ${SF_HOME}/lib/framework/load/cli.sh
        if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 1; fi
        Write load config

        Set current phase Load
        source ${SF_HOME}/lib/api-module/API.module
        Write fast config; Write medium config; Write slow config
        export FW_LOADED=yes
    elif [[ "${FW_LOADED:-no}" == yes ]]; then
        Load runtime
        IFS="." read -r -a SF_VERSINFO <<< "${SF_VERSION}"
        if [[ "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" == "Scenario" ]]; then FW_CURRENT_SCENARIO_NAME="${FW_OBJECT_SET_VAL["CURRENT_SCENARIO"]}"; fi
        if [[ "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" == "Task" ]]; then
            set -o pipefail -o noclobber -o nounset -o errexit
            shopt -s globstar
            FW_CURRENT_TASK_NAME="${FW_OBJECT_SET_VAL["CURRENT_TASK"]}"
            Cli add option help; Cli add option format; Cli add option describe
        fi
    fi
else
    printf "\nSKB: please use skb-framework\n"
fi


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
                    for name in ${SF_HOME}/lib/framework/${1}/*.sh; do
                        name="${name#${SF_HOME}/lib/framework/${1}/*}"
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
