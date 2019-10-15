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
## Append - action to appends something to something else
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Append() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id1 id2 path errno doWriteFast=false
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        path)
            ## Append path PATH to module path
            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 4 "$#"; return; fi
            path="${1}"
            if [[ "${2}" != "to" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
            if [[ "${3}" != "module" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
            if [[ "${4}" != "path" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi

            Test dir can read "${path}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            case "${FW_OBJECT_SET_VAL["MODULE_PATH"]}" in
                *" ${path} "*) ;;
                *)  FW_OBJECT_SET_PHASET["MODULE_PATH"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    FW_OBJECT_SET_VAL["MODULE_PATH"]="${FW_OBJECT_SET_VAL["MODULE_PATH"]}${path} "
                    doWriteFast=true ;;
            esac ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac

    if [[ "${doWriteFast}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; doWriteFast=false; fi
}
