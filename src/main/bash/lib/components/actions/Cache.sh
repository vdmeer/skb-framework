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
## Cache - action to caches something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Cache() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id file name errno
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        framework)
            Cache module "⫷Framework⫸"

            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/⫷Framework⫸-options.cache"; touch ${file}
            if [[ -w "${file}" ]]; then
                rm ${file}
                __skb_internal_cache_fw_options "${file}"
            fi ;;

        module)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"; if [[ "${id}" == "☰API☷" ]]; then Report process error "${FUNCNAME[0]}" "${cmd1}" E828 "module" "written"; return; fi
            Test existing module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then printf ""; return; fi
            mkdir -p ${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules

            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}-objects.cache"; touch ${file}
            if [[ ! -w "${file}" ]]; then Report process error "${FUNCNAME[0]}" "${cmd1}" E822 "module cache file" "${file}"; return; fi
            rm ${file}
            for name in $(Framework has objects); do
                case "${name}" in
                    ## never cache Configurations, Settings, Themes, Variables
                    Formats | Levels | Messages | Modes | Phases | Themeitems)
                        __skb_internal_cache_object_${name,,} "${id}" "${file}" ;;
                esac
            done

            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}-elements.cache"; touch ${file}
            if [[ ! -w "${file}" ]]; then Report process error "${FUNCNAME[0]}" "${cmd1}" E822 "cache file" "${file}"; return; fi
            rm ${file}
            for name in $(Framework has elements); do
                case "${name}" in
                    ## do not cache Options for modules, never cache Modules themself
                    Applications | Dependencies | Dirlists | Dirs | Filelists | Files | Parameters | Projects | Scenarios | Scripts | Sites | Tasks)
                        __skb_internal_cache_element_${name,,} "${id}" "${file}"
                esac
            done

            for name in ${!FW_OBJECT_THM_LONG[@]}; do
                if [[ "${FW_OBJECT_THM_DECMDS["${name}"]}" == "${id}" ]]; then
                    if [[ "${name}" != "API" ]]; then Cache theme ${name}; fi
                fi
            done ;;

        theme)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"; if [[ "${id}" == "API" ]]; then Report process error "${FUNCNAME[0]}" "${cmd1}" E828 "theme" "written"; return; fi
            Test existing theme id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then printf ""; return; fi

            mkdir -p ${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes
            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes/${id}.cache"; touch ${file}
            if [[ ! -w "${file}" ]]; then Report process error "${FUNCNAME[0]}" "${cmd1}" E822 "theme cache file" "${file}"; return; fi

            rm ${file}
            __skb_internal_cache_theme "${id}" "${FW_OBJECT_THM_DECMDS[${id}]}" "${file}" "${FW_ELEMENT_MDS_PATH["${FW_OBJECT_THM_DECMDS[${id}]}"]}/themes/${id}.thm" "${FW_OBJECT_THM_DECMDS[${id}]}::/themes/${id}.thm"
            __skb_internal_cache_store "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes/${id}-stores.cache" ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
