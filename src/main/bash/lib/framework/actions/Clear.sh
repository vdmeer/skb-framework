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
## Clear - action to clear something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_COMPONENTS_TAGLINE["clear"]="action to clear something"


function Clear() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id dir file
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        everything)
            Clear logs
            Clear all themes
            Clear full cache ;;

        theme)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing theme id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then printf ""; return; fi
            if [[ "${id}" != "API" ]]; then
                path="${FW_OBJECT_THM_PATH[${id}]}"
                decFile="${path}/${id}.dec"
                if [[ -w "${decFile}" ]]; then rm "${decFile}"; fi
            fi ;;

        logs)
            dir="${FW_OBJECT_SET_VAL["LOG_DIR"]}"
            for file in ${dir}/*; do
                if [[ "${file}" != "${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}" ]]; then
                    rm $file
                fi
            done ;;

        all | cache | framework | full)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                all-themes)
                    for id in $(Themes has); do
                        Clear theme $id
                    done ;;
                full-cache)
                    Clear framework cache
                    for id in $(Modules has); do
                        Clear cache for module $id
                    done
                    ;;

                framework-cache)
                    dir="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}"
                    for file in ${dir}/*.cache; do
                        if [[ "${file}" != "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/*.cache" ]]; then
                            rm $file
                        fi
                    done ;;

                cache-for)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in
                        cache-for-module)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            moduleId="${1}"

                            if [[ "${moduleId}" != "API" ]]; then
                                Test existing module id "${moduleId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                                file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/module--${moduleId}.cache"
                                if [[ -w "${file}" ]]; then rm "${file}"; fi
                            fi ;;

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
