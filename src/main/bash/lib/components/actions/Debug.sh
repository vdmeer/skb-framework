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
## Debug - action to debugs something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Debug() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno listIndent="    -" tmpString
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        application)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing application id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format tagline for application "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin:      %s\n" "${listIndent}" "${FW_ELEMENT_APP_ORIG[${id}]}"
                printf "%s command:     %s\n" "${listIndent}" "${FW_ELEMENT_APP_COMMAND[${id}]}"
                printf "%s # arguments: %s\n" "${listIndent}" "${FW_ELEMENT_APP_ARGNUM[${id}]}"
                printf "%s template:    %s\n" "${listIndent}" "${FW_ELEMENT_APP_ARGS[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_APP_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_APP_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_APP_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_APP_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_APP_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi ;;

        dependency)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing dependency id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format tagline for dependency "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin:  %s\n" "${listIndent}" "${FW_ELEMENT_DEP_ORIG[${id}]}"
                printf "%s command: %s\n" "${listIndent}" "${FW_ELEMENT_DEP_CMD[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_DEP_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_DEP_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_DEP_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi

            if [[ -n "${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]:-}" ]]; then
                printf "\n    "; Format text regular,italic "Dependencies"; printf "\n"
                for tmpString in ${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
            fi ;;


        dirlist)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing dirlist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format tagline for dirlist "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin: %s\n" "${listIndent}" "${FW_ELEMENT_DLS_ORIG[${id}]}"
                printf "%s value:  %s\n" "${listIndent}" "${FW_ELEMENT_DLS_VAL[${id}]}"
                printf "%s modes:  %s\n" "${listIndent}" "${FW_ELEMENT_DLS_MOD[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_DLS_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_DLS_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_DLS_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_DLS_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_DLS_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi ;;

        dir)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing dir id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format tagline for dir "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin: %s\n" "${listIndent}" "${FW_ELEMENT_DIR_ORIG[${id}]}"
                printf "%s value:  %s\n" "${listIndent}" "${FW_ELEMENT_DIR_VAL[${id}]}"
                printf "%s modes:  %s\n" "${listIndent}" "${FW_ELEMENT_DIR_MOD[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_DIR_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_DIR_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_DIR_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_DIR_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_DIR_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi ;;

        filelist)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing filelist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format tagline for filelist "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin: %s\n" "${listIndent}" "${FW_ELEMENT_FLS_ORIG[${id}]}"
                printf "%s value:  %s\n" "${listIndent}" "${FW_ELEMENT_FLS_VAL[${id}]}"
                printf "%s modes:  %s\n" "${listIndent}" "${FW_ELEMENT_FLS_MOD[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_FLS_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_FLS_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_FLS_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_FLS_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_FLS_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi ;;

        file)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing file id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format tagline for file "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin: %s\n" "${listIndent}" "${FW_ELEMENT_FIL_ORIG[${id}]}"
                printf "%s value:  %s\n" "${listIndent}" "${FW_ELEMENT_FIL_VAL[${id}]}"
                printf "%s modes:  %s\n" "${listIndent}" "${FW_ELEMENT_FIL_MOD[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_FIL_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_FIL_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_FIL_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_FIL_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_FIL_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi ;;


        module)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format tagline for module "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s long:    %s\n" "${listIndent}" "${id}"
                printf "%s acronym: %s\n" "${listIndent}" "${FW_ELEMENT_MDS_ACR[${id}]}"
                printf "%s path:    %s\n" "${listIndent}" "${FW_ELEMENT_MDS_PATH[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_MDS_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_MDS_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_MDS_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_MDS_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_MDS_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi

            if [[ -n "${FW_ELEMENT_MDS_REQUIRED_MODULES[${id}]:-}" ]]; then
                printf "\n    "; Format text regular,italic "Modules"; printf "\n"
                for tmpString in ${FW_ELEMENT_MDS_REQUIRED_MODULES[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
            fi ;;


        option)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing option id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            id="$(Get option id ${id})"

            printf "\n"; Format tagline for option "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s long:     %s\n" "${listIndent}" "${id}"
                printf "%s short:    %s\n" "${listIndent}" "${FW_ELEMENT_OPT_LS[${id}]}"
                printf "%s argument: %s\n" "${listIndent}" "${FW_ELEMENT_OPT_ARG[${id}]:-none}"
                printf "%s category: %s\n" "${listIndent}" "${FW_ELEMENT_OPT_CAT[${id}]:-none}"
            ;;

        parameter)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing parameter id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format tagline for parameter "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin:        %s\n" "${listIndent}" "${FW_ELEMENT_PAR_ORIG[${id}]}"
                printf "%s default value: %s\n" "${listIndent}" "${FW_ELEMENT_PAR_DEFVAL[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_PAR_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_PAR_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_PAR_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi ;;


        project)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing project id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            printf "\n"; Format tagline for project "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin:  %s\n" "${listIndent}" "${FW_ELEMENT_PAR_ORIG[${id}]}"
                printf "%s mode:    %s\n" "${listIndent}" "$(Format mode ${FW_ELEMENT_PAR_MODES[${id}]})"
                printf "%s path:    %s\n" "${listIndent}" "${FW_ELEMENT_PRJ_PATH_TEXT[${id}]}"
                printf "%s file:    %s\n" "${listIndent}" "${FW_ELEMENT_PRJ_FILE[${id}]}"
                printf "%s targets: %s\n" "${listIndent}" "${FW_ELEMENT_PRJ_TGTS[${id}]:-}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_PAR_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_PAR_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi

            printf "\n    "; Format text regular,italic "Requirements and dependencies"; printf "\n"
                if [[ -n "${FW_ELEMENT_PAR_REQUIRED_APP[${id}]:-}" ]]; then
                    printf "%s applications:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUIRED_APP[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_PAR_REQUIRED_DEP[${id}]:-}" ]]; then
                    printf "%s dependencies:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUIRED_DEP[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_PAR_REQUIRED_PAR[${id}]:-}" ]]; then
                    printf "%s parameters:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUIRED_PAR[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_PAR_REQUIRED_TSK[${id}]:-}" ]]; then
                    printf "%s tasks:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUIRED_TSK[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_PAR_REQUIRED_FILE[${id}]:-}" ]]; then
                    printf "%s files:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUIRED_FILE[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_PAR_REQUIRED_FILELIST[${id}]:-}" ]]; then
                    printf "%s file lists:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUIRED_FILELIST[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_PAR_REQUIRED_DIR[${id}]:-}" ]]; then
                    printf "%s directories:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUIRED_DIR[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_PAR_REQUIRED_DIRLIST[${id}]:-}" ]]; then
                    printf "%s directory lists:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_PAR_REQUIRED_DIRLIST[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
            ;;


        scenario)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing scenario id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            printf "\n"; Format tagline for scenario "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin: %s\n" "${listIndent}" "${FW_ELEMENT_SCN_ORIG[${id}]}"
                printf "%s mode:   %s\n" "${listIndent}" "$(Format mode ${FW_ELEMENT_SCN_MODES[${id}]})"
                printf "%s path:   %s\n" "${listIndent}" "${FW_ELEMENT_SCN_PATH_TEXT[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_SCN_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi

            printf "\n    "; Format text regular,italic "Requirements and dependencies"; printf "\n"
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_APP[${id}]:-}" ]]; then
                    printf "%s applications:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_REQUIRED_APP[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DEP[${id}]:-}" ]]; then
                    printf "%s dependencies:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_REQUIRED_DEP[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_PAR[${id}]:-}" ]]; then
                    printf "%s parameters:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_REQUIRED_PAR[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]:-}" ]]; then
                    printf "%s tasks:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_FILE[${id}]:-}" ]]; then
                    printf "%s files:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_REQUIRED_FILE[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]:-}" ]]; then
                    printf "%s file lists:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DIR[${id}]:-}" ]]; then
                    printf "%s directories:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_REQUIRED_DIR[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]:-}" ]]; then
                    printf "%s directory lists:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
            ;;


        site)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing site id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            printf "\n"; Format tagline for site "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin: %s\n" "${listIndent}" "${FW_ELEMENT_SIT_ORIG[${id}]}"
                printf "%s path:   %s\n" "${listIndent}" "${FW_ELEMENT_SIT_PATH_TEXT[${id}]}"
                printf "%s file:   %s\n" "${listIndent}" "${FW_ELEMENT_SIT_FILE[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_SIT_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi

            printf "\n    "; Format text regular,italic "Requirements and dependencies"; printf "\n"
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_APP[${id}]:-}" ]]; then
                    printf "%s applications:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_REQUIRED_APP[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DEP[${id}]:-}" ]]; then
                    printf "%s dependencies:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_REQUIRED_DEP[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_PAR[${id}]:-}" ]]; then
                    printf "%s parameters:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_REQUIRED_PAR[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_TSK[${id}]:-}" ]]; then
                    printf "%s tasks:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_REQUIRED_TSK[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_FILE[${id}]:-}" ]]; then
                    printf "%s files:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_REQUIRED_FILE[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_FILELIST[${id}]:-}" ]]; then
                    printf "%s file lists:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_REQUIRED_FILELIST[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DIR[${id}]:-}" ]]; then
                    printf "%s directories:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_REQUIRED_DIR[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DIRLIST[${id}]:-}" ]]; then
                    printf "%s directory lists:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_SIT_REQUIRED_DIRLIST[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
            ;;


        task)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing task id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            printf "\n"; Format tagline for task "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                printf "%s origin: %s\n" "${listIndent}" "${FW_ELEMENT_TSK_ORIG[${id}]}"
                printf "%s mode:   %s\n" "${listIndent}" "$(Format mode ${FW_ELEMENT_TSK_MODES[${id}]})"
                printf "%s path:   %s\n" "${listIndent}" "${FW_ELEMENT_TSK_PATH_TEXT[${id}]}"

            printf "\n    "; Format text regular,italic "Load and Status"; printf "\n"
                printf "%s status: %s\n" "${listIndent}" "$(Format element status ${FW_ELEMENT_TSK_STATUS[${id}]})"
                if [[ -n "${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]:-}" ]]; then
                    printf "%s comments: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUESTED[${id}]:-}" ]]; then
                    printf "%s requested by: " "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUESTED[${id}]}; do printf "\n        %s %s" "-" "${tmpString}"; done
                    printf "\n"
                fi

            printf "\n    "; Format text regular,italic "Requirements and dependencies"; printf "\n"
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_APP[${id}]:-}" ]]; then
                    printf "%s applications:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUIRED_APP[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]:-}" ]]; then
                    printf "%s dependencies:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]:-}" ]]; then
                    printf "%s parameters:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]:-}" ]]; then
                    printf "%s tasks:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FILE[${id}]:-}" ]]; then
                    printf "%s files:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUIRED_FILE[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]:-}" ]]; then
                    printf "%s file lists:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]:-}" ]]; then
                    printf "%s directories:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]:-}" ]]; then
                    printf "%s directory lists:\n" "${listIndent}"
                    for tmpString in ${FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]}; do printf "        %s %s\n" "-" "${tmpString}"; done
                fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
