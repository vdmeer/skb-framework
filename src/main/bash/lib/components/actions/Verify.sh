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
## Verify - action to verify something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


##https://www.toolsqa.com/software-testing/difference-between-verification-and-validation/


function Verify() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local i id errno status dir file fileText modid modpath fsMode list element command appName
    if [[ -n "${FW_OBJECT_SET_VAL["APP_NAME2"]}" ]]; then appName="${FW_OBJECT_SET_VAL["APP_NAME2"]}"; else appName="${FW_OBJECT_SET_VAL["APP_NAME"]}"; fi

    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in

        elements)
            ##
            ## RESET STATUS, COMMENT, REQUESTED for all elements
            ##
            Report process info "${appName}" "reset status, comment, requested"
            for id in ${!FW_ELEMENT_APP_LONG[@]}; do FW_ELEMENT_APP_STATUS["${id}"]="N"; FW_ELEMENT_APP_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_APP_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_DEP_LONG[@]}; do FW_ELEMENT_DEP_STATUS["${id}"]="N"; FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_DEP_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_DLS_LONG[@]}; do FW_ELEMENT_DLS_STATUS["${id}"]="N"; FW_ELEMENT_DLS_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_DLS_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_DIR_LONG[@]}; do FW_ELEMENT_DIR_STATUS["${id}"]="N"; FW_ELEMENT_DIR_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_DIR_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_FLS_LONG[@]}; do FW_ELEMENT_FLS_STATUS["${id}"]="N"; FW_ELEMENT_FLS_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_FLS_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_FIL_LONG[@]}; do FW_ELEMENT_FIL_STATUS["${id}"]="N"; FW_ELEMENT_FIL_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_FIL_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_MDS_LONG[@]}; do FW_ELEMENT_MDS_STATUS["${id}"]="N"; FW_ELEMENT_MDS_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_MDS_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_PAR_LONG[@]}; do FW_ELEMENT_PAR_STATUS["${id}"]="N"; FW_ELEMENT_PAR_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_PAR_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_PRJ_LONG[@]}; do FW_ELEMENT_PRJ_STATUS["${id}"]="N"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_PRJ_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_SCN_LONG[@]}; do FW_ELEMENT_SCN_STATUS["${id}"]="N"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_SCN_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_SCR_LONG[@]}; do FW_ELEMENT_SCR_STATUS["${id}"]="N"; FW_ELEMENT_SCR_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_SCR_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_SIT_LONG[@]}; do FW_ELEMENT_SIT_STATUS["${id}"]="N"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_SIT_REQUESTED["${id}"]=""; done
            for id in ${!FW_ELEMENT_TSK_LONG[@]}; do FW_ELEMENT_TSK_STATUS["${id}"]="N"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]=""; FW_ELEMENT_TSK_REQUESTED["${id}"]=""; done


            ##
            ## BUILD REQUESTED for all elments
            ##
            Report process info "${appName}" "build dependency requested"
            for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                for entry in ${FW_ELEMENT_DEP_REQUIRED_DEP["${id}"]:-}; do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED["${entry}"]="dependency:${id}"; else FW_ELEMENT_DEP_REQUESTED["${entry}"]+=" dependency:${id}"; fi; done
            done

            Report process info "${appName}" "build module requested"
            for id in ${!FW_ELEMENT_MDS_LONG[@]}; do
                for entry in ${FW_ELEMENT_MDS_REQUIRED_MDS["${id}"]:-}; do if [[ ! -n "${FW_ELEMENT_MDS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_MDS_REQUESTED["${entry}"]="module:${id}"; else FW_ELEMENT_MDS_REQUESTED["${entry}"]+=" module:${id}"; fi; done
            done

            Report process info "${appName}" "build projects"
            for id in ${!FW_ELEMENT_PRJ_LONG[@]}; do
                
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_PRJ_MODES["${id}"]}" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_PRJ_MODES["${id}"]}" != "all" ]]; then continue; fi
                fi
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_APP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_APP_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_APP_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_DEP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_DEP_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_DLS["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DLS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DLS_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_DLS_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_DIR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DIR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DIR_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_DIR_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_FLS["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_FLS_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_FLS_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_FIL["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_FIL_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_FIL_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_PAR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_PAR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_PAR_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_PAR_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_PRJ["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_PRJ_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_PRJ_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_PRJ_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_SCN["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_SCN_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_SCN_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_SCN_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_SIT["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_SIT_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_SIT_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_SIT_REQUESTED["${entry}"]+=" project:${id}"; fi; done
                for entry in ${FW_ELEMENT_PRJ_REQUIRED_TSK["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED["${entry}"]="project:${id}"; else FW_ELEMENT_TSK_REQUESTED["${entry}"]+=" project:${id}"; fi; done
            done

            Report process info "${appName}" "build scenarios"
            for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SCN_MODES["${id}"]}" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SCN_MODES["${id}"]}" != "all" ]]; then continue; fi
                fi
                for entry in ${FW_ELEMENT_SCN_REQUIRED_APP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_APP_REQUESTED["${entry}"]="scenario:${id}"; else FW_ELEMENT_APP_REQUESTED["${entry}"]+=" scenario:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCN_REQUIRED_SCN["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_SCN_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_SCN_REQUESTED["${entry}"]="scenario:${id}"; else FW_ELEMENT_SCN_REQUESTED["${entry}"]+=" scenario:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCN_REQUIRED_TSK["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED["${entry}"]="scenario:${id}"; else FW_ELEMENT_TSK_REQUESTED["${entry}"]+=" scenario:${id}"; fi; done
            done

            Report process info "${appName}" "build scripts"
            for id in ${!FW_ELEMENT_SCR_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SCR_MODES["${id}"]}" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SCR_MODES["${id}"]}" != "all" ]]; then continue; fi
                fi
                for entry in ${FW_ELEMENT_SCR_REQUIRED_APP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_APP_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_APP_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_DEP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_DEP_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_DLS["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DLS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DLS_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_DLS_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_DIR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DIR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DIR_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_DIR_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_FLS["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_FLS_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_FLS_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_FIL["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_FIL_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_FIL_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_PAR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_PAR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_PAR_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_PAR_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_PRJ["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_PRJ_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_PRJ_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_PRJ_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_SCN["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_SCN_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_SCN_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_SCN_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_SCR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_SCR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_SCR_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_SCR_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_SIT["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_SIT_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_SIT_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_SIT_REQUESTED["${entry}"]+=" script:${id}"; fi; done
                for entry in ${FW_ELEMENT_SCR_REQUIRED_TSK["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED["${entry}"]="script:${id}"; else FW_ELEMENT_TSK_REQUESTED["${entry}"]+=" script:${id}"; fi; done
            done

            Report process info "${appName}" "build sites"
            for id in ${!FW_ELEMENT_SIT_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SIT_MODES["${id}"]}" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SIT_MODES["${id}"]}" != "all" ]]; then continue; fi
                fi
                for entry in ${FW_ELEMENT_SIT_REQUIRED_APP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_APP_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_APP_REQUESTED["${entry}"]+=" site:${id}"; fi; done
                for entry in ${FW_ELEMENT_SIT_REQUIRED_DEP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_DEP_REQUESTED["${entry}"]+=" site:${id}"; fi; done
                for entry in ${FW_ELEMENT_SIT_REQUIRED_DLS["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DLS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DLS_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_DLS_REQUESTED["${entry}"]+=" site:${id}"; fi; done
                for entry in ${FW_ELEMENT_SIT_REQUIRED_DIR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DIR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DIR_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_DIR_REQUESTED["${entry}"]+=" site:${id}"; fi; done
                for entry in ${FW_ELEMENT_SIT_REQUIRED_FLS["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_FLS_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_FLS_REQUESTED["${entry}"]+=" site:${id}"; fi; done
                for entry in ${FW_ELEMENT_SIT_REQUIRED_FIL["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_FIL_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_FIL_REQUESTED["${entry}"]+=" site:${id}"; fi; done
                for entry in ${FW_ELEMENT_SIT_REQUIRED_PAR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_PAR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_PAR_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_PAR_REQUESTED["${entry}"]+=" site:${id}"; fi; done
                for entry in ${FW_ELEMENT_SIT_REQUIRED_SCN["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_SCN_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_SCN_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_SCN_REQUESTED["${entry}"]+=" site:${id}"; fi; done
                for entry in ${FW_ELEMENT_SIT_REQUIRED_TSK["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED["${entry}"]="site:${id}"; else FW_ELEMENT_TSK_REQUESTED["${entry}"]+=" site:${id}"; fi; done
            done

            Report process info "${appName}" "build tasks"
            for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_TSK_MODES["${id}"]}" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_TSK_MODES["${id}"]}" != "all" ]]; then continue; fi
                fi
                for entry in ${FW_ELEMENT_TSK_REQUIRED_APP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_APP_REQUESTED["${entry}"]="task:${id}"; else FW_ELEMENT_APP_REQUESTED["${entry}"]+=" task:${id}"; fi; done
                for entry in ${FW_ELEMENT_TSK_REQUIRED_DEP["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED["${entry}"]="task:${id}"; else FW_ELEMENT_DEP_REQUESTED["${entry}"]+=" task:${id}"; fi; done
                for entry in ${FW_ELEMENT_TSK_REQUIRED_DLS["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DLS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DLS_REQUESTED["${entry}"]="task:${id}"; else FW_ELEMENT_DLS_REQUESTED["${entry}"]+=" task:${id}"; fi; done
                for entry in ${FW_ELEMENT_TSK_REQUIRED_DIR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_DIR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_DIR_REQUESTED["${entry}"]="task:${id}"; else FW_ELEMENT_DIR_REQUESTED["${entry}"]+=" task:${id}"; fi; done
                for entry in ${FW_ELEMENT_TSK_REQUIRED_FLS["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_FLS_REQUESTED["${entry}"]="task:${id}"; else FW_ELEMENT_FLS_REQUESTED["${entry}"]+=" task:${id}"; fi; done
                for entry in ${FW_ELEMENT_TSK_REQUIRED_FIL["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_FIL_REQUESTED["${entry}"]="task:${id}"; else FW_ELEMENT_FIL_REQUESTED["${entry}"]+=" task:${id}"; fi; done
                for entry in ${FW_ELEMENT_TSK_REQUIRED_PAR["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_PAR_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_PAR_REQUESTED["${entry}"]="task:${id}"; else FW_ELEMENT_PAR_REQUESTED["${entry}"]+=" task:${id}"; fi; done
                for entry in ${FW_ELEMENT_TSK_REQUIRED_TSK["${id}"]:-};   do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED["${entry}"]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED["${entry}"]="task:${id}"; else FW_ELEMENT_TSK_REQUESTED["${entry}"]+=" task:${id}"; fi; done
            done


            ##
            ## VERIFY APPLICATIONS
            ##
            Report process info "${appName}" "verify applications"
            for id in ${!FW_ELEMENT_APP_LONG[@]}; do
                if [[ -n "${FW_ELEMENT_APP_REQUESTED["${id}"]:-}" ]]; then
                    Test command ${FW_ELEMENT_APP_COMMAND["${id}"]} application "${id}"; errno=$?
                    if [[ "${errno}" != 0 ]]; then
                        FW_ELEMENT_APP_STATUS["${id}"]="E"; FW_ELEMENT_APP_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_APP_STATUS_COMMENTS["${id}"]}command(E) "
                    else
                        FW_ELEMENT_APP_STATUS["${id}"]="S"
                    fi
                fi
            done

            ##
            ## VERIFY DEPENDENCIES
            ##
            Report process info "${appName}" "verify dependencies"
            for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                if [[ -n "${FW_ELEMENT_DEP_REQUESTED["${id}"]:-}" ]]; then
                    Test command "${FW_ELEMENT_DEP_CMD["${id}"]}" dependency "${id}"; errno=$?
                    if [[ "${errno}" != 0 ]]; then
                        FW_ELEMENT_DEP_STATUS["${id}"]="E"; FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]}command(E) "
                    else
                        FW_ELEMENT_DEP_STATUS["${id}"]="S"
                    fi
                fi
            done

            ## Again for requested dependencies, once they are verified above
            for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                if [[ -n "${FW_ELEMENT_DEP_REQUESTED["${id}"]:-}" ]]; then
                    if [[ -n "${FW_ELEMENT_DEP_REQUIRED_DEP["${id}"]:-}" ]]; then
                        status="S"
                        for element in ${FW_ELEMENT_DEP_REQUIRED_DEP["${id}"]}; do
                            case "${FW_ELEMENT_DEP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 dependency "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]}dep(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 dependency "${element}"
                                    status="${status}E"; FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]}dep(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 dependency "${element}"
                                    status="${status}W"; FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]}dep(E):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                        case ${status} in
                            *E*)    FW_ELEMENT_DEP_STATUS["${id}"]=E ;;
                            *W*)    FW_ELEMENT_DEP_STATUS["${id}"]=W ;;
                            *S*)    FW_ELEMENT_DEP_STATUS["${id}"]=S ;;
                        esac
                    fi
                fi
            done

            ##
            ## VERIFY DIRECTORY LISTS / DIRLISTS
            ##
            Report process info "${appName}" "verify directory lists"
            for id in ${!FW_ELEMENT_DLS_LONG[@]}; do
                if [[ -n "${FW_ELEMENT_DLS_REQUESTED["${id}"]:-}" ]]; then
                    list="${FW_ELEMENT_DLS_VAL["${id}"]}"
                    fsMode=${FW_ELEMENT_DLS_MOD["${id}"]}; i=0
                    status="S"
                    for dir in $list; do
                        while [ ${i} -lt ${#fsMode} ]; do
                            char=${fsMode:$i:1}; errno=0
                            case "${char}" in
                                r)  Test dir can read "${dir}"; errno=$? ;;
                                w)  Test dir can write "${dir}"; errno=$? ;;
                                x)  Test dir can execute "${dir}"; errno=$? ;;
                                c)  Test dir can create ${dir}; errno=$? ;;
                                d)  Test dir can delete ${dir}; errno=$? ;;
                            esac
                            if [[ "${errno}" != 0 ]]; then
                                status="${status}E"
                                FW_ELEMENT_DLS_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_DLS_STATUS_COMMENTS["${id}"]}dir(E):${dir} "
                            else
                                status="${status}S"
                            fi
                            i=$(( i + 1 ))
                        done
                    done
                    case ${status} in
                        *E*)    FW_ELEMENT_DIR_STATUS["${id}"]=E ;;
                        *W*)    FW_ELEMENT_DIR_STATUS["${id}"]=W ;;
                        *S*)    FW_ELEMENT_DIR_STATUS["${id}"]=S ;;
                    esac
                fi
            done

            ##
            ## VERIFY DIRECTORIES / DIRS
            ##
            Report process info "${appName}" "verify directories"
            for id in ${!FW_ELEMENT_DIR_LONG[@]}; do
                if [[ -n "${FW_ELEMENT_DIR_REQUESTED["${id}"]:-}" ]]; then
                    dir=${FW_ELEMENT_DIR_VAL["${id}"]}
                    fsMode=${FW_ELEMENT_DIR_MOD["${id}"]}; i=0
                    status="S"
                    while [ ${i} -lt ${#fsMode} ]; do
                        char=${fsMode:$i:1}; errno=0
                        case "${char}" in
                            r)  Test dir can read "${dir}"; errno=$? ;;
                            w)  Test dir can write "${dir}"; errno=$? ;;
                            x)  Test dir can execute "${dir}"; errno=$? ;;
                            c)  Test dir can create ${dir}; errno=$? ;;
                            d)  Test dir can delete ${dir}; errno=$? ;;
                        esac
                        if [[ "${errno}" != 0 ]]; then
                            status="${status}E"
                            FW_ELEMENT_DIR_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_DIR_STATUS_COMMENTS["${id}"]}dir(E):${dir} "
                        else
                            status="${status}S"
                        fi
                        i=$(( i + 1 ))
                    done
                    case ${status} in
                        *E*)    FW_ELEMENT_DIR_STATUS["${id}"]=E ;;
                        *W*)    FW_ELEMENT_DIR_STATUS["${id}"]=W ;;
                        *S*)    FW_ELEMENT_DIR_STATUS["${id}"]=S ;;
                    esac
                fi
            done

            ##
            ## VERIFY FILE LISTS / FILELISTS
            ##
            Report process info "${appName}" "verify file lists"
            for id in ${!FW_ELEMENT_FLS_LONG[@]}; do
                if [[ -n "${FW_ELEMENT_FLS_REQUESTED["${id}"]:-}" ]]; then
                    list="${FW_ELEMENT_FLS_VAL["${id}"]}"
                    fsMode=${FW_ELEMENT_FLS_MOD["${id}"]}; i=0
                    status="S"
                    for file in $list; do
                        while [ ${i} -lt ${#fsMode} ]; do
                            char=${fsMode:$i:1}; errno=0
                            case "${char}" in
                                r)  Test file can read "${file}"; errno=$? ;;
                                w)  Test file can write "${file}"; errno=$? ;;
                                x)  Test file can execute "${file}"; errno=$? ;;
                                c)  Test file can create ${file}; errno=$? ;;
                                d)  Test file can delete ${file}; errno=$? ;;
                            esac
                            if [[ "${errno}" != 0 ]]; then
                                status="${status}E"
                                FW_ELEMENT_FLS_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_FLS_STATUS_COMMENTS["${id}"]}file(E):${file} "
                            else
                                status="${status}S"
                            fi
                            i=$(( i + 1 ))
                        done
                    done
                    case ${status} in
                        *E*)    FW_ELEMENT_FIL_STATUS["${id}"]=E ;;
                        *W*)    FW_ELEMENT_FIL_STATUS["${id}"]=W ;;
                        *S*)    FW_ELEMENT_FIL_STATUS["${id}"]=S ;;
                    esac
                fi
            done

            ##
            ## VERIFY FILES
            ##
            Report process info "${appName}" "verify files"
            for id in ${!FW_ELEMENT_FIL_LONG[@]}; do
                if [[ -n "${FW_ELEMENT_FIL_REQUESTED["${id}"]:-}" ]]; then
                    file=${FW_ELEMENT_FIL_VAL["${id}"]}
                    fsMode=${FW_ELEMENT_FIL_MOD["${id}"]}; i=0
                    status="S"
                    while [ ${i} -lt ${#fsMode} ]; do
                        char=${fsMode:$i:1}; errno=0
                        case "${char}" in
                            r)  Test file can read "${file}"; errno=$? ;;
                            w)  Test file can write "${file}"; errno=$? ;;
                            x)  Test file can execute "${file}"; errno=$? ;;
                            c)  Test file can create ${file}; errno=$? ;;
                            d)  Test file can delete ${file}; errno=$? ;;
                        esac
                        if [[ "${errno}" != 0 ]]; then
                            status="${status}E"
                            FW_ELEMENT_FIL_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_FIL_STATUS_COMMENTS["${id}"]}file(E):${file} "
                        else
                            status="${status}S"
                        fi
                        i=$(( i + 1 ))
                    done
                    case ${status} in
                        *E*)    FW_ELEMENT_FIL_STATUS["${id}"]=E ;;
                        *W*)    FW_ELEMENT_FIL_STATUS["${id}"]=W ;;
                        *S*)    FW_ELEMENT_FIL_STATUS["${id}"]=S ;;
                    esac
                fi
            done

            ##
            ## VERIFY MODULES
            ##
            Report process info "${appName}" "verify modules"

            ##
            ## VERIFY PARAMETERS
            ##
            Report process info "${appName}" "verify parameters"

            ##
            ## VERIFY TASKS
            ##
            Report process info "${appName}" "verify tasks"
            for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "test" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_TSK_MODES["${id}"]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_TSK_MODES["${id}"]}" != "all" ]]; then continue; fi; fi
                fi

                status="S"
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_APP["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_TSK_REQUIRED_APP["${id}"]}; do
                        case "${FW_ELEMENT_APP_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 application "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}app(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${element}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}app(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${element}"
                                status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}app(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DEP["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_TSK_REQUIRED_DEP["${id}"]}; do
                        case "${FW_ELEMENT_DEP_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 dependency "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dep(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 dependency "${element}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dep(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 dependency "${element}"
                                status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dep(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_PAR["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_TSK_REQUIRED_PAR["${id}"]}; do
                        case "${FW_ELEMENT_PAR_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 parameter "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}par(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 parameter "${element}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}par(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 parameter "${element}"
                                status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}par(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FIL["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_TSK_REQUIRED_FIL["${id}"]}; do
                        case "${FW_ELEMENT_FIL_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 file "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}fil(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 file "${element}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}fil(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 file "${element}"
                                status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}fil(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FLS["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_TSK_REQUIRED_FLS["${id}"]}; do
                        case "${FW_ELEMENT_FLS_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "file list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}fls(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "file list" "${element}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}fls(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "file list" "${element}"
                                status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}fls(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIR["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_TSK_REQUIRED_DIR["${id}"]}; do
                        case "${FW_ELEMENT_DIR_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 directory "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dir(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 directory "${element}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dir(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 directory "${element}"
                                status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dir(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DLS["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_TSK_REQUIRED_DLS["${id}"]}; do
                        case "${FW_ELEMENT_DLS_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "directory list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dls(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "directory list" "${element}"
                                status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dls(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "directory list" "${element}"
                                status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}dls(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi

                case ${status} in
                    *E*)    FW_ELEMENT_TSK_STATUS["${id}"]=E ;;
                    *W*)    FW_ELEMENT_TSK_STATUS["${id}"]=W ;;
                    *S*)    FW_ELEMENT_TSK_STATUS["${id}"]=S ;;
                esac
            done

            ## Again for requested tasks, once they are verified above
            for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_TSK_MODES["${id}"]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_TSK_MODES["${id}"]}" != "all" ]]; then continue; fi; fi
                if [[ -n "${FW_ELEMENT_TSK_REQUIRED_TSK["${id}"]:-}" ]]; then
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_TSK["${id}"]:-}" ]]; then
                        status="S"
                        for element in ${FW_ELEMENT_TSK_REQUIRED_TSK["${id}"]}; do
                            case "${FW_ELEMENT_TSK_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}tsk(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}tsk(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                    status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]}tsk(E):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                        case ${status} in
                            *E*)    FW_ELEMENT_TSK_STATUS["${id}"]=E ;;
                            *W*)    FW_ELEMENT_TSK_STATUS["${id}"]=W ;;
                            *S*)    FW_ELEMENT_TSK_STATUS["${id}"]=S ;;
                        esac
                    fi
                fi
            done

            ##
            ## VERIFY SCENARIOS
            ##
            Report process info "${appName}" "verify scenarios"
            for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "test" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SCN_MODES["${id}"]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SCN_MODES["${id}"]}" != "all" ]]; then continue; fi; fi
                fi

                status="S"
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_APP["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SCN_REQUIRED_APP["${id}"]}; do
                        case "${FW_ELEMENT_APP_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 application "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}app(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${element}"
                                status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}app(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${element}"
                                status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}app(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_TSK["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SCN_REQUIRED_TSK["${id}"]}; do
                        case "${FW_ELEMENT_TSK_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}tsk(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}tsk(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}tsk(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi

                case ${status} in
                    *E*)    FW_ELEMENT_SCN_STATUS["${id}"]=E ;;
                    *W*)    FW_ELEMENT_SCN_STATUS["${id}"]=W ;;
                    *S*)    FW_ELEMENT_SCN_STATUS["${id}"]=S ;;
                esac
            done

            ## Again for requested scenarios, once they are verified above
            for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SCN_MODES["${id}"]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SCN_MODES["${id}"]}" != "all" ]]; then continue; fi; fi
                if [[ -n "${FW_ELEMENT_SCN_REQUIRED_SCN["${id}"]:-}" ]]; then
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_SCN["${id}"]:-}" ]]; then
                        status="S"
                        for element in ${FW_ELEMENT_SCN_REQUIRED_SCN["${id}"]}; do
                            case "${FW_ELEMENT_SCN_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}scn(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}scn(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]}scn(E):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                        case ${status} in
                            *E*)    FW_ELEMENT_SCN_STATUS["${id}"]=E ;;
                            *W*)    FW_ELEMENT_SCN_STATUS["${id}"]=W ;;
                            *S*)    FW_ELEMENT_SCN_STATUS["${id}"]=S ;;
                        esac
                    fi
                fi
            done

            ##
            ## VERIFY PROJECTS
            ##
            Report process info "${appName}" "verify projects"
            for id in ${!FW_ELEMENT_PRJ_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "test" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_PRJ_MODES["${id}"]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_PRJ_MODES["${id}"]}" != "all" ]]; then continue; fi; fi
                fi

                status="S"
                if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_APP["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_PRJ_REQUIRED_APP["${id}"]}; do
                        case "${FW_ELEMENT_APP_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 application "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}app(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${element}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}app(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${element}"
                                status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}app(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DEP["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_PRJ_REQUIRED_DEP["${id}"]}; do
                        case "${FW_ELEMENT_DEP_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 dependency "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dep(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 dependency "${element}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dep(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 dependency "${element}"
                                status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dep(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_PAR["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_PRJ_REQUIRED_PAR["${id}"]}; do
                        case "${FW_ELEMENT_PAR_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 parameter "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}par(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 parameter "${element}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}par(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 parameter "${element}"
                                status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}par(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_TSK["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_PRJ_REQUIRED_TSK["${id}"]}; do
                        case "${FW_ELEMENT_TSK_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}tsk(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}tsk(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}tsk(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_FIL["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_PRJ_REQUIRED_FIL["${id}"]}; do
                        case "${FW_ELEMENT_FIL_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 file "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}fil(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 file "${element}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}fil(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 file "${element}"
                                status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}fil(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_FLS["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_PRJ_REQUIRED_FLS["${id}"]}; do
                        case "${FW_ELEMENT_FLS_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "file list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}fls(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "file list" "${element}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}fls(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "file list" "${element}"
                                status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}fls(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DIR["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_PRJ_REQUIRED_DIR["${id}"]}; do
                        case "${FW_ELEMENT_DIR_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 directory "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dir(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 directory "${element}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dir(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 directory "${element}"
                                status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dir(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DLS["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_PRJ_REQUIRED_DLS["${id}"]}; do
                        case "${FW_ELEMENT_DLS_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "directory list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dls(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "directory list" "${element}"
                                status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dls(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "directory list" "${element}"
                                status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]}dls(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi

                case ${status} in
                    *E*)    FW_ELEMENT_PRJ_STATUS["${id}"]=E ;;
                    *W*)    FW_ELEMENT_PRJ_STATUS["${id}"]=W ;;
                    *S*)    FW_ELEMENT_PRJ_STATUS["${id}"]=S ;;
                esac
            done

            ##
            ## VERIFY SITES
            ##
            Report process info "${appName}" "verifying sites"
            for id in ${!FW_ELEMENT_SIT_LONG[@]}; do
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "test" ]]; then
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SIT_MODES["${id}"]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SIT_MODES["${id}"]}" != "all" ]]; then continue; fi; fi
                fi

                status="S"
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_APP["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SIT_REQUIRED_APP["${id}"]}; do
                        case "${FW_ELEMENT_APP_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 application "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}app(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${element}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}app(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${element}"
                                status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}app(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_PAR["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SIT_REQUIRED_PAR["${id}"]}; do
                        case "${FW_ELEMENT_PAR_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 parameter "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}par(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 parameter "${element}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}par(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 parameter "${element}"
                                status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}par(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_SCN["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SIT_REQUIRED_SCN["${id}"]}; do
                        case "${FW_ELEMENT_SCN_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 scenario "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}scn(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 scenario "${element}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}scn(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 scenario "${element}"
                                status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}scn(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_TSK["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SIT_REQUIRED_TSK["${id}"]}; do
                        case "${FW_ELEMENT_TSK_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}tsk(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}tsk(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}tsk(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_FIL["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SIT_REQUIRED_FIL["${id}"]}; do
                        case "${FW_ELEMENT_FIL_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 file "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}fil(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 file "${element}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}fil(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 file "${element}"
                                status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}fil(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_FLS["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SIT_REQUIRED_FLS["${id}"]}; do
                        case "${FW_ELEMENT_FLS_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "file list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}fls(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "file list" "${element}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}fls(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "file list" "${element}"
                                status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}fls(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DIR["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SIT_REQUIRED_DIR["${id}"]}; do
                        case "${FW_ELEMENT_DIR_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 directory "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}dir(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 directory "${element}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}dir(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 directory "${element}"
                                status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}dir(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi
                if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DLS["${id}"]:-}" ]]; then
                    for element in ${FW_ELEMENT_SIT_REQUIRED_DLS["${id}"]}; do
                        case "${FW_ELEMENT_DLS_STATUS[${element}]}" in
                            N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "directory list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}dls(N):${element} " ;;
                            E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "directory list" "${element}"
                                status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}dls(E):${element} " ;;
                            W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "directory list" "${element}"
                                status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]}dls(W):${element} " ;;
                            S)  status="${status}S" ;;
                        esac
                    done
                fi

                case ${status} in
                    *E*)    FW_ELEMENT_SIT_STATUS["${id}"]=E ;;
                    *W*)    FW_ELEMENT_SIT_STATUS["${id}"]=W ;;
                    *S*)    FW_ELEMENT_SIT_STATUS["${id}"]=S ;;
                esac
            done

            Report process info "${appName}" "writing medium config file"
            Write medium config file ;;

        theme)
            Report process info "${appName}" "verifying theme and themeitems"
            if [[ "${FW_OBJECT_TIM_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_TIM_LONG[@]}; do
                    FW_OBJECT_TIM_STATUS["${id}"]="N"
                    case ${id} in
                        *Char)
                            case ${id} in
                                ## can be 0 (not set) or 1 (set
                                tableBottomruleChar | tableLegendruleChar | tableMidruleChar | tableStatusruleChar | tableTopruleChar | execEndRuleChar | execStartRuleChar | execLineChar | statsFullruleChar | statsHalfruleChar)
                                    if [[ "${#FW_OBJECT_TIM_VAL["${id}"]}" > 1 ]]; then
                                        Report process error "${FUNCNAME[0]}" "${cmdString1}" E816 "theme item" "${id}" 1 ${#FW_OBJECT_TIM_VAL["${id}"]}
                                        FW_OBJECT_TIM_STATUS["${id}"]="E"
                                    else
                                        FW_OBJECT_TIM_STATUS["${id}"]="S"
                                    fi ;;
                                    ## can be 0 (not set) or anything (set)
                                *)
                                    if [[ ! -n "${FW_OBJECT_TIM_VAL["${id}"]}" ]]; then
                                        Report process error "${FUNCNAME[0]}" "${cmdString1}" E815 "theme item" "${id}"
                                        FW_OBJECT_TIM_STATUS["${id}"]="E"
                                    elif [[ "${#FW_OBJECT_TIM_VAL["${id}"]}" > 1 ]]; then
                                        Report process error "${FUNCNAME[0]}" "${cmdString1}" E816 "theme item" "${id}" 1 ${#FW_OBJECT_TIM_VAL["${id}"]}
                                        FW_OBJECT_TIM_STATUS["${id}"]="E"
                                    else
                                        FW_OBJECT_TIM_STATUS["${id}"]="S"
                                    fi ;;
                            esac ;;
                        tableBgrndFmt | describeBgrndFmt | listBgrndFmt | execPrjBgrndFmt | execScnBgrndFmt | execScrBgrndFmt | execSitBgrndFmt | execTskBgrndFmt | repeatTskBgrndFmt | repeatScnBgrndFmt | repeatScrBgrndFmt)
                            FW_OBJECT_TIM_STATUS["${id}"]="S" ;;
                        *)
                            if [[ ! -n "${FW_OBJECT_TIM_VAL["${id}"]}" ]]; then
                                Report process error "${FUNCNAME[0]}" "${cmdString1}" E815 "theme item" "${id}"
                                FW_OBJECT_TIM_STATUS["${id}"]="E"
                            else
                                FW_OBJECT_TIM_STATUS["${id}"]="S"
                            fi ;;
                    esac
                done
            fi
            if [[ "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" != "Load" ]]; then Write slow config; fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
