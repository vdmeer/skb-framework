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
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local entry arr id shortId acronym elemCmd elemPath elemModes moduleId modulePath value category file message arguments description msgType errno number doWriteRT=false text path projectFile siteFile optionLength
    local shortOpt longOpt optArg
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        element | required | requirement | object )
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                element-module)
                    # Add element module ID ACRONYM PATH DESCR
                    if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 4 "$#"; return; fi
                    id="${1}"; acronym="${2:0:2}"; acronym="${acronym^^}"; elemPath="${3}"; description="${4}"
                    Test used module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                    FW_ELEMENT_MDS_LONG["${id}"]="${description}"
                    FW_ELEMENT_MDS_ACR["${id}"]="${acronym}"
                    FW_ELEMENT_MDS_PATH["${id}"]="${elemPath}"
                    FW_ELEMENT_MDS_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
##TODO path exists, is dir
                    doWriteRT=true ;;

                element-option)
                    # Add element option ID SHORT ARG DESCR CAT
                    if [[ "${#}" -lt 5 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 5 "$#"; return; fi
                    id="${1}"; shortId="${2}"; value="${3}"; description="${4}"; category="${5}"
                    if [[ ! -n "${id}" ]]; then Report application error "${FUNCNAME[0]}" "${cmdString2}" E813; return; fi
                    Test used option long-id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    Test used option short-id "${shortId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_ELEMENT_OPT_LONG["${id}"]="${description}"
                    optionLength=$(( 5 + ${#id} ))
                    if [[ "${shortId}" != "" ]]; then FW_ELEMENT_OPT_SHORT["${shortId}"]="${id}"; fi
                    FW_ELEMENT_OPT_LS["${id}"]="${shortId}"
                    FW_ELEMENT_OPT_ARG["${id}"]="${value}"
                    if [[ -n "${value}" ]]; then
                        optionLength=$(( optionLength + 1 + ${#value} ))
                    fi
                    FW_ELEMENT_OPT_CAT["${id}"]="${category}"
                    FW_ELEMENT_OPT_LEN["${id}"]=${optionLength}
                    FW_ELEMENT_OPT_SET["${id}"]="no"
                    FW_ELEMENT_OPT_VAL["${id}"]="" ;;


                element-application | element-dependency | element-parameter | element-project | element-scenario | element-site | element-task | \
                element-file | element-filelist | element-dir | element-dirlist)
                    ## Add element x ID(1) to(2) module(3) with(4) 5...
                    if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 4 "$#"; return; fi
                    if [[ "${2}" != "to" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
                    if [[ "${3}" != "module" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1} to" E803 "${3}"; return; fi
                    if [[ "${4}" != "with" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1} to module ${FW_ELEMENT_MDS_PATH[${moduleId}]}" E803 "${4}"; return; fi
                    id="${1}"; moduleId="${FW_CURRENT_MODULE_NAME:-API}"; shift 4
                    Test existing module id "${moduleId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    modulePath=${FW_ELEMENT_MDS_PATH[${moduleId}]}
                    case ${cmd2} in
                        application)
                            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 4 "$#"; return; fi
                            elemCmd="${1}"; number="${2}"; value="${3}"; description="${4}"
                            Test used application id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_APP_LONG["${id}"]="${description}"
                            FW_ELEMENT_APP_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_APP_COMMAND["${id}"]="${elemCmd}"
                            FW_ELEMENT_APP_ARGNUM["${id}"]="${number}"
                            FW_ELEMENT_APP_ARGS["${id}"]="${value}"
                            FW_ELEMENT_APP_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteRT=true ;;
                        dependency)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 2 "$#"; return; fi
                            elemCmd="${1}"; description="${2}"
                            Test used dependency id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_DEP_LONG["${id}"]="${description}"
                            FW_ELEMENT_DEP_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_DEP_CMD["${id}"]="${elemCmd}"
                            doWriteRT=true ;;
                        dirlist)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; value="${2}"; description="${3}"
                            Test used dirlist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test fs mode "${cmd2}" "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_DLS_LONG["${id}"]="${description}"
                            FW_ELEMENT_DLS_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_DLS_VAL["${id}"]="${value}"
                            FW_ELEMENT_DLS_MOD["${id}"]="${elemModes}"
                            FW_ELEMENT_DLS_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteRT=true ;;
                        dir)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; value="${2}"; description="${3}"
                            Test used dir id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test fs mode "${cmd2}" "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_DIR_LONG["${id}"]="${description}"
                            FW_ELEMENT_DIR_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_DIR_VAL["${id}"]="${value}"
                            FW_ELEMENT_DIR_MOD["${id}"]="${elemModes}"
                            FW_ELEMENT_DIR_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteRT=true ;;
                        filelist)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; value="${2}"; description="${3}"
                            Test used filelist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test fs mode "${cmd2}" "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_FLS_LONG["${id}"]="${description}"
                            FW_ELEMENT_FLS_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_FLS_VAL["${id}"]="${value}"
                            FW_ELEMENT_FLS_MOD["${id}"]="${elemModes}"
                            FW_ELEMENT_FLS_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteRT=true ;;
                        file)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; value="${2}"; description="${3}"
                            Test used file id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test fs mode "${cmd2}" "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_FIL_LONG["${id}"]="${description}"
                            FW_ELEMENT_FIL_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_FIL_VAL["${id}"]="${value}"
                            FW_ELEMENT_FIL_MOD["${id}"]="${elemModes}"
                            FW_ELEMENT_FIL_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteRT=true ;;
                        parameter)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 2 "$#"; return; fi
                            value="${1}"; description="${2}"
                            Test used parameter id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_PAR_LONG["${id}"]="${description}"
                            FW_ELEMENT_PAR_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_PAR_DEFVAL["${id}"]="${value}"
                            FW_ELEMENT_PAR_VAL["${id}"]="${value}"
                            FW_ELEMENT_PAR_PHA["${id}"]="Default"
                            doWriteRT=true ;;
                        project)
                            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 4 "$#"; return; fi
                            elemModes="${1}"; elemPath="${2}"; projectFile="${3}"; value="${4}"; description="${5}"
                            Test used project id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test current mode "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_PRJ_LONG["${id}"]="${description}"
                            FW_ELEMENT_PRJ_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_PRJ_MODES["${id}"]="${elemModes}"
                            FW_ELEMENT_PRJ_PATH["${id}"]="${elemPath}"
                            FW_ELEMENT_PRJ_PATH_TEXT["${id}"]="${elemPath/$modulePath/$moduleId::}"
                            FW_ELEMENT_PRJ_FILE["${id}"]="${projectFile}"
                            FW_ELEMENT_PRJ_TGTS["${id}"]="${value}"
##TODO path exists, is dir, path and id.sh is readable file
                            doWriteRT=true ;;
                         scenario)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; elemPath="${2}"; description="${3}"
                            Test used scenario id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test current mode "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            text="${elemPath/$FW_MODULE_PATH/(${moduleId})}"
                            file="${elemPath}/${id}.scn"
                                Test file exists   "${file}" "${text}/${id}.scn"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                                Test file can read "${file}" "${text}/${id}.scn"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            FW_ELEMENT_SCN_LONG["${id}"]="${description}"
                            FW_ELEMENT_SCN_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_SCN_MODES["${id}"]="${elemModes}"
                            FW_ELEMENT_SCN_PATH["${id}"]="${elemPath}"
                            FW_ELEMENT_SCN_PATH_TEXT["${id}"]="${elemPath/$modulePath/$moduleId::}"
                            doWriteRT=true ;;
                        site)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 2 "$#"; return; fi
                            elemPath="${1}"; siteFile="${2}"; description="${3}"
                            Test used site id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_ELEMENT_SIT_LONG["${id}"]="${description}"
                            FW_ELEMENT_SIT_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_SIT_PATH["${id}"]="${elemPath}"
                            FW_ELEMENT_SIT_PATH_TEXT["${id}"]="${elemPath/$modulePath/$moduleId::}"
                            FW_ELEMENT_SIT_FILE["${id}"]="${siteFile}"
##TODO path exists, is dir, path and id.sh is executable file
                            doWriteRT=true ;;
                        task)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} for module ${moduleId}" E801 3 "$#"; return; fi
                            elemModes="${1}"; elemPath="${2}"; description="${3}"
                            Test used task id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test current mode "${elemModes}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            text="${elemPath/$FW_MODULE_PATH/(${moduleId})}"
                            file="${elemPath}/${id}.sh"
                                Test file exists      "${file}" "${text}/${id}.sh"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                                Test file can execute "${file}" "${text}/${id}.sh"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            file="${elemPath}/${id}-completions.bash"
                                Test file exists   "${file}" "${text}/${id}-completions.bash"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                                Test file can read "${file}" "${text}/${id}-completions.bash"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

                            FW_ELEMENT_TSK_LONG["${id}"]="${description}"
                            FW_ELEMENT_TSK_ORIG["${id}"]="${moduleId}"
                            FW_ELEMENT_TSK_MODES["${id}"]="${elemModes}"
                            FW_ELEMENT_TSK_PATH["${id}"]="${elemPath}"
                            FW_ELEMENT_TSK_PATH_TEXT["${id}"]="${elemPath/$modulePath/$moduleId::}"
                            alias ${id}="Execute task ${id}"
                            doWriteRT=true ;;
                    esac ;;

                requirement-for)
                    # [module|dependency](1) ID(2) as(3) [module|dependency](4) ID(5)
                    if [[ "${#}" -lt 5 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 5 "$#"; return; fi
                    id="${2}"
                    local reqProp="${1}" reqType="${4}" reqId="${5}"
                    case "${reqProp}" in
                        dependency)
                            if [[ "${id}" == "${reqId}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} requirement" E902 "${reqProp}"; return; fi
                            Test existing dependency id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            case "${reqType}" in
                                dependency) Test existing dependency id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                                *) Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} requirement" E901 "${reqProp}" "${reqType}"; return ;;
                            esac
                            if [[ ! -n "${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]:-}" ]]; then FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]="${reqId}"; else FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]+=" ${reqId}"; fi
                            doWriteRT=true ;;
                        module)
                            if [[ "${id}" == "${reqId}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} requirement" E902 "${reqProp}"; return; fi
                            Test existing module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            case "${reqType}" in
                                module) Test existing module id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                                *) Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} requirement" E901 "${reqProp}" "${reqType}"; return ;;
                            esac
                            if [[ ! -n "${FW_ELEMENT_MDS_REQUIRED_MODULES[${id}]:-}" ]]; then FW_ELEMENT_MDS_REQUIRED_MODULES[${id}]="${reqId}"; else FW_ELEMENT_MDS_REQUIRED_MODULES[${id}]+=" ${reqId}"; fi
                            doWriteRT=true ;;
                        *) Report process error "${FUNCNAME[0]}" "${cmdString2}" E900 "${reqProp}"; return ;;
                    esac
                    ;;

                required-application | required-dependency | required-parameter | required-task | required-file | required-filelist | required-dir | required-dirlist)
                    ## Add required [app|dep|par|tsk|file|filelist|dir|dirlist] ID(1) to [prj|scn|sit|task] ID(4)
                    if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 4 "$#"; return; fi
                    id="${4}"
                    local reqType="${cmd2}" reqId="${1}" reqProp="${3}"
                    case "${reqProp}" in
                        project)    Test existing project id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        scenario)   Test existing scenario id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        site)       Test existing site id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        task)       if [[ "${id}" == "${reqId}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${id} requirement" E902 "${reqProp}"; return; fi
                                    Test existing task id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        *)          Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${reqProp}"; return ;;
                    esac
                    case "${reqType}" in
                        application)    Test existing application id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        dependency)     Test existing dependency id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        parameter)      Test existing parameter id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        task)           Test existing task id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        file)           Test existing file id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        filelist)       Test existing filelist id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        dir)            Test existing dir id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        dirlist)        Test existing dirlist id "${reqId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E804 "requirement type" "${reqType}"; return ;;
                    esac

                    case "${reqProp}-${reqType}" in
                        project-application)    if [[ ! -n "${FW_ELEMENT_PRJ_REQUIRED_APP[${id}]:-}" ]];      then FW_ELEMENT_PRJ_REQUIRED_APP[${id}]="${reqId}"; else FW_ELEMENT_PRJ_REQUIRED_APP[${id}]+=" ${reqId}"; fi ;;
                        project-dependency)     if [[ ! -n "${FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]:-}" ]];      then FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]="${reqId}"; else FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]+=" ${reqId}"; fi ;;
                        project-parameter)      if [[ ! -n "${FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]:-}" ]];      then FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]="${reqId}"; else FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]+=" ${reqId}"; fi ;;
                        project-task)           if [[ ! -n "${FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]:-}" ]];      then FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]="${reqId}"; else FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]+=" ${reqId}"; fi ;;
                        project-file)           if [[ ! -n "${FW_ELEMENT_PRJ_REQUIRED_FILE[${id}]:-}" ]];     then FW_ELEMENT_PRJ_REQUIRED_FILE[${id}]="${reqId}"; else FW_ELEMENT_PRJ_REQUIRED_FILE[${id}]+=" ${reqId}"; fi ;;
                        project-filelist)       if [[ ! -n "${FW_ELEMENT_PRJ_REQUIRED_FILELIST[${id}]:-}" ]]; then FW_ELEMENT_PRJ_REQUIRED_FILELIST[${id}]="${reqId}"; else FW_ELEMENT_PRJ_REQUIRED_FILELIST[${id}]+=" ${reqId}"; fi ;;
                        project-dir)            if [[ ! -n "${FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]:-}" ]];      then FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]="${reqId}"; else FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]+=" ${reqId}"; fi ;;
                        project-dirlist)        if [[ ! -n "${FW_ELEMENT_PRJ_REQUIRED_DIRLIST[${id}]:-}" ]];  then FW_ELEMENT_PRJ_REQUIRED_DIRLIST[${id}]="${reqId}"; else FW_ELEMENT_PRJ_REQUIRED_DIRLIST[${id}]+=" ${reqId}"; fi ;;

                        scenario-application)   if [[ ! -n "${FW_ELEMENT_SCN_REQUIRED_APP[${id}]:-}" ]];      then FW_ELEMENT_SCN_REQUIRED_APP[${id}]="${reqId}"; else FW_ELEMENT_SCN_REQUIRED_APP[${id}]+=" ${reqId}"; fi ;;
                        scenario-dependency)    if [[ ! -n "${FW_ELEMENT_SCN_REQUIRED_DEP[${id}]:-}" ]];      then FW_ELEMENT_SCN_REQUIRED_DEP[${id}]="${reqId}"; else FW_ELEMENT_SCN_REQUIRED_DEP[${id}]+=" ${reqId}"; fi ;;
                        scenario-parameter)     if [[ ! -n "${FW_ELEMENT_SCN_REQUIRED_PAR[${id}]:-}" ]];      then FW_ELEMENT_SCN_REQUIRED_PAR[${id}]="${reqId}"; else FW_ELEMENT_SCN_REQUIRED_PAR[${id}]+=" ${reqId}"; fi ;;
                        scenario-task)          if [[ ! -n "${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]:-}" ]];      then FW_ELEMENT_SCN_REQUIRED_TSK[${id}]="${reqId}"; else FW_ELEMENT_SCN_REQUIRED_TSK[${id}]+=" ${reqId}"; fi ;;
                        scenario-file)          if [[ ! -n "${FW_ELEMENT_SCN_REQUIRED_FILE[${id}]:-}" ]];     then FW_ELEMENT_SCN_REQUIRED_FILE[${id}]="${reqId}"; else FW_ELEMENT_SCN_REQUIRED_FILE[${id}]+=" ${reqId}"; fi ;;
                        scenario-filelist)      if [[ ! -n "${FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]:-}" ]]; then FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]="${reqId}"; else FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]+=" ${reqId}"; fi ;;
                        scenario-dir)           if [[ ! -n "${FW_ELEMENT_SCN_REQUIRED_DIR[${id}]:-}" ]];      then FW_ELEMENT_SCN_REQUIRED_DIR[${id}]="${reqId}"; else FW_ELEMENT_SCN_REQUIRED_DIR[${id}]+=" ${reqId}"; fi ;;
                        scenario-dirlist)       if [[ ! -n "${FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]:-}" ]];  then FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]="${reqId}"; else FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]+=" ${reqId}"; fi ;;

                        site-application)       if [[ ! -n "${FW_ELEMENT_SIT_REQUIRED_APP[${id}]:-}" ]];      then FW_ELEMENT_SIT_REQUIRED_APP[${id}]="${reqId}"; else FW_ELEMENT_SIT_REQUIRED_APP[${id}]+=" ${reqId}"; fi ;;
                        site-dependency)        if [[ ! -n "${FW_ELEMENT_SIT_REQUIRED_DEP[${id}]:-}" ]];      then FW_ELEMENT_SIT_REQUIRED_DEP[${id}]="${reqId}"; else FW_ELEMENT_SIT_REQUIRED_DEP[${id}]+=" ${reqId}"; fi ;;
                        site-parameter)         if [[ ! -n "${FW_ELEMENT_SIT_REQUIRED_PAR[${id}]:-}" ]];      then FW_ELEMENT_SIT_REQUIRED_PAR[${id}]="${reqId}"; else FW_ELEMENT_SIT_REQUIRED_PAR[${id}]+=" ${reqId}"; fi ;;
                        site-task)              if [[ ! -n "${FW_ELEMENT_SIT_REQUIRED_TSK[${id}]:-}" ]];      then FW_ELEMENT_SIT_REQUIRED_TSK[${id}]="${reqId}"; else FW_ELEMENT_SIT_REQUIRED_TSK[${id}]+=" ${reqId}"; fi ;;
                        site-file)              if [[ ! -n "${FW_ELEMENT_SIT_REQUIRED_FILE[${id}]:-}" ]];     then FW_ELEMENT_SIT_REQUIRED_FILE[${id}]="${reqId}"; else FW_ELEMENT_SIT_REQUIRED_FILE[${id}]+=" ${reqId}"; fi ;;
                        site-filelist)          if [[ ! -n "${FW_ELEMENT_SIT_REQUIRED_FILELIST[${id}]:-}" ]]; then FW_ELEMENT_SIT_REQUIRED_FILELIST[${id}]="${reqId}"; else FW_ELEMENT_SIT_REQUIRED_FILELIST[${id}]+=" ${reqId}"; fi ;;
                        site-dir)               if [[ ! -n "${FW_ELEMENT_SIT_REQUIRED_DIR[${id}]:-}" ]];      then FW_ELEMENT_SIT_REQUIRED_DIR[${id}]="${reqId}"; else FW_ELEMENT_SIT_REQUIRED_DIR[${id}]+=" ${reqId}"; fi ;;
                        site-dirlist)           if [[ ! -n "${FW_ELEMENT_SIT_REQUIRED_DIRLIST[${id}]:-}" ]];  then FW_ELEMENT_SIT_REQUIRED_DIRLIST[${id}]="${reqId}"; else FW_ELEMENT_SIT_REQUIRED_DIRLIST[${id}]+=" ${reqId}"; fi ;;

                        task-application)       if [[ ! -n "${FW_ELEMENT_TSK_REQUIRED_APP[${id}]:-}" ]];      then FW_ELEMENT_TSK_REQUIRED_APP[${id}]="${reqId}"; else FW_ELEMENT_TSK_REQUIRED_APP[${id}]+=" ${reqId}"; fi ;;
                        task-dependency)        if [[ ! -n "${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]:-}" ]];      then FW_ELEMENT_TSK_REQUIRED_DEP[${id}]="${reqId}"; else FW_ELEMENT_TSK_REQUIRED_DEP[${id}]+=" ${reqId}"; fi ;;
                        task-parameter)         if [[ ! -n "${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]:-}" ]];      then FW_ELEMENT_TSK_REQUIRED_PAR[${id}]="${reqId}"; else FW_ELEMENT_TSK_REQUIRED_PAR[${id}]+=" ${reqId}"; fi ;;
                        task-task)              if [[ ! -n "${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]:-}" ]];      then FW_ELEMENT_TSK_REQUIRED_TSK[${id}]="${reqId}"; else FW_ELEMENT_TSK_REQUIRED_TSK[${id}]+=" ${reqId}"; fi ;;
                        task-file)              if [[ ! -n "${FW_ELEMENT_TSK_REQUIRED_FILE[${id}]:-}" ]];     then FW_ELEMENT_TSK_REQUIRED_FILE[${id}]="${reqId}"; else FW_ELEMENT_TSK_REQUIRED_FILE[${id}]+=" ${reqId}"; fi ;;
                        task-filelist)          if [[ ! -n "${FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]:-}" ]]; then FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]="${reqId}"; else FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]+=" ${reqId}"; fi ;;
                        task-dir)               if [[ ! -n "${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]:-}" ]];      then FW_ELEMENT_TSK_REQUIRED_DIR[${id}]="${reqId}"; else FW_ELEMENT_TSK_REQUIRED_DIR[${id}]+=" ${reqId}"; fi ;;
                        task-dirlist)           if [[ ! -n "${FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]:-}" ]];  then FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]="${reqId}"; else FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]+=" ${reqId}"; fi ;;
                    esac
                    doWriteRT=true ;;

                object-configuration)
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    id="${1^^}"; value="${2}"; description="${3}"
                    Test used configuration id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_CFG_LONG["${id}"]="${description}"
                    FW_OBJECT_CFG_VAL["${id}"]="${value}"
                    doWriteRT=true ;;
                object-format)
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    id="${1,,}"; path="${2}"; description="${3}"
                    Test used format id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_FMT_LONG["${id}"]="${description}"
                    FW_OBJECT_FMT_PATH["${id}"]="${path}"
                    doWriteRT=true ;;
                object-level)
                    if [[ "${#}" -lt 5 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 5 "$#"; return; fi
                    id="${1,,}"; value="${2}"; text="${3}"; path="${4}"; description="${5}"
                    Test used level id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_LVL_LONG["${id}"]="${description}"
                    FW_OBJECT_LVL_PATH["${id}"]="${path}"
                    FW_OBJECT_LVL_CHAR_ABBR["${id}"]="${value}"
                    FW_OBJECT_LVL_STRING_THM["${id}"]="${text}" ;;
                object-message)
                    if [[ "${#}" -lt 6 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 6 "$#"; return; fi
                    id="${1^}"; arguments="${2}"; message="${3}"; category="${4}"; path="${5}"; description="${6}"
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
                    FW_OBJECT_MSG_TYPE["${id}"]="${msgType}"
                    FW_OBJECT_MSG_CAT["${id}"]="${category}"
                    FW_OBJECT_MSG_ARGS["${id}"]="${arguments}"
                    FW_OBJECT_MSG_TEXT["${id}"]="${message}"
                    FW_OBJECT_MSG_PATH["${id}"]="${path}" ;;
                object-mode)
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    id="${1,,}"; path="${2}"; description="${3}"
                    Test used mode id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_MOD_LONG["${id}"]="${description}"
                    FW_OBJECT_MOD_PATH["${id}"]="${path}" ;;
                object-phase)
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    id="${1}"; path="${2}"; description="${3}"
                    Test used phase id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_PHA_LONG["${id}"]="${description}"
                    FW_OBJECT_PHA_PRT_LVL["${id}"]=" fatalerror error warning "
                    FW_OBJECT_PHA_LOG_LVL["${id}"]=" fatalerror error message text warning info "
                    FW_OBJECT_PHA_ERRCNT["${id}"]="0"
                    FW_OBJECT_PHA_WRNCNT["${id}"]="0"
                    FW_OBJECT_PHA_ERRCOD["${id}"]=""
                    FW_OBJECT_PHA_PATH["${id}"]="${path}"
                    doWriteRT=true ;;
                object-setting)
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    id="${1^^}"; value="${2}"; description="${3}"
                    Test used setting id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_SET_LONG[${id}]="${description}"
                    FW_OBJECT_SET_PHA[${id}]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    FW_OBJECT_SET_VAL[${id}]="${value}"
                    doWriteRT=true ;;
                object-theme)
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    id="${1}"; path="${2}"; description="${3}"
                    Test used theme id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
##TODO error path does not exist
                    FW_OBJECT_THM_LONG["${id}"]="${description}"
                    FW_OBJECT_THM_PATH["${id}"]="${path}"
                    doWriteRT=true ;;
                object-themeitem)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; description="${2}"
                    Test used themeitem id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_TIM_LONG["${id}"]="${description}"
                    FW_OBJECT_TIM_SOURCE["${id}"]=""
                    FW_OBJECT_TIM_VAL["${id}"]=""
                    doWriteRT=true ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac

    if [[ "${doWriteRT}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; Write slow config; doWriteRT=false; fi
}
