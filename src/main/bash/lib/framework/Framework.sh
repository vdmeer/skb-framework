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

    ## maps for writing runtime configuration maps
    if [[ -n "${FW_INIT:-}" ]]; then
        declare -x FW_RUNTIME_MAPS_FAST=""    ## fast changing maps, such as settings, phases
        declare -x FW_RUNTIME_MAPS_MEDIUM=""  ## medium changing maps, such as status and status comments
        declare -x FW_RUNTIME_MAPS_SLOW=""    ## slow chaning maps, such as themes, theme items, messages
        declare -x FW_RUNTIME_MAPS_LOAD=""    ## maps written only at load time, such as options and known theme items
    fi


    ## maps to flaten naming edge cases and static component properties
    ## {name,,} means the name, plural, lower case
    ## components with special plural spelling (e.g. dependency/dependencies) can get 2 entries in each map

    declare -A -g FW_COMPONENTS_SINGULAR                ## [name,,]="all lower case singular of the term for elements, instances, objects"
    declare -A -g FW_COMPONENTS_PLURAL                  ## [name,,]="all lower case plural of the term for elements, instances, objects"
    declare -A -g FW_COMPONENTS_TITLE_LONG_SINGULAR     ## [name,,]="Long Title, singular"
    declare -A -g FW_COMPONENTS_TITLE_LONG_PLURAL       ## [name,,]="Long Title, plural"
    declare -A -g FW_COMPONENTS_TITLE_SHORT_SINGULAR    ## [name,,]="Short Title, singular"
    declare -A -g FW_COMPONENTS_TITLE_SHORT_PLURAL      ## [name,,]="Short Title, plural"
    declare -A -g FW_COMPONENTS_TABLE_DESCR             ## [name,,]="text for table head when showing taglines"
    declare -A -g FW_COMPONENTS_TABLE_VALUE             ## [name,,]="text for table head when showing values"
    declare -A -g FW_COMPONENTS_TABLE_DEFVAL            ## [name,,]="text for table head when showing default values"
    declare -A -g FW_COMPONENTS_TABLE_EXTRA             ## [name,,]="Extra properties in table", empty if none
    declare -A -g FW_COMPONENTS_TAGLINE                 ## [name,,]="tagline", i.e. s short description

    ## create entries for the 4 components, they don't have a function defined
    FW_COMPONENTS_SINGULAR["actions"]="action";     FW_COMPONENTS_PLURAL["actions"]="actions";     FW_COMPONENTS_TITLE_LONG_SINGULAR["actions"]="Action";     FW_COMPONENTS_TITLE_LONG_PLURAL["actions"]="Actions";     FW_COMPONENTS_TITLE_SHORT_SINGULAR["actions"]="Action";     FW_COMPONENTS_TITLE_SHORT_PLURAL["actions"]="Actions";     FW_COMPONENTS_TABLE_EXTRA["actions"]=""
    FW_COMPONENTS_SINGULAR["elements"]="element";   FW_COMPONENTS_PLURAL["elements"]="elements";   FW_COMPONENTS_TITLE_LONG_SINGULAR["elements"]="Element";   FW_COMPONENTS_TITLE_LONG_PLURAL["elements"]="Elements";   FW_COMPONENTS_TITLE_SHORT_SINGULAR["elements"]="Element";   FW_COMPONENTS_TITLE_SHORT_PLURAL["elements"]="Elements";   FW_COMPONENTS_TABLE_EXTRA["elements"]=""
    FW_COMPONENTS_SINGULAR["instances"]="instance"; FW_COMPONENTS_PLURAL["instances"]="instances"; FW_COMPONENTS_TITLE_LONG_SINGULAR["instances"]="Instance"; FW_COMPONENTS_TITLE_LONG_PLURAL["instances"]="Instances"; FW_COMPONENTS_TITLE_SHORT_SINGULAR["instances"]="Instance"; FW_COMPONENTS_TITLE_SHORT_PLURAL["instances"]="Instances"; FW_COMPONENTS_TABLE_EXTRA["instances"]=""
    FW_COMPONENTS_SINGULAR["objects"]="object";     FW_COMPONENTS_PLURAL["objects"]="objects";     FW_COMPONENTS_TITLE_LONG_SINGULAR["objects"]="Object";     FW_COMPONENTS_TITLE_LONG_PLURAL["objects"]="Objects";     FW_COMPONENTS_TITLE_SHORT_SINGULAR["objects"]="Object";     FW_COMPONENTS_TITLE_SHORT_PLURAL["objects"]="Objects";     FW_COMPONENTS_TABLE_EXTRA["objects"]=""


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
            Clioptions add option help; Clioptions add option format; Clioptions add option describe
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
