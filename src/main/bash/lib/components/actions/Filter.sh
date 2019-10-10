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
## Filter - action to filter something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Filter() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id keys filter
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        clioptions)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            filter="${1}"; declare -A keys
            if [[ ! -n "${filter}" ]]; then echo ""; return; fi
            if [[ "${FW_INSTANCE_CLI_LONG[*]}" != "" ]]; then
                for id in ${!FW_INSTANCE_CLI_LONG[@]}; do
                    if [[ "${FW_INSTANCE_CLI_CAT[${id}]}" != "${filter}" ]]; then continue; fi
                    keys[${id}]="f"
                done
                echo "${!keys[@]}"
            else
                echo ""
            fi ;;

        options)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            filter="${1}"; declare -A keys
            if [[ ! -n "${filter}" ]]; then echo ""; return; fi
            for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                if [[ "${FW_ELEMENT_OPT_CAT[${id}]}" != "${filter}" ]]; then continue; fi
                keys[${id}]="f"
            done
            echo "${!keys[@]}" ;;

        operations)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            filter="${1}"; declare -A keys
            if [[ ! -n "${filter}" ]]; then echo ""; return; fi
            for id in "${!FW_API[@]}"; do case ${id} in "${filter}%"*) keys[${id}]="f" ;; esac; done
            echo "${!keys[@]}" ;;

        messages)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            filter="${1}"; declare -A keys
            if [[ ! -n "${filter}" ]]; then echo ""; return; fi
            for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                if [[ ! -n "${FW_OBJECT_MSG_CAT[${id}]}" ]]; then continue; fi
                if [[ "${FW_OBJECT_MSG_CAT[${id}]}" != "${filter}" ]]; then continue; fi
                keys[${id}]="f"
            done
            echo "${!keys[@]}" ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
