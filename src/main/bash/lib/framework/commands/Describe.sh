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
## Describe - command to describe something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_TAGS_COMMANDS["Describe"]="command to describe something"

function Describe() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local id format modid modpath dir heading file
    if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi

    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        application | dependency | dirlist | dir | filelist | file | parameter)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing ${cmd1} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            case ${cmd1} in
                application)    modid="${FW_ELEMENT_APP_ORIG[${id}]}"; modpath="${FW_ELEMENT_MDS_PATH[${modid}]}/applications" ;;
                dependency)     modid="${FW_ELEMENT_DEP_ORIG[${id}]}"; modpath="${FW_ELEMENT_MDS_PATH[${modid}]}/dependencies" ;;
                dirlist)        modid="${FW_ELEMENT_DLS_ORIG[${id}]}"; modpath="${FW_ELEMENT_MDS_PATH[${modid}]}/dirlists" ;;
                dir)            modid="${FW_ELEMENT_DIR_ORIG[${id}]}"; modpath="${FW_ELEMENT_MDS_PATH[${modid}]}/dirs" ;;
                filelist)       modid="${FW_ELEMENT_FLS_ORIG[${id}]}"; modpath="${FW_ELEMENT_MDS_PATH[${modid}]}/filelists" ;;
                file)           modid="${FW_ELEMENT_FIL_ORIG[${id}]}"; modpath="${FW_ELEMENT_MDS_PATH[${modid}]}/files" ;;
                parameter)      modid="${FW_ELEMENT_PAR_ORIG[${id}]}"; modpath="${FW_ELEMENT_MDS_PATH[${modid}]}/parameters" ;;
            esac
            case "${format}" in
                ansi | plain)   Format tagline for ${cmd1} "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                                cat ${modpath}/${id}.txt ;;
                *)              Format tagline for ${cmd1} "${id}" describe 0 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "::\n"
                                cat ${modpath}/${id}.adoc ;;
            esac ;;

        format | level | message | mode | module | option | phase | project | scenario | task | theme)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            Test existing ${cmd1} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            case ${cmd1} in
                format)     dir=${FW_OBJECT_FMT_PATH[${id}]} ;;
                level)      dir=${FW_OBJECT_LVL_PATH[${id}]} ;;
                message)    dir=${FW_OBJECT_MSG_PATH[${id}]} ;;
                mode)       dir=${FW_OBJECT_MOD_PATH[${id}]} ;;
                module)     id="$(Get module id ${id})"; dir=${FW_ELEMENT_MDS_PATH[${id}]} ;;
                option)     id="$(Get option id ${id})"; dir=${SF_HOME}/lib/text/options/ ;;
                phase)      dir=${FW_OBJECT_PHA_PATH[${id}]} ;;
                project)    dir=${FW_ELEMENT_PRJ_PATH[${id}]} ;;
                scenario)   dir=${FW_ELEMENT_SCN_PATH[${id}]} ;;
                task)       dir=${FW_ELEMENT_TSK_PATH[${id}]} ;;
                theme)      id="$(Get theme id ${id})"; dir=${FW_OBJECT_THM_PATH[${id}]} ;;
            esac
            case "${format}" in
                ansi | plain)   Format tagline for ${cmd1} "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                                cat ${dir}/${id}.txt ;;
                *)              Format tagline for ${cmd1} "${id}" describe 0 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "::\n"
                                cat ${dir}/${id}.adoc ;;
            esac ;;

        command | element | instance | object)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            dir=${SF_HOME}/lib/text/${cmd1}s/
            case "${format}" in
                ansi | plain)   Format tagline for ${cmd1} "${id}" describe 2 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "\n"
                                cat ${dir}/${id}.txt ;;
                *)              Format tagline for ${cmd1} "${id}" describe 0 1 "${FW_OBJECT_TIM_VAL[listSeparator]}"; printf "::\n"
                                cat ${dir}/${id}.adoc ;;
            esac ;;

        exit-options)
            case "${format}" in
                ansi | plain)   printf "%*s" "4"; Format themed text describeNameFmt "Exit Options"; printf "\n"
                                cat ${SF_HOME}/lib/text/elements/exit-options.txt ;;
                *)              Format themed text describeNameFmt "Exit Options"; printf "::\n"
                                cat ${SF_HOME}/lib/text/elements/exit-options.adoc ;;
            esac ;;
        runtime-options)
            case "${format}" in
                ansi | plain)   printf "%*s" "4"; Format themed text describeNameFmt "Runtime Options"; printf "\n"
                                cat ${SF_HOME}/lib/text/elements/run-options.txt ;;
                *)              Format themed text describeNameFmt "Runtime Options"; printf "::\n"
                                cat ${SF_HOME}/lib/text/elements/run-options.adoc ;;
            esac ;;

        component | framework)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                component-commands | component-elements | component-instances | component-objects)
                    case "${format}" in
                        ansi | plain)   printf "%*s" "2"; Format themed text describeNameFmt "${cmd2^}"; printf "\n"
                                        cat ${SF_HOME}/lib/text/components/${cmd2}.txt ;;
                        *)              Format themed text describeNameFmt "${cmd2^}"; printf "::\n"
                                        cat ${SF_HOME}/lib/text/components/${cmd2}.adoc ;;
                    esac ;;

                framework-authors | framework-bugs | framework-copying | framework-description | framework-resources | framework-security)
                    case "${format}" in
                        ansi | plain)   printf "%*s" "2"; Format themed text describeNameFmt "${cmd2^}"; printf "\n"
                                        #printf "  "; Format text bold "${cmd2^^}"; printf "\n"
                                        cat ${SF_HOME}/lib/text/framework/${cmd2}.txt ;;
                        adoc | mdoc)    Format themed text describeNameFmt "${cmd2^}"; printf "::\n"
                                        printf "== ${cmd2^^}\n"; cat ${SF_HOME}/lib/text/framework/${cmd2}.adoc ;;
                    esac ;;

                *)
                    Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
