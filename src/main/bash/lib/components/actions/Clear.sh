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


function Clear() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id dir file
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        everything)
            Clear logs
            Clear full cache ;;

        logs)
            dir="${FW_OBJECT_SET_VAL["LOG_DIR"]}"
            for file in ${dir}/*; do
                if [[ "${file}" != "${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}" ]]; then
                    rm $file
                fi
            done ;;

        cache | framework | full)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                full-cache)
                    Clear framework cache
                    for id in $(Modules has); do
                        Clear cache for module $id
                    done
                    if [[ -d ${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules ]]; then rmdir ${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules; fi
                    for id in $(Themes has); do
                        Clear cache for theme $id
                    done
                    if [[ -d ${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes ]]; then rmdir ${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes; fi ;;

                framework-cache)
                    Clear cache for module ⫷Framework⫸
                    Clear cache for theme Default ;;

                cache-for)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in
                        cache-for-module)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; Test existing module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            if [[ -w "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}-objects.cache" ]]; then rm "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}-objects.cache"; fi
                            if [[ -w "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}-elements.cache" ]]; then rm "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}-elements.cache"; fi
                            if [[ -w "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}-options.cache" ]]; then rm "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}-options.cache"; fi ;;

                        cache-for-theme)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; Test existing theme id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            if [[ -w "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes/${id}.cache" ]]; then rm "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes/${id}.cache"; fi
                            if [[ -w "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes/${id}-stores.cache" ]]; then rm "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes/${id}-stores.cache"; fi ;;

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
