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
## Build - action to build something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_COMPONENTS_TAGLINE["build"]="action to build something"


function Build() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id errno text arg count
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        message)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing message id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ "${#}" -lt "${FW_OBJECT_MSG_ARGS[${id}]}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 "${FW_OBJECT_MSG_ARGS[${id}]}" "$#"; return; fi
            text="${FW_OBJECT_MSG_TEXT[${id}]}"; count=1
            shift; for arg in "$@"; do text=${text/"##ARG$((count++))##"/"${arg}"}; done
            printf "%s" "${text}" ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
