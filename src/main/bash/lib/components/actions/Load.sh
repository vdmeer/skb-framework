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


function Load() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno file doWriteRT=false themeId envKey
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        module)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"; if [[ "${id}" == "☰API☷" || "${id}" == "⫷Framework⫸" ]]; then Report process error "${FUNCNAME[0]}" "${cmd1}" E828 "module" "loaded"; return; fi
            Test known module "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            if [[ -r  "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}.cache" ]]; then
                source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}.cache"
            else
                local modFile="${FW_ELEMENT_MDS_KNOWN["${id}"]}" modPath
                modPath="${modFile%/*}"
                FW_MODULE_PATH="${modPath}"
                FW_OBJECT_SET_VAL["AUTO_WRITE"]=false
                FW_CURRENT_MODULE_NAME="${id}"
                source "${modFile}"
                unset -v FW_MODULE_PATH
                Reload task completions
                Activate auto write
                Write slow config
            fi
            if [[ "${FW_OBJECT_SET_VAL["AUTO_VERIFY"]}" != false ]]; then Verify elements; fi ;;

        runtime)
            source ${FW_RUNTIME_CONFIG_FAST}
            source "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"
            source "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"
            source "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}" ;;

        theme)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"; Test existing theme id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ "${id}" != "☰API☷" && "${id}" != "⫷Framework⫸" ]]; then
                Tablechars clear all
                FW_CURRENT_THEME_NAME="${id}"
                if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes/${id}.cache" ]]; then
                    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes/${id}.cache"
                elif [[ -r "${FW_ELEMENT_MDS_PATH["${FW_OBJECT_THM_DECMDS["${id}"]}"]}/themes/${id}.thm" ]]; then
                    FW_OBJECT_SET_VAL["AUTO_WRITE"]=false
                    source "${FW_ELEMENT_MDS_PATH["${FW_OBJECT_THM_DECMDS["${id}"]}"]}/themes/${id}.thm"
                else
                    :
##TODO ERROR file not found, tried cache and std dir
                fi
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" != "Load" ]]; then Write slow config; Activate auto write; fi
                unset FW_CURRENT_THEME_NAME
            else
                Report process error "${FUNCNAME[0]}" "${cmd1}" E828 "theme" "loaded"
            fi ;;

        all | settings)
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

                settings-from)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        settings-from-file)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            file="${1}"
                            Test file can read "${file}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            source ${file}
                            if [[ "${FW_OBJECT_SET_VAL["AUTO_VERIFY"]:-false}" != false ]]; then Verify elements; fi ;;

                        settings-from-environment)
                            envKey=SF_APP_NAME; if [[ ! -z "${!envKey:-}" ]]; then Set app name to "${!envKey}"; fi
                            for id in ${!FW_ELEMENT_DLS_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_DIRLIST_${envKey^^}";  if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_DLS_VAL["${id}"]="${!envKey}"; fi; done
                            for id in ${!FW_ELEMENT_DIR_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_DIR_${envKey^^}";      if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_DIR_VAL["${id}"]="${!envKey}"; fi; done
                            for id in ${!FW_ELEMENT_FLS_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_FILELIST_${envKey^^}"; if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_FLS_VAL["${id}"]="${!envKey}"; fi; done
                            for id in ${!FW_ELEMENT_FIL_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_FILE_${envKey^^}";     if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_FIL_VAL["${id}"]="${!envKey}"; fi; done
                            for id in ${!FW_ELEMENT_PAR_LONG[@]}; do envKey="${id//-/_}"; envKey="SF_PARAM_${envKey^^}";    if [[ ! -z "${!envKey:-}" ]]; then FW_ELEMENT_PAR_VAL["${id}"]="${!envKey}"; fi; done
                            if [[ "${FW_OBJECT_SET_VAL["AUTO_VERIFY"]:-false}" != false ]]; then Verify elements; fi ;;
##TODO ADD Application to here?

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
    if [[ "${doWriteRT}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; Write slow config; fi
}
