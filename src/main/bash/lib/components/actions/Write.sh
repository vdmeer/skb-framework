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
## Write - action to write something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Write() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno dir file sedFile str map mapsToWrite path line itemId itemVal count moduleId elemId
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        fast | load | medium | slow)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                fast-config | load-config | medium-config | slow-config)
                    case ${cmd1} in
                        fast)   file="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}";     mapsToWrite="${FW_RUNTIME_MAPS_FAST}"   ;;
                        medium) file="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}";   mapsToWrite="${FW_RUNTIME_MAPS_MEDIUM}" ;;
                        slow)   file="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}";     mapsToWrite="${FW_RUNTIME_MAPS_SLOW}"   ;;
                        load)   file="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}";     mapsToWrite="${FW_RUNTIME_MAPS_LOAD}"   ;;
                    esac
                    if [[ -w "${file}" ]]; then
                        rm ${file}; sedFile="${file}-sed"
                        for map in ${mapsToWrite}; do declare -p ${map} >> ${sedFile}; echo "" >> ${sedFile}; done
                        sed -e "s/declare -A/declare -A -g/g" -e "s/declare --/declare -g/g" ${sedFile} > ${file}; rm ${sedFile}
                    fi ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
