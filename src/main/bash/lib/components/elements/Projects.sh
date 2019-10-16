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
## Projects - element representing projects
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Projects() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id keys numberArr
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_ELEMENT_PRJ_LONG[@]} " ;;
        list)
            if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_ELEMENT_PRJ_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s (dec: %s / %s)\n"                    "${id}" "${FW_ELEMENT_PRJ_DECMDS[${id}]}" "${FW_ELEMENT_PRJ_DECPHA[${id}]}"
                    printf "        status:     s: %s, c: %s\n"         "${FW_ELEMENT_PRJ_STATUS[${id}]}" "${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}"
                    IFS=" " read -a numberArr <<< "${FW_ELEMENT_PRJ_REQUESTED[${id}]}"; unset IFS
                    printf "        #req-in:    %s\n"                   "${#numberArr[@]}"
                    printf "        req-in:     %s\n"                   "${FW_ELEMENT_PRJ_REQUESTED[${id}]}"
                    printf "        modes:      %s\n"                   "${FW_ELEMENT_PRJ_MODES[${id}]}"
                    printf "        #req-out:   %s\n"                   "${FW_ELEMENT_PRJ_REQOUT_NUM[${id}]}"
                    printf "        showexec:   %s\n"                   "${FW_ELEMENT_PRJ_SHOW_EXEC[${id}]}"
                    printf "        path:       %s\n"                   "${FW_ELEMENT_PRJ_PATH[${id}]}"
                    printf "        path-text:  %s\n"                   "${FW_ELEMENT_PRJ_PATH_TEXT[${id}]}"
                    printf "        root-dir:   %s\n"                   "${FW_ELEMENT_PRJ_RDIR_TEXT[${id}]}"
                    printf "        targets:    %s\n"                   "${FW_ELEMENT_PRJ_TGTS_TEXT[${id}]}"
                    printf "        descr:      %s\n"                   "${FW_ELEMENT_PRJ_LONG[${id}]}"

                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_APP[${id}]:-}" ]]; then printf "        req-app:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_APP[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]:-}" ]]; then printf "        req-dep:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DLS[${id}]:-}" ]]; then printf "        req-dls:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_DLS[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]:-}" ]]; then printf "        req-dir:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_FLS[${id}]:-}" ]]; then printf "        req-fls:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_FLS[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_FIL[${id}]:-}" ]]; then printf "        req-fil:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_FIL[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]:-}" ]]; then printf "        req-par:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_PRJ[${id}]:-}" ]]; then printf "        req-prj:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_PRJ[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_SCN[${id}]:-}" ]]; then printf "        req-scn:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_SCN[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_SIT[${id}]:-}" ]]; then printf "        req-sit:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_SIT[${id}]}"; fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]:-}" ]]; then printf "        req-tsk:    %s\n"   "${FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]}"; fi
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
