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
## Load - action to load something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_COMPONENTS_TAGLINE["load"]="action to load something"


function Load() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id errno file path doWriteRT=false themeId envKey
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        messages)
            unset FW_OBJECT_MSG_LONG FW_OBJECT_MSG_TYPE FW_OBJECT_MSG_ARGS FW_OBJECT_MSG_TEXT
            declare -A -g FW_OBJECT_MSG_LONG FW_OBJECT_MSG_TYPE FW_OBJECT_MSG_ARGS FW_OBJECT_MSG_TEXT
            source ${SF_HOME}/lib/framework/load/messages.sh ;;

        module)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            if [[ "${id}" != "API" ]]; then
                Test known module "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                local modFile="${FW_ELEMENT_MDS_KNOWN[${id}]}" modPath
                modPath="${modFile%/*}"
                FW_MODULE_PATH="${modPath}"
                FW_OBJECT_SET_VAL["AUTO_WRITE"]=false
                source "${modFile}"
                unset -v FW_MODULE_PATH
                Load task completions
                if [[ "${FW_OBJECT_SET_VAL["AUTO_VERIFY"]:-false}" != false ]]; then Verify everything; fi
                Set auto write true
                Write slow config
            else
                Report process error "${FUNCNAME[0]}" "${cmd1}" E828 "module" "loaded"
            fi ;;

        runtime)
            source ${FW_RUNTIME_CONFIG_FAST}
            source "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"
            source "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"
            source "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}" ;;

        theme)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing theme id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ "${id}" != "API" ]]; then
                Tablechars clear all
                FW_CURRENT_THEME_NAME="${id}"
                path="${FW_OBJECT_THM_PATH[${id}]}"
                if [[ -r "${path}/${id}.dec" ]]; then
                    source "${path}/${id}.dec"
                else
                    FW_OBJECT_SET_VAL["AUTO_WRITE"]=false
                    source "${path}/${id}.thm"
                fi
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" != "Load" ]]; then Write slow config; Set auto write true; fi
                unset FW_CURRENT_THEME_NAME
            else
                Report process error "${FUNCNAME[0]}" "${cmd1}" E828 "theme" "loaded"
            fi ;;

        all | framework | settings | task)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                all-modules)
                    Modules search
                    if [[ "${FW_ELEMENT_MDS_KNOWN[*]}" != "" ]]; then
                        for id in ${!FW_ELEMENT_MDS_KNOWN[@]}; do Load module ${id}; done
                        doWriteRT=true
                    else
##TODO message about no modules known - do search
                        :
                    fi ;;

                framework-completions)
                    for file in ${SF_HOME}/lib/framework/completion/*.sh; do source ${file}; done ;;
                framework-sources)
                    for file in ${SF_HOME}/lib/framework/{actions,elements,objects,instances}/*.sh; do source ${file}; done ;;

                task-completions)
                    if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            file="${FW_ELEMENT_TSK_PATH[${id}]}/${id}-completions.bash"
                            if [[ -r "${file}" ]]; then source "${file}"; fi
                        done
                    fi ;;

                settings-from)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        settings-from-file)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            file="${1}"
                            Test file exists   "${file}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test file can read "${file}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            source ${file}
                            if [[ "${FW_OBJECT_SET_VAL["AUTO_VERIFY"]:-false}" != false ]]; then Verify everything; fi ;;

                        settings-from-environment)
                            envKey=SF_APP_NAME; if [[ ! -z "${!envKey:-}" ]]; then Set app name "${!envKey}"; fi
                            for id in ${!FW_ELEMENT_DLS_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_DIRLIST_${envKey^^}";  if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_DLS_VAL[${id}]="${!envKey}"; fi; done
                            for id in ${!FW_ELEMENT_DIR_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_DIR_${envKey^^}";      if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_DIR_VAL[${id}]="${!envKey}"; fi; done
                            for id in ${!FW_ELEMENT_FLS_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_FILELIST_${envKey^^}"; if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_FLS_VAL[${id}]="${!envKey}"; fi; done
                            for id in ${!FW_ELEMENT_FIL_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_FILE_${envKey^^}";     if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_FIL_VAL[${id}]="${!envKey}"; fi; done
                            for id in ${!FW_ELEMENT_PAR_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_PARAM_${envKey^^}";    if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_PAR_VAL[${id}]="${!envKey}"; fi; done
                            if [[ "${FW_OBJECT_SET_VAL["AUTO_VERIFY"]:-false}" != false ]]; then Verify everything; fi ;;
##TODO ADD Application to here?

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
    if [[ "${doWriteRT}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; Write slow config; fi
}
