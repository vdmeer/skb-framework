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
## Levels - data object representing the framework's levels
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_OBJECT_LVL_LONG[*]}" == "" ]]; then
    declare -A FW_OBJECT_LVL_LONG       ## [long]="description"
    declare -A FW_OBJECT_LVL_PATH       ## [long]="path to description"
    declare -A FW_OBJECT_LVL_CHAR_ABBR  ## [long]="char for abbbreviating level, e.g. in tables"
    declare -A FW_OBJECT_LVL_STRING_THM ## [long]="theme string"
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_LVL_LONG FW_OBJECT_LVL_PATH FW_OBJECT_LVL_CHAR_ABBR FW_OBJECT_LVL_STRING_THM"
fi

FW_TABLES_COL1["level"]=Level
FW_TABLES_EXTRAS["level"]=""
FW_TAGS_OBJECTS["Levels"]="data object representing the framework's levels"


function Levels() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_OBJECT_LVL_LONG[@]} " ;;
        list)
            if [[ "${FW_OBJECT_LVL_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_LVL_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s: %s, %s, (%s, %s)\n" "${id}" "${FW_OBJECT_LVL_LONG[${id}]}" "${FW_OBJECT_LVL_PATH[${id}]}" "${FW_OBJECT_LVL_CHAR_ABBR[${id}]}" "${FW_OBJECT_LVL_STRING_THM[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        get)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                get-abbreviation | get-theme)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        get-abbreviation-character)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${id}"; Test existing level id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            printf "${FW_OBJECT_LVL_CHAR_ABBR[${id}]}" ;;
                        get-theme-string)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${id}"; Test existing level id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            printf "${FW_OBJECT_LVL_STRING_THM[${id}]}" ;;

                        *)
                            Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)
                    Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
