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
## Add - action to add an entry to an element or data object
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Add() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local entry arr id shortId acronym elemCmd elemPath elemModes moduleId modulePath value category file message arguments description msgType errno number doWriteRT=false text path showExecution
    local shortOpt longOpt optArg
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        element | required | object )
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                element-module)
                    # Add element module ID ACRONYM PATH DESCR
                    if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 4 "$#"; return; fi
                    id="${1}"; acronym="${2:0:2}"; acronym="${acronym^^}"; elemPath="${3}"; description="${4}"
                    Test used module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    Test dir can read "${elemPath}"
                    FW_ELEMENT_MDS_LONG["${id}"]="${description}"
                    FW_ELEMENT_MDS_ACR["${id}"]="${acronym}"
                    FW_ELEMENT_MDS_PATH["${id}"]="${elemPath}"
                    FW_ELEMENT_MDS_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"

                    FW_ELEMENT_MDS_STATUS["${id}"]=N
                    FW_ELEMENT_MDS_STATUS_COMMENTS["${id}"]=" "
                    FW_ELEMENT_MDS_REQIN["${id}"]=" "
                    FW_ELEMENT_MDS_REQIN_COUNT["${id}"]=0

                    FW_ELEMENT_MDS_REQOUT_MDS["${id}"]=" "
                    FW_ELEMENT_MDS_REQOUT_COUNT["${id}"]=0
                    doWriteRT=true ;;


                element-application | element-dependency | element-dirlist | element-dir | element-filelist | element-file | element-parameter | element-project | element-scenario | element-site | element-task | \
                object-configuration | object-format | object-level | object-message | object-mode | object-phase | object-setting | object-theme | object-themeitem)
                    ## Add (element | object) x ID(1) with(2) 2...
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 2 "$#"; return; fi
                    if [[ "${2}" != "with" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1} to module ${FW_ELEMENT_MDS_PATH[${moduleId}]}" E803 "${2}"; return; fi
                    id="${1}"; moduleId="${FW_CURRENT_MODULE_NAME:-"☰API☷"}"; shift 2
                    Test existing module id "${moduleId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    modulePath=${FW_ELEMENT_MDS_PATH[${moduleId}]}
                    case ${cmd2} in

                        configuration)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                            id="${id^^}"; value="${1}"; description="${2}"
                            Test used configuration id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_CFG_LONG["${id}"]="${description}"
                            FW_OBJECT_CFG_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_CFG_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_CFG_VAL["${id}"]="${value}"
                            doWriteRT=true ;;

                        format)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                            id="${id,,}"; description="${1}"
                            Test used format id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_FMT_LONG["${id}"]="${description}"
                            FW_OBJECT_FMT_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_FMT_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteRT=true ;;

                        level)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                            id="${id,,}"; value="${1}"; text="${2}"; description="${3}"
                            Test used level id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_LVL_LONG["${id}"]="${description}"
                            FW_OBJECT_LVL_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_LVL_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_LVL_CHAR_ABBR["${id}"]="${value}"
                            FW_OBJECT_LVL_STRING_THM["${id}"]="${text}" ;;

                        message)
                            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 4 "$#"; return; fi
                            id="${id^}"; arguments="${1}"; message="${2}"; category="${3}"; description="${4}"
                            Test used message id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            case "${id:0:1}" in
                                E) msgType=error ;;
                                W) msgType=warning ;;
                                M) msgType=message ;;
                                I) msgType=info ;;
                                D) msgType=debug ;;
                                T) msgType=trace ;;
                                *) printf "Error in message add\n\n"; return ;;
##TODO ERROR MESSAGE
                            esac
                            FW_OBJECT_MSG_LONG["${id}"]="${description}"
                            FW_OBJECT_MSG_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_MSG_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_MSG_TYPE["${id}"]="${msgType}"
                            FW_OBJECT_MSG_CAT["${id}"]="${category}"
                            FW_OBJECT_MSG_ARGS["${id}"]="${arguments}"
                            FW_OBJECT_MSG_TEXT["${id}"]="${message}" ;;

                        mode)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                            id="${id,,}"; description="${1}"
                            Test used mode id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_MOD_LONG["${id}"]="${description}"
                            FW_OBJECT_MOD_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_MOD_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" ;;

                        phase)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                            description="${1}"
                            Test used phase id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_PHA_LONG["${id}"]="${description}"
                            FW_OBJECT_PHA_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_PHA_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_PHA_PRT_LVL["${id}"]=" fatalerror error warning "
                            FW_OBJECT_PHA_LOG_LVL["${id}"]=" fatalerror error message text warning info "
                            FW_OBJECT_PHA_ERRCNT["${id}"]="0"
                            FW_OBJECT_PHA_WRNCNT["${id}"]="0"
                            FW_OBJECT_PHA_MSGCOD["${id}"]=""
                            FW_OBJECT_PHA_MSGCODCNT["${id}"]=0
                            doWriteRT=true ;;

                        setting)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                            id="${id^^}"; value="${1}"; description="${2}"
                            Test used setting id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_SET_LONG["${id}"]="${description}"
                            FW_OBJECT_SET_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_SET_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_PHASET["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["${id}"]="${value}"
                            doWriteRT=true ;;

                        theme)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                            description="${1}"
                            Test used theme id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
##TODO error path does not exist
                            FW_OBJECT_THM_LONG["${id}"]="${description}"
                            FW_OBJECT_THM_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_THM_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteRT=true ;;

                        themeitem)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                            description="${1}"
                            Test used themeitem id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_TIM_LONG["${id}"]="${description}"
                            FW_OBJECT_TIM_DECMDS["${id}"]="${moduleId}"
                            FW_OBJECT_TIM_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_TIM_SOURCE["${id}"]=""
                            FW_OBJECT_TIM_VAL["${id}"]=""
                            doWriteRT=true ;;



                        application)
                            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 4 "$#"; return; fi
                            elemCmd="${1}"; number="${2}"; value="${3}"; description="${4}"
                            Test used application id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_APP_LONG["${id}"]="${description}"
                            FW_ELEMENT_APP_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_APP_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_APP_COMMAND["${id}"]="${elemCmd}"
                            FW_ELEMENT_APP_ARGNUM["${id}"]="${number}"
                            FW_ELEMENT_APP_ARGS["${id}"]="${value}"
                            FW_ELEMENT_APP_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"

                            FW_ELEMENT_APP_STATUS["${id}"]=N
                            FW_ELEMENT_APP_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_APP_REQIN["${id}"]=" "
                            FW_ELEMENT_APP_REQIN_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        dependency)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 2 "$#"; return; fi
                            elemCmd="${1}"; description="${2}"
                            Test used dependency id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_DEP_LONG["${id}"]="${description}"
                            FW_ELEMENT_DEP_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_DEP_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_DEP_COMMAND["${id}"]="${elemCmd}"
                            FW_ELEMENT_DEP_REQOUT_COUNT["${id}"]=0

                            FW_ELEMENT_DEP_STATUS["${id}"]=N
                            FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_DEP_REQIN["${id}"]=" "
                            FW_ELEMENT_DEP_REQIN_COUNT["${id}"]=0

                            FW_ELEMENT_DEP_REQOUT_DEP["${id}"]=" "
                            FW_ELEMENT_DEP_REQOUT_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        dirlist)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; value="${2}"; description="${3}"
                            Test used dirlist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test fs mode "${cmd2}" "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_DLS_LONG["${id}"]="${description}"
                            FW_ELEMENT_DLS_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_DLS_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_DLS_VAL["${id}"]="${value}"
                            FW_ELEMENT_DLS_MOD["${id}"]="${elemModes}"
                            FW_ELEMENT_DLS_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"

                            FW_ELEMENT_DLS_STATUS["${id}"]=N
                            FW_ELEMENT_DLS_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_DLS_REQIN["${id}"]=" "
                            FW_ELEMENT_DLS_REQIN_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        dir)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; value="${2}"; description="${3}"
                            Test used dir id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test fs mode "${cmd2}" "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_DIR_LONG["${id}"]="${description}"
                            FW_ELEMENT_DIR_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_DIR_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_DIR_VAL["${id}"]="${value}"
                            FW_ELEMENT_DIR_MOD["${id}"]="${elemModes}"
                            FW_ELEMENT_DIR_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"

                            FW_ELEMENT_DIR_STATUS["${id}"]=N
                            FW_ELEMENT_DIR_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_DIR_REQIN["${id}"]=" "
                            FW_ELEMENT_DIR_REQIN_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        filelist)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; value="${2}"; description="${3}"
                            Test used filelist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test fs mode "${cmd2}" "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_FLS_LONG["${id}"]="${description}"
                            FW_ELEMENT_FLS_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_FLS_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_FLS_VAL["${id}"]="${value}"
                            FW_ELEMENT_FLS_MOD["${id}"]="${elemModes}"
                            FW_ELEMENT_FLS_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"

                            FW_ELEMENT_FLS_STATUS["${id}"]=N
                            FW_ELEMENT_FLS_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_FLS_REQIN["${id}"]=" "
                            FW_ELEMENT_FLS_REQIN_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        file)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; value="${2}"; description="${3}"
                            Test used file id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test fs mode "${cmd2}" "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_FIL_LONG["${id}"]="${description}"
                            FW_ELEMENT_FIL_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_FIL_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_FIL_VAL["${id}"]="${value}"
                            FW_ELEMENT_FIL_MOD["${id}"]="${elemModes}"
                            FW_ELEMENT_FIL_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"

                            FW_ELEMENT_FIL_STATUS["${id}"]=N
                            FW_ELEMENT_FIL_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_FIL_REQIN["${id}"]=" "
                            FW_ELEMENT_FIL_REQIN_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        parameter)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 2 "$#"; return; fi
                            value="${1}"; description="${2}"
                            Test used parameter id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_PAR_LONG["${id}"]="${description}"
                            FW_ELEMENT_PAR_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_PAR_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_PAR_DEFVAL["${id}"]="${value}"
                            FW_ELEMENT_PAR_VAL["${id}"]=""
                            FW_ELEMENT_PAR_PHA["${id}"]="Default"

                            FW_ELEMENT_PAR_STATUS["${id}"]=N
                            FW_ELEMENT_PAR_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_PAR_REQIN["${id}"]=" "
                            FW_ELEMENT_PAR_REQIN_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        project)
                            if [[ "${#}" -lt 6 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 6 "$#"; return; fi
                            elemModes="${1}"; elemPath="${2}"; path="${3}"; value="${4}"; showExecution="${5}"; description="${6}"
                            Test used project id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            for entry in ${elemModes}; do Test existing mode id "${entry}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi; done
                            Test existing mode id "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test yesno "${showExecution}" "exec-extras"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            FW_ELEMENT_PRJ_LONG["${id}"]="${description}"
                            FW_ELEMENT_PRJ_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_PRJ_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_PRJ_MODES["${id}"]="test "
                            for entry in ${elemModes}; do if [[ "${entry}" != "test" ]]; then FW_ELEMENT_PRJ_MODES["${id}"]="${FW_ELEMENT_PRJ_MODES["${id}"]}${entry} "; fi; done
                            FW_ELEMENT_PRJ_PATH["${id}"]="${elemPath}"
                            FW_ELEMENT_PRJ_PATH_TEXT["${id}"]="${elemPath/$modulePath/$moduleId::}"
                            FW_ELEMENT_PRJ_RDIR["${id}"]="${path}"
                            FW_ELEMENT_PRJ_TGTS["${id}"]="${value}"
                            FW_ELEMENT_PRJ_SHOW_EXEC["${id}"]="${showExecution:0:1}"
                            FW_ELEMENT_PRJ_REQOUT_COUNT["${id}"]=0
##TODO path exists, is dir, path and id.sh is readable file

                            FW_ELEMENT_PRJ_STATUS["${id}"]=N
                            FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_PRJ_REQIN["${id}"]=" "
                            FW_ELEMENT_PRJ_REQIN_COUNT["${id}"]=0

                            FW_ELEMENT_PRJ_REQOUT_APP["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_DEP["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_DLS["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_DIR["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_FLS["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_FIL["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_PAR["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_PRJ["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_SCN["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_SIT["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_TSK["${id}"]=" "
                            FW_ELEMENT_PRJ_REQOUT_COUNT["${id}"]=0
                            doWriteRT=true ;;

                         scenario)
                            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 4 "$#"; return; fi
                            elemModes="${1}"; elemPath="${2}"; showExecution="${3,,}"; description="${4}"
                            Test used scenario id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            for entry in ${elemModes}; do Test existing mode id "${entry}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi; done
                            Test yesno "${showExecution}" "exec-extras"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            text="${elemPath/$FW_MODULE_PATH/(${moduleId})}"
                            file="${elemPath}/${id}.scn"
                            Test file can read "${file}" "${text}/${id}.scn"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            FW_ELEMENT_SCN_LONG["${id}"]="${description}"
                            FW_ELEMENT_SCN_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_SCN_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_SCN_MODES["${id}"]="test "
                            for entry in ${elemModes}; do if [[ "${entry}" != "test" ]]; then FW_ELEMENT_SCN_MODES["${id}"]="${FW_ELEMENT_SCN_MODES["${id}"]}${entry} "; fi; done
                            FW_ELEMENT_SCN_PATH["${id}"]="${elemPath}"
                            FW_ELEMENT_SCN_PATH_TEXT["${id}"]="${elemPath/$modulePath/$moduleId::}"
                            FW_ELEMENT_SCN_SHOW_EXEC["${id}"]="${showExecution:0:1}"
                            FW_ELEMENT_SCN_REQOUT_COUNT["${id}"]=0
                            alias scenario-${id}="Execute scenario ${id}"

                            FW_ELEMENT_SCN_STATUS["${id}"]=N
                            FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_SCN_REQIN["${id}"]=" "
                            FW_ELEMENT_SCN_REQIN_COUNT["${id}"]=0

                            FW_ELEMENT_SCN_REQOUT_APP["${id}"]=" "
                            FW_ELEMENT_SCN_REQOUT_SCN["${id}"]=" "
                            FW_ELEMENT_SCN_REQOUT_TSK["${id}"]=" "
                            FW_ELEMENT_SCN_REQOUT_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        site)
                            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 4 "$#"; return; fi
                            elemPath="${1}"; path="${2}"; showExecution="${3,,}"; description="${4}"
                            Test used site id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test yesno "${showExecution}" "exec-extras"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            FW_ELEMENT_SIT_LONG["${id}"]="${description}"
                            FW_ELEMENT_SIT_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_SIT_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_SIT_PATH["${id}"]="${elemPath}"
                            FW_ELEMENT_SIT_PATH_TEXT["${id}"]="${elemPath/$modulePath/$moduleId::}"
                            FW_ELEMENT_SIT_RDIR["${id}"]="${path}"
                            FW_ELEMENT_SIT_SHOW_EXEC["${id}"]="${showExecution:0:1}"
##TODO path exists, is dir, path and id.sh is executable file

                            FW_ELEMENT_SIT_STATUS["${id}"]=N
                            FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_SIT_REQIN["${id}"]=" "
                            FW_ELEMENT_SIT_REQIN_COUNT["${id}"]=0

                            FW_ELEMENT_SIT_REQOUT_APP["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_DEP["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_DLS["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_DIR["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_FLS["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_FIL["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_PAR["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_SCN["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_TSK["${id}"]=" "
                            FW_ELEMENT_SIT_REQOUT_COUNT["${id}"]=0
                            doWriteRT=true ;;

                        task)
                            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 4 "$#"; return; fi
                            elemModes="${1}"; elemPath="${2}"; showExecution="${3,,}"; description="${4}"
                            Test used task id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            for entry in ${elemModes}; do Test existing mode id "${entry}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi; done
                            Test yesno "${showExecution}" "exec-extras"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            text="${elemPath/$FW_MODULE_PATH/(${moduleId})}"
                            file="${elemPath}/${id}.sh"
                            Test file can execute "${file}" "${text}/${id}.sh"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            file="${elemPath}/${id}-completions.bash"
                            Test file can read "${file}" "${text}/${id}-completions.bash"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            FW_ELEMENT_TSK_LONG["${id}"]="${description}"
                            FW_ELEMENT_TSK_DECMDS["${id}"]="${moduleId}"
                            FW_ELEMENT_TSK_DECPHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_ELEMENT_TSK_MODES["${id}"]="test "
                            for entry in ${elemModes}; do if [[ "${entry}" != "test" ]]; then FW_ELEMENT_TSK_MODES["${id}"]="${FW_ELEMENT_TSK_MODES["${id}"]}${entry} "; fi; done
                            FW_ELEMENT_TSK_PATH["${id}"]="${elemPath}"
                            FW_ELEMENT_TSK_PATH_TEXT["${id}"]="${elemPath/$modulePath/$moduleId::}"
                            FW_ELEMENT_TSK_SHOW_EXEC["${id}"]="${showExecution:0:1}"
                            alias ${id}="Execute task ${id}"

                            FW_ELEMENT_TSK_STATUS["${id}"]=N
                            FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]=" "
                            FW_ELEMENT_TSK_REQIN["${id}"]=" "
                            FW_ELEMENT_TSK_REQIN_COUNT["${id}"]=0

                            FW_ELEMENT_TSK_REQOUT_APP["${id}"]=" "
                            FW_ELEMENT_TSK_REQOUT_DEP["${id}"]=" "
                            FW_ELEMENT_TSK_REQOUT_DLS["${id}"]=" "
                            FW_ELEMENT_TSK_REQOUT_DIR["${id}"]=" "
                            FW_ELEMENT_TSK_REQOUT_FLS["${id}"]=" "
                            FW_ELEMENT_TSK_REQOUT_FIL["${id}"]=" "
                            FW_ELEMENT_TSK_REQOUT_PAR["${id}"]=" "
                            FW_ELEMENT_TSK_REQOUT_TSK["${id}"]=" "
                            FW_ELEMENT_TSK_REQOUT_COUNT["${id}"]=0
                            doWriteRT=true ;;

                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac

    if [[ "${doWriteRT}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; Write slow config; doWriteRT=false; fi
}
