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
## Prepare - action to prepare something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Prepare() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        project | scenario | task)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                project-execution)
                    ;;
                scenario-execution | task-execution)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"; Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                    FW_OBJECT_SET_VAL["AUTO_WRITE"]="false"
                    Set current phase to ${cmd1^}

                    FW_OBJECT_SET_VAL["APP_NAME2"]="${id}"
                    FW_OBJECT_SET_VAL["CURRENT_${cmd1^^}"]="${id}"

                    FW_OBJECT_PHA_ERRCNT[${cmd1^}]=0
                    FW_OBJECT_SET_VAL["ERROR_COUNT"]=0
                    FW_OBJECT_PHA_WRNCNT[${cmd1^}]=0
                    FW_OBJECT_SET_VAL["WARNING_COUNT"]=0
                    FW_OBJECT_PHA_ERRCOD[${cmd1^}]=""
##TODO ADD SETTING PHASE FOR VALUES
                    Activate auto write ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
