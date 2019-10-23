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
## internal / verify - internal functions called by the API, verifying elements
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_internal_verify_01_reset () {
    Report process info "${1}" "reset status, comment, requested"

    ## do not change status for no retest
    for id in ${!FW_ELEMENT_APP_LONG[@]}; do
        if [[ "${FW_OBJECT_SET_VAL["RETEST_COMMANDS"]}" == "yes" ]]; then
            FW_ELEMENT_APP_STATUS["${id}"]="N"; FW_ELEMENT_APP_STATUS_COMMENTS["${id}"]=" "
        else
            FW_ELEMENT_APP_STATUS["${id}"]="${FW_ELEMENT_APP_STATUS["${id}"]}${FW_ELEMENT_APP_STATUS["${id}"]}"
        fi
        FW_ELEMENT_APP_REQIN["${id}"]=" "; FW_ELEMENT_APP_REQIN_COUNT["${id}"]=0
    done

    ## do not change status for no retest
    for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
        if [[ "${FW_OBJECT_SET_VAL["RETEST_COMMANDS"]}" == "yes" ]]; then
            FW_ELEMENT_DEP_STATUS["${id}"]="N"; FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]=" "
        else
            FW_ELEMENT_DEP_STATUS["${id}"]="${FW_ELEMENT_DEP_STATUS["${id}"]}${FW_ELEMENT_DEP_STATUS["${id}"]}"
        fi
        FW_ELEMENT_DEP_REQIN["${id}"]=" "; FW_ELEMENT_DEP_REQIN_COUNT["${id}"]=0
    done

    ## do not change status for no retest
    for id in ${!FW_ELEMENT_DLS_LONG[@]}; do
        if [[ "${FW_OBJECT_SET_VAL["RETEST_FS"]}" == "yes" ]]; then
            FW_ELEMENT_DLS_STATUS["${id}"]="N"; FW_ELEMENT_DLS_STATUS_COMMENTS["${id}"]=" "
        else
            FW_ELEMENT_DLS_STATUS["${id}"]="${FW_ELEMENT_DLS_STATUS["${id}"]}${FW_ELEMENT_DLS_STATUS["${id}"]}"
        fi
        FW_ELEMENT_DLS_REQIN["${id}"]=" "; FW_ELEMENT_DLS_REQIN_COUNT["${id}"]=0
    done

    ## do not change status for no retest
    for id in ${!FW_ELEMENT_FLS_LONG[@]}; do
        if [[ "${FW_OBJECT_SET_VAL["RETEST_FS"]}" == "yes" ]]; then
            FW_ELEMENT_FLS_STATUS["${id}"]="N"; FW_ELEMENT_FLS_STATUS_COMMENTS["${id}"]=" "
        else
            FW_ELEMENT_FLS_STATUS["${id}"]="${FW_ELEMENT_FLS_STATUS["${id}"]}${FW_ELEMENT_FLS_STATUS["${id}"]}"
        fi
        FW_ELEMENT_FLS_REQIN["${id}"]=" "; FW_ELEMENT_FLS_REQIN_COUNT["${id}"]=0
    done

    ## do not change status for no retest
    for id in ${!FW_ELEMENT_DIR_LONG[@]}; do
        if [[ "${FW_OBJECT_SET_VAL["RETEST_FS"]}" == "yes" ]]; then
            FW_ELEMENT_DIR_STATUS["${id}"]="N"; FW_ELEMENT_DIR_STATUS_COMMENTS["${id}"]=" "
        else
            FW_ELEMENT_DIR_STATUS["${id}"]="${FW_ELEMENT_DIR_STATUS["${id}"]}${FW_ELEMENT_DIR_STATUS["${id}"]}"
        fi
        FW_ELEMENT_DIR_REQIN["${id}"]=" "; FW_ELEMENT_DIR_REQIN_COUNT["${id}"]=0
    done

    ## do not change status for no retest
    for id in ${!FW_ELEMENT_FIL_LONG[@]}; do
        if [[ "${FW_OBJECT_SET_VAL["RETEST_FS"]}" == "yes" ]]; then
            FW_ELEMENT_FIL_STATUS["${id}"]="N"; FW_ELEMENT_FIL_STATUS_COMMENTS["${id}"]=" "
        else
            FW_ELEMENT_FIL_STATUS["${id}"]="${FW_ELEMENT_FIL_STATUS["${id}"]}${FW_ELEMENT_FIL_STATUS["${id}"]}"
        fi
        FW_ELEMENT_FIL_REQIN["${id}"]=" "; FW_ELEMENT_FIL_REQIN_COUNT["${id}"]=0
    done

    ## do a complete reset
    for id in ${!FW_ELEMENT_MDS_LONG[@]}; do FW_ELEMENT_MDS_STATUS["${id}"]="N"; FW_ELEMENT_MDS_STATUS_COMMENTS["${id}"]=" "; FW_ELEMENT_MDS_REQIN["${id}"]=" "; FW_ELEMENT_MDS_REQIN_COUNT["${id}"]=0; done
    for id in ${!FW_ELEMENT_PAR_LONG[@]}; do FW_ELEMENT_PAR_STATUS["${id}"]="N"; FW_ELEMENT_PAR_STATUS_COMMENTS["${id}"]=" "; FW_ELEMENT_PAR_REQIN["${id}"]=" "; FW_ELEMENT_PAR_REQIN_COUNT["${id}"]=0; done
    for id in ${!FW_ELEMENT_PRJ_LONG[@]}; do FW_ELEMENT_PRJ_STATUS["${id}"]="N"; FW_ELEMENT_PRJ_STATUS_COMMENTS["${id}"]=" "; FW_ELEMENT_PRJ_REQIN["${id}"]=" "; FW_ELEMENT_PRJ_REQIN_COUNT["${id}"]=0; done
    for id in ${!FW_ELEMENT_SCN_LONG[@]}; do FW_ELEMENT_SCN_STATUS["${id}"]="N"; FW_ELEMENT_SCN_STATUS_COMMENTS["${id}"]=" "; FW_ELEMENT_SCN_REQIN["${id}"]=" "; FW_ELEMENT_SCN_REQIN_COUNT["${id}"]=0; done
    for id in ${!FW_ELEMENT_SCR_LONG[@]}; do FW_ELEMENT_SCR_STATUS["${id}"]="N"; FW_ELEMENT_SCR_STATUS_COMMENTS["${id}"]=" "; FW_ELEMENT_SCR_REQIN["${id}"]=" "; FW_ELEMENT_SCR_REQIN_COUNT["${id}"]=0; done
    for id in ${!FW_ELEMENT_SIT_LONG[@]}; do FW_ELEMENT_SIT_STATUS["${id}"]="N"; FW_ELEMENT_SIT_STATUS_COMMENTS["${id}"]=" "; FW_ELEMENT_SIT_REQIN["${id}"]=" "; FW_ELEMENT_SIT_REQIN_COUNT["${id}"]=0; done
    for id in ${!FW_ELEMENT_TSK_LONG[@]}; do FW_ELEMENT_TSK_STATUS["${id}"]="N"; FW_ELEMENT_TSK_STATUS_COMMENTS["${id}"]=" "; FW_ELEMENT_TSK_REQIN["${id}"]=" "; FW_ELEMENT_TSK_REQIN_COUNT["${id}"]=0; done
}



function __skb_internal_verify_02_recurse () {
    local id
    Report process info "${1}" "recurse"

    Report process debug "${1}" "recurse entry: scripts"
    for id in ${!FW_ELEMENT_SCR_LONG[@]}; do
        __skb_internal_verify_none_terminal_script "fw" "fw" "${id}"
    done

    Report process debug "${1}" "recurse entry: projects"
    for id in ${!FW_ELEMENT_PRJ_LONG[@]}; do
        __skb_internal_verify_none_terminal_project "fw" "fw" "${id}"
    done

    Report process debug "${1}" "recurse entry: sites"
    for id in ${!FW_ELEMENT_SIT_LONG[@]}; do
        __skb_internal_verify_none_terminal_site "fw" "fw" "${id}"
    done

    Report process debug "${1}" "recurse entry: scenarios"
    for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
        __skb_internal_verify_none_terminal_scenario "fw" "fw" "${id}"
    done

    Report process debug "${1}" "recurse entry: tasks"
    for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
        __skb_internal_verify_none_terminal_task "fw" "fw" "${id}"
    done

    Report process debug "${1}" "recurse: fix status for app, dep, dls, dir, fls, fil"
    for id in ${!FW_ELEMENT_APP_LONG[@]}; do FW_ELEMENT_APP_STATUS["${id}"]="${FW_ELEMENT_APP_STATUS["${id}"]:0:1}"; done
    for id in ${!FW_ELEMENT_DEP_LONG[@]}; do FW_ELEMENT_DEP_STATUS["${id}"]="${FW_ELEMENT_DEP_STATUS["${id}"]:0:1}"; done
    for id in ${!FW_ELEMENT_DLS_LONG[@]}; do FW_ELEMENT_DLS_STATUS["${id}"]="${FW_ELEMENT_DLS_STATUS["${id}"]:0:1}"; done
    for id in ${!FW_ELEMENT_FLS_LONG[@]}; do FW_ELEMENT_FLS_STATUS["${id}"]="${FW_ELEMENT_FLS_STATUS["${id}"]:0:1}"; done
    for id in ${!FW_ELEMENT_DIR_LONG[@]}; do FW_ELEMENT_DIR_STATUS["${id}"]="${FW_ELEMENT_DIR_STATUS["${id}"]:0:1}"; done
    for id in ${!FW_ELEMENT_FIL_LONG[@]}; do FW_ELEMENT_FIL_STATUS["${id}"]="${FW_ELEMENT_FIL_STATUS["${id}"]:0:1}"; done
}



##
## None-Terminal Dependency: set REQIN from parrent, test if required
##
function __skb_internal_verify_none_terminal_dependency () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" doTest=false child
    Report process trace "none-terminal dep ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_DEP_REQIN["${id}"]="${FW_ELEMENT_DEP_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_DEP_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_DEP_REQIN_COUNT["${id}"] + 1 ))

    case ${FW_ELEMENT_DEP_STATUS["${id}"]} in
        EE* | WW* | SS*)
            doTest=false; FW_ELEMENT_DEP_STATUS["${id}"]="${FW_ELEMENT_DEP_STATUS["${id}"]:0:1}" ;;
        NN*)
            doTest=true; FW_ELEMENT_DEP_STATUS["${id}"]="${FW_ELEMENT_DEP_STATUS["${id}"]:0:1}" ;;
        N)
            doTest=true ;;
        *)
            doTest=false ;;
    esac

    if [[ ${doTest} == true ]]; then
        Test command ${FW_ELEMENT_DEP_COMMAND["${id}"]} "dependency" "${id}, in verify"; errno=$?
        if [[ "${errno}" != 0 ]]; then
            FW_ELEMENT_DEP_STATUS["${id}"]="E"
            FW_ELEMENT_DEP_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]}command(E) "
        else
            FW_ELEMENT_DEP_STATUS["${id}"]="S"
        fi
    fi

    if [[ "${FW_ELEMENT_DEP_STATUS["${id}"]}" != "S" ]]; then return; fi

    local status="S"
    for child in ${FW_ELEMENT_DEP_REQOUT_DEP["${id}"]:-}; do __skb_internal_verify_none_terminal_dependency     "dep" "${id}" "${child}"; status="${status}${FW_ELEMENT_DEP_STATUS["${child}"]}"; done
    case ${status} in
        *E*)    FW_ELEMENT_DEP_STATUS["${id}"]=E ;;
        *W*)    FW_ELEMENT_DEP_STATUS["${id}"]=W ;;
        *S*)    FW_ELEMENT_DEP_STATUS["${id}"]=S ;;
    esac
}



##
## None-Terminal Script: set REQIN from parrent, test if required
##
function __skb_internal_verify_none_terminal_script () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" child
    Report process trace "none-terminal scr ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_SCR_REQIN["${id}"]="${FW_ELEMENT_SCR_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_SCR_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_SCR_REQIN_COUNT["${id}"] + 1 ))

    ## do not test if not in current mode
    case "${FW_ELEMENT_SCR_MODES["${id}"]}" in
        *"${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"*) ;;
        *) return ;;
    esac

    ## only test if not already tested
    if [[ "${FW_ELEMENT_SCR_STATUS["${id}"]}" == "N" ]]; then
        Report process debug "none-terminal scr ${id}  >>>  do test"
        local status="S"

        for child in ${FW_ELEMENT_SCR_REQOUT_SCR["${id}"]:-}; do __skb_internal_verify_none_terminal_script         "scr" "${id}" "${child}"; status="$FW_ELEMENT_SCR_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_PRJ["${id}"]:-}; do __skb_internal_verify_none_terminal_project        "scr" "${id}" "${child}"; status="$FW_ELEMENT_PRJ_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_SIT["${id}"]:-}; do __skb_internal_verify_none_terminal_site           "scr" "${id}" "${child}"; status="$FW_ELEMENT_SIT_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_SCN["${id}"]:-}; do __skb_internal_verify_none_terminal_scenario       "scr" "${id}" "${child}"; status="$FW_ELEMENT_SCN_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_TSK["${id}"]:-}; do __skb_internal_verify_none_terminal_task           "scr" "${id}" "${child}"; status="$FW_ELEMENT_TSK_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_DEP["${id}"]:-}; do __skb_internal_verify_none_terminal_dependency     "scr" "${id}" "${child}"; status="$FW_ELEMENT_DEP_STATUS{["${child}"]}"; done

        for child in ${FW_ELEMENT_SCR_REQOUT_APP["${id}"]:-}; do __skb_internal_verify_terminal_application         "scr" "${id}" "${child}"; status="$FW_ELEMENT_APP_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_DLS["${id}"]:-}; do __skb_internal_verify_terminal_dirlist             "scr" "${id}" "${child}"; status="$FW_ELEMENT_DLS_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_DIR["${id}"]:-}; do __skb_internal_verify_terminal_dir                 "scr" "${id}" "${child}"; status="$FW_ELEMENT_DIR_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_FLS["${id}"]:-}; do __skb_internal_verify_terminal_filelist            "scr" "${id}" "${child}"; status="$FW_ELEMENT_FLS_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_FIL["${id}"]:-}; do __skb_internal_verify_terminal_file                "scr" "${id}" "${child}"; status="$FW_ELEMENT_FIL_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SCR_REQOUT_PAR["${id}"]:-}; do __skb_internal_verify_terminal_parameter           "scr" "${id}" "${child}"; status="$FW_ELEMENT_PAR_STATUS{["${child}"]}"; done

        case ${status} in
            *E*)    FW_ELEMENT_SCR_STATUS["${id}"]=E ;;
            *W*)    FW_ELEMENT_SRC_STATUS["${id}"]=W ;;
            *S*)    FW_ELEMENT_SRC_STATUS["${id}"]=S ;;
        esac
    fi
}



##
## None-Terminal Project: set REQIN from parrent, test if required
##
function __skb_internal_verify_none_terminal_project () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" child
    Report process trace "none-terminal prj ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_PRJ_REQIN["${id}"]="${FW_ELEMENT_PRJ_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_RJ_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_PRJ_REQIN_COUNT["${id}"] + 1 ))

    ## do not test if not in current mode
    case "${FW_ELEMENT_PRJ_MODES["${id}"]}" in
        *"${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"*) ;;
        *) return ;;
    esac

    ## only test if not already tested
    if [[ "${FW_ELEMENT_PRJ_STATUS["${id}"]}" == "N" ]]; then
        Report process debug "none-terminal prj ${id}  >>>  do test"
        local status="S"

        for child in ${FW_ELEMENT_PRJ_REQOUT_PRJ["${id}"]:-}; do __skb_internal_verify_none_terminal_project        "prj" "${id}" "${child}"; status="$FW_ELEMENT_PRJ_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_SIT["${id}"]:-}; do __skb_internal_verify_none_terminal_site           "prj" "${id}" "${child}"; status="$FW_ELEMENT_SIT_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_SCN["${id}"]:-}; do __skb_internal_verify_none_terminal_scenario       "prj" "${id}" "${child}"; status="$FW_ELEMENT_SCN_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_TSK["${id}"]:-}; do __skb_internal_verify_none_terminal_task           "prj" "${id}" "${child}"; status="$FW_ELEMENT_TSK_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_DEP["${id}"]:-}; do __skb_internal_verify_none_terminal_dependency     "prj" "${id}" "${child}"; status="$FW_ELEMENT_DEP_STATUS{["${child}"]}"; done

        for child in ${FW_ELEMENT_PRJ_REQOUT_APP["${id}"]:-}; do __skb_internal_verify_terminal_application         "prj" "${id}" "${child}"; status="$FW_ELEMENT_APP_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_DLS["${id}"]:-}; do __skb_internal_verify_terminal_dirlist             "prj" "${id}" "${child}"; status="$FW_ELEMENT_DLS_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_DIR["${id}"]:-}; do __skb_internal_verify_terminal_dir                 "prj" "${id}" "${child}"; status="$FW_ELEMENT_DIR_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_FLS["${id}"]:-}; do __skb_internal_verify_terminal_filelist            "prj" "${id}" "${child}"; status="$FW_ELEMENT_FLS_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_FIL["${id}"]:-}; do __skb_internal_verify_terminal_file                "prj" "${id}" "${child}"; status="$FW_ELEMENT_FIL_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_PRJ_REQOUT_PAR["${id}"]:-}; do __skb_internal_verify_terminal_parameter           "prj" "${id}" "${child}"; status="$FW_ELEMENT_PAR_STATUS{["${child}"]}"; done

        case ${status} in
            *E*)    FW_ELEMENT_PRJ_STATUS["${id}"]=E ;;
            *W*)    FW_ELEMENT_PRJ_STATUS["${id}"]=W ;;
            *S*)    FW_ELEMENT_PRJ_STATUS["${id}"]=S ;;
        esac
    fi
}



##
## None-Terminal Site: set REQIN from parrent, test if required
##
function __skb_internal_verify_none_terminal_site () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" child
    Report process trace "none-terminal sit ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_SIT_REQIN["${id}"]="${FW_ELEMENT_SIT_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_SIT_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_SIT_REQIN_COUNT["${id}"] + 1 ))

    ## do not test if not in current mode
    case "${FW_ELEMENT_SIT_MODES["${id}"]}" in
        *"${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"*) ;;
        *) return ;;
    esac

    ## only test if not already tested
    if [[ "${FW_ELEMENT_SIT_STATUS["${id}"]}" == "N" ]]; then
        Report process debug "none-terminal sit ${id}  >>>  do test"
        local status="S"

        for child in ${FW_ELEMENT_SIT_REQOUT_SCN["${id}"]:-}; do __skb_internal_verify_none_terminal_scenario       "sit" "${id}" "${child}"; status="$FW_ELEMENT_SCN_STATUS{["${child}"]}"; done
        for child in ${FW_ELEMENT_SIT_REQOUT_TSK["${id}"]:-}; do __skb_internal_verify_none_terminal_task           "sit" "${id}" "${child}"; status="${FW_ELEMENT_TSK_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_SIT_REQOUT_DEP["${id}"]:-}; do __skb_internal_verify_none_terminal_dependency     "sit" "${id}" "${child}"; status="${FW_ELEMENT_DEP_STATUS["${child}"]}"; done

        for child in ${FW_ELEMENT_SIT_REQOUT_APP["${id}"]:-}; do __skb_internal_verify_terminal_application         "sit" "${id}" "${child}"; status="${FW_ELEMENT_APP_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_SIT_REQOUT_DLS["${id}"]:-}; do __skb_internal_verify_terminal_dirlist             "sit" "${id}" "${child}"; status="${FW_ELEMENT_DLS_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_SIT_REQOUT_DIR["${id}"]:-}; do __skb_internal_verify_terminal_dir                 "sit" "${id}" "${child}"; status="${FW_ELEMENT_DIR_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_SIT_REQOUT_FLS["${id}"]:-}; do __skb_internal_verify_terminal_filelist            "sit" "${id}" "${child}"; status="${FW_ELEMENT_FLS_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_SIT_REQOUT_FIL["${id}"]:-}; do __skb_internal_verify_terminal_file                "sit" "${id}" "${child}"; status="${FW_ELEMENT_FIL_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_SIT_REQOUT_PAR["${id}"]:-}; do __skb_internal_verify_terminal_parameter           "sit" "${id}" "${child}"; status="${FW_ELEMENT_PAR_STATUS["${child}"]}"; done

        case ${status} in
            *E*)    FW_ELEMENT_SIT_STATUS["${id}"]=E ;;
            *W*)    FW_ELEMENT_SIT_STATUS["${id}"]=W ;;
            *S*)    FW_ELEMENT_SIT_STATUS["${id}"]=S ;;
        esac
    fi
}



##
## None-Terminal Scenario: set REQIN from parrent, test if required
##
function __skb_internal_verify_none_terminal_scenario () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" child
    Report process trace "none-terminal scn ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_SCN_REQIN["${id}"]="${FW_ELEMENT_SCN_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_SCN_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_SCN_REQIN_COUNT["${id}"] + 1 ))

    ## do not test if not in current mode
    case "${FW_ELEMENT_SCN_MODES["${id}"]}" in
        *"${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"*) ;;
        *) return ;;
    esac

    ## only test if not already tested
    if [[ "${FW_ELEMENT_SCN_STATUS["${id}"]}" == "N" ]]; then
        Report process debug "none-terminal scn ${id}  >>>  do test"
        local status="S"

        for child in ${FW_ELEMENT_SCN_REQOUT_SCN["${id}"]:-}; do __skb_internal_verify_none_terminal_script         "scn" "${id}" "${child}"; status="${status}${FW_ELEMENT_SCN_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_SCN_REQOUT_TSK["${id}"]:-}; do __skb_internal_verify_none_terminal_task           "scn" "${id}" "${child}"; status="${status}${FW_ELEMENT_TSK_STATUS["${child}"]}"; done

        for child in ${FW_ELEMENT_SCN_REQOUT_APP["${id}"]:-}; do __skb_internal_verify_terminal_application         "scn" "${id}" "${child}"; status="${status}${FW_ELEMENT_APP_STATUS["${child}"]}"; done

        case ${status} in
            *E*)    FW_ELEMENT_SCN_STATUS["${id}"]=E ;;
            *W*)    FW_ELEMENT_SCN_STATUS["${id}"]=W ;;
            *S*)    FW_ELEMENT_SCN_STATUS["${id}"]=S ;;
        esac
    fi
}



##
## None-Terminal Task: set REQIN from parrent, test if required
##
function __skb_internal_verify_none_terminal_task () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" child
    Report process trace "none-terminal tsk ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_TSK_REQIN["${id}"]="${FW_ELEMENT_TSK_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_TSK_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_TSK_REQIN_COUNT["${id}"] + 1 ))

    ## do not test if not in current mode
    case "${FW_ELEMENT_TSK_MODES["${id}"]}" in
        *"${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"*) ;;
        *) return ;;
    esac

    ## only test if not already tested
    if [[ "${FW_ELEMENT_TSK_STATUS["${id}"]}" == "N" ]]; then
        Report process debug "none-terminal tsk ${id}  >>>  do test"
        local status="S"

        for child in ${FW_ELEMENT_TSK_REQOUT_TSK["${id}"]:-}; do __skb_internal_verify_terminal_task                "tsk" "${id}" "${child}"; status="${status}${FW_ELEMENT_TSK_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_TSK_REQOUT_DEP["${id}"]:-}; do __skb_internal_verify_none_terminal_dependency     "tsk" "${id}" "${child}"; status="${status}${FW_ELEMENT_DEP_STATUS["${child}"]}"; done

        for child in ${FW_ELEMENT_TSK_REQOUT_APP["${id}"]:-}; do __skb_internal_verify_terminal_application         "tsk" "${id}" "${child}"; status="${status}${FW_ELEMENT_APP_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_TSK_REQOUT_DLS["${id}"]:-}; do __skb_internal_verify_terminal_dirlist             "tsk" "${id}" "${child}"; status="${status}${FW_ELEMENT_DLS_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_TSK_REQOUT_DIR["${id}"]:-}; do __skb_internal_verify_terminal_dir                 "tsk" "${id}" "${child}"; status="${status}${FW_ELEMENT_DIR_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_TSK_REQOUT_FLS["${id}"]:-}; do __skb_internal_verify_terminal_filelist            "tsk" "${id}" "${child}"; status="${status}${FW_ELEMENT_FLS_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_TSK_REQOUT_FIL["${id}"]:-}; do __skb_internal_verify_terminal_file                "tsk" "${id}" "${child}"; status="${status}${FW_ELEMENT_FIL_STATUS["${child}"]}"; done
        for child in ${FW_ELEMENT_TSK_REQOUT_PAR["${id}"]:-}; do __skb_internal_verify_terminal_parameter           "tsk" "${id}" "${child}"; status="${status}${FW_ELEMENT_PAR_STATUS["${child}"]}"; done

        case ${status} in
            *E*)    FW_ELEMENT_TSK_STATUS["${id}"]=E ;;
            *W*)    FW_ELEMENT_TSK_STATUS["${id}"]=W ;;
            *S*)    FW_ELEMENT_TSK_STATUS["${id}"]=S ;;
        esac

    else
        Report process debug "none-terminal tsk ${id}  >>>  do not test"
    fi
}




##
## Terminal Application: set REQIN from parrent, test if required
##
function __skb_internal_verify_terminal_application () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" doTest=false
    Report process trace "terminal app ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_APP_REQIN["${id}"]="${FW_ELEMENT_APP_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_APP_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_APP_REQIN_COUNT["${id}"] + 1 ))

    case ${FW_ELEMENT_APP_STATUS["${id}"]} in
        EE* | WW* | SS*)
            doTest=false; FW_ELEMENT_APP_STATUS["${id}"]="${FW_ELEMENT_APP_STATUS["${id}"]:0:1}" ;;
        NN*)
            doTest=true; FW_ELEMENT_APP_STATUS["${id}"]="${FW_ELEMENT_APP_STATUS["${id}"]:0:1}" ;;
        N)
            doTest=true ;;
        *)
            doTest=false ;;
    esac

    if [[ ${doTest} == true ]]; then
        Test command ${FW_ELEMENT_APP_COMMAND[${id}]} application "${id}, in verify"; errno=$?
        if [[ "${errno}" != 0 ]]; then
            FW_ELEMENT_APP_STATUS["${id}"]="E"
            FW_ELEMENT_APP_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_APP_STATUS_COMMENTS[${id}]}command(E) "
        else
            FW_ELEMENT_APP_STATUS["${id}"]="S"
        fi
    fi
}



##
## Terminal Dirlist: set REQIN from parrent, test if required
##
function __skb_internal_verify_terminal_dirlist () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" doTest=false
    Report process trace "terminal dirlist ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_DLS_REQIN["${id}"]="${FW_ELEMENT_DLS_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_DLS_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_DLS_REQIN_COUNT["${id}"] + 1 ))

    case ${FW_ELEMENT_DLS_STATUS["${id}"]} in
        EE* | WW* | SS*)
            doTest=false; FW_ELEMENT_DLS_STATUS["${id}"]="${FW_ELEMENT_DLS_STATUS["${id}"]:0:1}" ;;
        NN*)
            doTest=true; FW_ELEMENT_DLS_STATUS["${id}"]="${FW_ELEMENT_DLS_STATUS["${id}"]:0:1}" ;;
        N)
            doTest=true ;;
        *)
            doTest=false ;;
    esac

    if [[ ${doTest} == true ]]; then
        local dir char i
        local list="${FW_ELEMENT_DLS_VAL["${id}"]}"
        local fsMode=${FW_ELEMENT_DLS_MOD["${id}"]}; i=0
        local status="S"
        for dir in $list; do
            while [ ${i} -lt ${#fsMode} ]; do
                char=${fsMode:$i:1}; errno=0
                case "${char}" in
                    r)  Test dir can read "${dir}";    errno=$? ;;
                    w)  Test dir can write "${dir}";   errno=$? ;;
                    x)  Test dir can execute "${dir}"; errno=$? ;;
                    c)  Test dir can create ${dir};    errno=$? ;;
                    d)  Test dir can delete ${dir};    errno=$? ;;
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
            *E*)    FW_ELEMENT_DLS_STATUS["${id}"]=E ;;
            *W*)    FW_ELEMENT_DLS_STATUS["${id}"]=W ;;
            *S*)    FW_ELEMENT_DLS_STATUS["${id}"]=S ;;
        esac
    fi
}



##
## Terminal Dir: set REQIN from parrent, test if required
##
function __skb_internal_verify_terminal_dir () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" doTest=false
    Report process trace "terminal dir ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_DIR_REQIN["${id}"]="${FW_ELEMENT_DIR_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_DIR_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_DIR_REQIN_COUNT["${id}"] + 1 ))

    case ${FW_ELEMENT_DIR_STATUS["${id}"]} in
        EE* | WW* | SS*)
            doTest=false; FW_ELEMENT_DIR_STATUS["${id}"]="${FW_ELEMENT_DIR_STATUS["${id}"]:0:1}" ;;
        NN*)
            doTest=true; FW_ELEMENT_DIR_STATUS["${id}"]="${FW_ELEMENT_DIR_STATUS["${id}"]:0:1}" ;;
        N)
            doTest=true ;;
        *)
            doTest=false ;;
    esac

    if [[ ${doTest} == true ]]; then
        local char i
        local dir=${FW_ELEMENT_DIR_VAL["${id}"]}
        local fsMode=${FW_ELEMENT_DIR_MOD["${id}"]}; i=0
        local status="S"
        while [ ${i} -lt ${#fsMode} ]; do
            char=${fsMode:$i:1}; errno=0
            case "${char}" in
                r)  Test dir can read "${dir}";    errno=$? ;;
                w)  Test dir can write "${dir}";   errno=$? ;;
                x)  Test dir can execute "${dir}"; errno=$? ;;
                c)  Test dir can create ${dir};    errno=$? ;;
                d)  Test dir can delete ${dir};    errno=$? ;;
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
}



##
## Terminal Filelist: set REQIN from parrent, test if required
##
function __skb_internal_verify_terminal_filelist () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" doTest=false
    Report process trace "terminal filelist ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_FLS_REQIN["${id}"]="${FW_ELEMENT_FLS_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_FLS_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_FLS_REQIN_COUNT["${id}"] + 1 ))

    case ${FW_ELEMENT_FLS_STATUS["${id}"]} in
        EE* | WW* | SS*)
            doTest=false; FW_ELEMENT_FLS_STATUS["${id}"]="${FW_ELEMENT_FLS_STATUS["${id}"]:0:1}" ;;
        NN*)
            doTest=true; FW_ELEMENT_FLS_STATUS["${id}"]="${FW_ELEMENT_FLS_STATUS["${id}"]:0:1}" ;;
        N)
            doTest=true ;;
        *)
            doTest=false ;;
    esac

    if [[ ${doTest} == true ]]; then
        local file char i
        local list="${FW_ELEMENT_FLS_VAL["${id}"]}"
        local fsMode=${FW_ELEMENT_FLS_MOD["${id}"]}; i=0
        local status="S"
        for file in $list; do
            while [ ${i} -lt ${#fsMode} ]; do
                char=${fsMode:$i:1}; errno=0
                case "${char}" in
                    r)  Test file can read "${file}";    errno=$? ;;
                    w)  Test file can write "${file}";   errno=$? ;;
                    x)  Test file can execute "${file}"; errno=$? ;;
                    c)  Test file can create ${file};    errno=$? ;;
                    d)  Test file can delete ${file};    errno=$? ;;
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
            *E*)    FW_ELEMENT_FLS_STATUS["${id}"]=E ;;
            *W*)    FW_ELEMENT_FLS_STATUS["${id}"]=W ;;
            *S*)    FW_ELEMENT_FLS_STATUS["${id}"]=S ;;
        esac
    fi
}



##
## Terminal File: set REQIN from parrent, test if required
##
function __skb_internal_verify_terminal_file () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}" doTest=false
    Report process trace "terminal file ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_FIL_REQIN["${id}"]="${FW_ELEMENT_FIL_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_FIL_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_FIL_REQIN_COUNT["${id}"] + 1 ))

    case ${FW_ELEMENT_FIL_STATUS["${id}"]} in
        EE* | WW* | SS*)
            doTest=false; FW_ELEMENT_FIL_STATUS["${id}"]="${FW_ELEMENT_FIL_STATUS["${id}"]:0:1}" ;;
        NN*)
            doTest=true; FW_ELEMENT_FIL_STATUS["${id}"]="${FW_ELEMENT_FIL_STATUS["${id}"]:0:1}" ;;
        N)
            doTest=true ;;
        *)
            doTest=false ;;
    esac

    if [[ ${doTest} == true ]]; then
        local char i
        local file=${FW_ELEMENT_FIL_VAL["${id}"]}
        local fsMode=${FW_ELEMENT_FIL_MOD["${id}"]}; i=0
        local status="S"
        while [ ${i} -lt ${#fsMode} ]; do
            char=${fsMode:$i:1}; errno=0
            case "${char}" in
                r)  Test file can read "${file}";    errno=$? ;;
                w)  Test file can write "${file}";   errno=$? ;;
                x)  Test file can execute "${file}"; errno=$? ;;
                c)  Test file can create ${file};    errno=$? ;;
                d)  Test file can delete ${file};    errno=$? ;;
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
}



##
## Terminal Parameter: set REQIN from parrent, test if required
##
function __skb_internal_verify_terminal_parameter () {
    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" E801 3 "$#"; return; fi
    local errno parrentType="${1}" parrentID="${2}" id="${3}"
    Report process trace "terminal par ${id}  >>>  ${parrentType}:${parrentID}"

    FW_ELEMENT_PAR_REQIN["${id}"]="${FW_ELEMENT_PAR_REQIN["${id}"]}${parrentType}:${parrentID} ";
    FW_ELEMENT_PAR_REQIN_COUNT["${id}"]=$(( FW_ELEMENT_PAR_REQIN_COUNT["${id}"] + 1 ))

#        if [[ "${errno}" != 0 ]]; then
#            FW_ELEMENT_PAR_STATUS["${id}"]="E"
#            FW_ELEMENT_PAR_STATUS_COMMENTS["${id}"]="${FW_ELEMENT_PAR_STATUS_COMMENTS[${id}]}command(E) "
#        else
#            FW_ELEMENT_PAR_STATUS["${id}"]="S"
#        fi
}

