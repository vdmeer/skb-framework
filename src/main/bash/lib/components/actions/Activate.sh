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
## Activate - action to activates something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Activate() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local level errno doWriteFast=false
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        phase)
            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 4 "$#"; return; fi
            id="${1}"; cmd2="${2}"; cmd3="${3}"; level="${4}"
            Test existing phase id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            Test existing level id "${level}" ; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            case "${cmd2}-${cmd3}" in
                print-level | log-level) sf_deac_phase_level activate ${cmd2}-${cmd3} ${id} ${level} ;;
                *)  Report process error "${FUNCNAME[0]}" "${cmdString1}" E879 "${cmd1}" "${cmd2} ${cmd3}"; return ;;
            esac ;;

        auto | log | print | show | strict)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                auto-verify)
                    FW_OBJECT_SET_VAL["AUTO_VERIFY"]=true
                    FW_OBJECT_SET_PHASET["AUTO_VERIFY"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    doWriteFast=true ;;

                auto-write)
                    FW_OBJECT_SET_VAL["AUTO_WRITE"]=true
                    FW_OBJECT_SET_PHASET["AUTO_WRITE"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    doWriteFast=true ;;

                print-level | log-level)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    level="${1}"; Test existing level id "${level}" ; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    sf_deac_phase_level activate ${cmd1}-${cmd2} ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ${level} ;;

                show-execution)
                    FW_OBJECT_SET_PHASET["SHOW_EXECUTION"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    FW_OBJECT_SET_VAL["SHOW_EXECUTION"]="on"
                    doWriteFast=true ;;
                show-execution2)
                    FW_OBJECT_SET_PHASET["SHOW_EXECUTION2"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    FW_OBJECT_SET_VAL["SHOW_EXECUTION2"]="on"
                    doWriteFast=true ;;

                strict-mode)
                    FW_OBJECT_SET_PHASET["STRICT_MODE"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    FW_OBJECT_SET_VAL["STRICT_MODE"]="on"
                    doWriteFast=true ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac

    if [[ "${doWriteFast}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; doWriteFast=false; fi
}
