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
## Dependency - instance to manage dependency requirements
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Dependency() {
    local writeSlow=false
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    ## Dependency ID1 requires dependency ID2
    if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" E801 4 "$#"; return; fi

    if [[ "${2}" != "requires" ]];   then Report process error "${FUNCNAME[0]}" "Dependency ${1} requires dependency ${4}" E803 "${2}"; return; fi
    if [[ "${3}" != "dependency" ]]; then Report process error "${FUNCNAME[0]}" "Dependency ${1} requires dependency ${4}" E803 "${3}"; return; fi

    local id1="${1}" id2="${4}"
    Test existing dependency id "${id1}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
    Test existing dependency id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
    if [[ "${id1}" == "${id2}" ]]; then Report application error "${FUNCNAME[0]}" "Dependency ${1} requires dependency ${4}" E902 "dependency"; return; fi

    if [[ ! -n "${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES["${id1}"]:-}" ]]; then
        FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES["${id1}"]+="${id2} "; writeSlow=true
    else
        case "${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES["${id1}"]}" in
            *"${id2} "*)    Report application error "${FUNCNAME[0]}" "Module ${1} requires module ${4}" E904 "${id2}" "dependency ${id1}"; return ;;
            *)              FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES["${id1}"]+="${id2} "; writeSlow=true
        esac
    fi

    if [[ "${writeSlow}" ]]; then FW_ELEMENT_DEP_REQNUM[${id1}]=$(( FW_ELEMENT_DEP_REQNUM[${id1}] + 1 )); fi
    if [[ "${writeSlow}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write slow config; fi
}