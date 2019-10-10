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
## Increase - action to increases something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Increase() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno doWriteFast=false
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        phase)
            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 3 "$#"; return; fi
            id="${1}"; cmd2="${2}"; cmd3="${3}"
            Test existing phase id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            case "${cmd2}-${cmd3}" in
                error-count)    FW_OBJECT_PHA_ERRCNT[${id}]=$(( FW_OBJECT_PHA_ERRCNT[${id}] + 1 )); doWriteFast=true ;;
                warning-count)  FW_OBJECT_PHA_WRNCNT[${id}]=$(( FW_OBJECT_PHA_WRNCNT[${id}] + 1 )); doWriteFast=true ;;
                *)  Report process error "${FUNCNAME[0]}" "${cmdString1}" E879 "${cmd1}" "${cmd2} ${cmd3}"; return ;;
            esac ;;

        error | warning)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                error-count)
                    FW_OBJECT_SET_PHA["ERROR_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    FW_OBJECT_SET_VAL["ERROR_COUNT"]=$(( FW_OBJECT_SET_VAL["ERROR_COUNT"] + 1 ))
                    Increase phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} error count ;;

                warning-count)
                    FW_OBJECT_SET_PHA["WARNING_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    FW_OBJECT_SET_VAL["WARNING_COUNT"]=$(( FW_OBJECT_SET_VAL["WARNING_COUNT"] + 1 ))
                    Increase phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} warning count ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac

    if [[ "${doWriteFast}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; doWriteFast=false; fi
}
