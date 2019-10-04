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
## Exitcodes - instance representing the framework's exit codes
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_INSTANCE_EXC_LONG[*]}" == "" ]]; then
    declare -A FW_INSTANCE_EXC_LONG     ## [long]="description"
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_LOAD+=" FW_INSTANCE_EXC_LONG"
fi

FW_COMPONENTS_SINGULAR["exitcodes"]="exitcode"
FW_COMPONENTS_PLURAL["exitcodes"]="exitcodes"
FW_COMPONENTS_TITLE_LONG_SINGULAR["exitcodes"]="Exit Code"
FW_COMPONENTS_TITLE_LONG_PLURAL["exitcodes"]="Exit Codes"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["exitcodes"]="Exit Code"
FW_COMPONENTS_TITLE_SHORT_PLURAL["exitcodes"]="Exit Codes"
FW_COMPONENTS_TABLE_DESCR["exitcodes"]="Description"
FW_COMPONENTS_TABLE_VALUE["exitcodes"]="Description"
#FW_COMPONENTS_TABLE_DEFVAL["exitcodes"]=""
FW_COMPONENTS_TABLE_EXTRA["exitcodes"]=""
FW_COMPONENTS_TAGLINE["exitcodes"]="instance representing the framework's exit codes"


function Exitcodes() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id shortId printString="" retval category keys
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in

        has)
            echo " ${!FW_INSTANCE_EXC_LONG[@]} " ;;

        list)
            if [[ "${FW_INSTANCE_EXC_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_INSTANCE_EXC_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s :: %s\n" "${id}" "${FW_INSTANCE_EXC_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
