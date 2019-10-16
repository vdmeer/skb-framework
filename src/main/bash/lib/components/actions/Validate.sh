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
## Validate - action to validates something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Validate() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id component element dir name expected printDir modid modDir compPath file extension tmpName excludeIDs
    local actions elements instances objects compType
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        everything)
            Validate library text
            Validate framework components
            Validate added components ;;

        added | library | framework)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                added-components)
                    Report application info "validating added components"
                    if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" ]]; then
                        for modid in "${!FW_ELEMENT_MDS_LONG[@]}"; do
                            Report application info "validating added components - module ${modid}"
                            Test file can read "${FW_ELEMENT_MDS_PATH[${modid}]}/${modid}.adoc"

                            for element in applications dependencies dirlists dirs filelists files parameters projects scenarios scripts sites tasks configurations formats levels messages modes phases settings themeitems themes; do
                                Report application info "validating added components - module ${modid}, element ${element}"

                                dir="${FW_ELEMENT_MDS_PATH[${modid}]}/${element}"
                                printDir="$modid::/${element}"
                                expected=" "
                                case ${element} in
                                    applications)
                                        for component in $(Applications has); do
                                            if [[ "${FW_ELEMENT_APP_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    dependencies)
                                        for component in $(Dependencies has); do
                                            if [[ "${FW_ELEMENT_DEP_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    dirlists)
                                        for component in $(Dirlists has); do
                                            if [[ "${FW_ELEMENT_DLS_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    dirs)
                                        for component in $(Dirs has); do
                                            if [[ "${FW_ELEMENT_DIR_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    filelists)
                                        for component in $(Filelists has); do
                                            if [[ "${FW_ELEMENT_FLS_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    files)
                                        for component in $(Files has); do
                                            if [[ "${FW_ELEMENT_FIL_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    parameters)
                                        for component in $(Parameters has); do
                                            if [[ "${FW_ELEMENT_PAR_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
#                                    projects)
#                                        for component in $(Projects has); do
#                                            if [[ "${FW_ELEMENT_PRJ_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
#                                        done ;;
                                    scenarios)
                                        for component in $(Scenarios has); do
                                            if [[ "${FW_ELEMENT_SCN_DECMDS[${component}]}" == "${modid}" ]]; then
                                                compPath="${FW_ELEMENT_SCN_PATH[${component}]}"
                                                compPath=${compPath//${dir}/}
                                                compPath=${compPath//\//}
                                                expected+="${compPath}/${component} "
                                            fi
                                        done ;;
#                                    scripts)
#                                        for component in $(Scripts has); do
#                                            if [[ "${FW_ELEMENT_SCR_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
#                                        done ;;
#                                    sites)
#                                        for component in $(Sites has); do
#                                            if [[ "${FW_ELEMENT_SIT_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
#                                        done ;;
                                    tasks)
                                        for component in $(Tasks has); do
                                            if [[ "${FW_ELEMENT_TSK_DECMDS[${component}]}" == "${modid}" ]]; then
                                                compPath="${FW_ELEMENT_TSK_PATH[${component}]}"
                                                compPath=${compPath//${dir}/}
                                                compPath=${compPath//\//}
                                                expected+="${compPath}/${component} "
                                            fi
                                        done ;;

                                    configurations)
                                        for component in $(Configurations has); do
                                            if [[ "${FW_OBJECT_CFG_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    formats)
                                        for component in $(Formats has); do
                                            if [[ "${FW_OBJECT_FMT_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    levels)
                                        for component in $(Levels has); do
                                            if [[ "${FW_OBJECT_LVL_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    messages)
                                        for component in $(Messages has); do
                                            if [[ "${FW_OBJECT_MSG_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    modes)
                                        for component in $(Modes has); do
                                            if [[ "${FW_OBJECT_MOD_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    phases)
                                        for component in $(Phases has); do
                                            if [[ "${FW_OBJECT_PHA_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    settings)
                                        for component in $(Settings has); do
                                            if [[ "${FW_OBJECT_SET_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    themeitems)
                                        for component in $(Themeitems has); do
                                            if [[ "${FW_OBJECT_TIM_DECMDS[${component}]}" == "${modid}" ]]; then expected+="${component} "; fi
                                        done ;;
                                    themes)
                                        for component in $(Themes has); do
                                            if [[ "${FW_OBJECT_THM_DECMDS[${component}]}" == "${modid}" ]]; then
                                                expected+="${component} "
                                                Test file can read "${dir}/${component}.thm" "${printDir}/${component}.thm"
                                            fi
                                        done ;;

                                    *) echo "## ERROR, element $element"; continue ;;
                                esac

                                if [[ -n "${expected}" && "${expected}" != " " ]]; then
                                    for name in ${expected}; do
                                        Test file can read "${dir}/${name}.adoc" "${printDir}/${name}.adoc"
                                        if [[ "${element}" == "tasks" ]]; then
                                            Test file can read "${dir}/${name}.sh" "${printDir}/${name}.sh"
                                            Test file can read "${dir}/${name}-completions.bash" "${printDir}/${name}-completions.bash"
                                        fi
                                        if [[ "${element}" == "scenarios" ]]; then
                                            Test file can read "${dir}/${name}.scn" "${printDir}/${name}.scn"
                                        fi
                                    done
                                    for file in ${dir}/**; do
                                        if [[ -d "${file}" ]]; then continue; fi
                                        file=${file//${dir}/}; file=${file/\//}; extension=${file##*.}; name=${file%%.*}; nameCompletions="${name}-completions"
                                        case "${expected}" in
                                            *"${name} "*) ;;
                                            *)
                                                if [[ "${element}" == "tasks" ]]; then
                                                    tmpName=${name//-completions/}
                                                    case "${expected}" in
                                                        *"${tmpName} "*) ;;
                                                        *) Report application strictwarning E826 "${file}" "${printDir}" ;;
                                                    esac
                                                else
                                                    Report application strictwarning E826 "${file}" "${printDir}"
                                                fi ;;
                                        esac
                                        case "${extension}" in
                                            adoc)   ;;
                                            sh)     if [[ "${element}" != "tasks" ]];       then Report application strictwarning E826 "${file}" "${printDir}"; fi ;;
                                            bash)   if [[ "${element}" != "tasks" ]];       then Report application strictwarning E826 "${file}" "${printDir}"; fi ;;
                                            scn)    if [[ "${element}" != "scenarios" ]];   then Report application strictwarning E826 "${file}" "${printDir}"; fi ;;
                                            thm)    if [[ "${element}" != "themes" ]];      then Report application strictwarning E826 "${file}" "${printDir}"; fi ;;
                                            *)      Report application strictwarning E826 "${file}" "${printDir}"
                                        esac
                                    done
                                fi
                            done
                        done
                    fi ;;


                library-text)
                    Report application info "validating library texts"
                    for element in $(ls ${SF_HOME}/lib/text); do
                        dir="${SF_HOME}/lib/text/${element}"
                        printDir="\$SF_HOME/lib/text/${element}"
                        expected=""
                        case ${element} in
                            actions)    expected="$(Framework has actions)" ;;
                            components) expected="actions elements instances objects" ;;
                            elements)   expected="$(Framework has elements)"
                                        expected+=" exit-options run-options" ;;
                            exitcodes)  expected="$(Exitcodes has)" ;;
                            framework)  expected="authors bugs copying description exit-status resources security" ;;
                            instances)  expected="$(Framework has instances)" ;;
                            objects)    expected="$(Framework has objects)" ;;
                            options)    expected="$(Options has)" ;;
                            tags)       expected="authors name" ;;
                            variables)  expected="$(Variables has)" ;;
                        esac
                        for name in ${expected}; do
                            Test file can read "${dir}/${name}.adoc" "${printDir}/${name}.adoc"
                        done
                        for file in ${dir}/**; do
                            if [[ -d "${file}" ]]; then continue; fi
                            file=${file##*/}; extension=${file##*.}; name=${file%%.*}
                            case "${expected}" in
                                *"${name}"*) ;;
                                *) Report application strictwarning E826 "${file}" "${printDir}"
                            esac
                            case "${extension}" in
                                adoc) ;;
                                *) Report application strictwarning E826 "${file}" "${printDir}"
                            esac
                        done
                    done ;;


                framework-components)
                    Report application info "validating framework components"
                    Test file can read "${SF_HOME}/lib/components/Framework.sh"                 "\$SF_HOME/lib/components/Framework.sh"
                    Test file can read "${SF_HOME}/lib/completions/Framework-completions.bash"  "\$SF_HOME/lib/completions/Framework-completions.bash"
                    if [[ -z "${FW_COMPONENTS_TAGLINE["Framework"]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 "main functiosn" "Framework" tagline; fi

                    actions=" $(Framework has actions) "
                    elements=" $(Framework has elements) "
                    instances=" $(Framework has instances) "
                    objects=" $(Framework has objects) "

                    for id in ${actions} ${elements} ${instances} ${objects}; do
                        case ${actions} in *" ${id} "*)     compType=actions ;; esac
                        case ${elements} in *" ${id} "*)    compType=elements ;; esac
                        case ${instances} in *" ${id} "*)   compType=instances ;; esac
                        case ${objects} in *" ${id} "*)     compType=objects ;; esac

                        Test file can read "${SF_HOME}/lib/components/${compType}/${id}.sh"                 "\$SF_HOME/lib/components/${compType}/${id}.sh"
                        Test file can read "${SF_HOME}/lib/completions/${compType}/${id}-completions.bash"  "\$SF_HOME/lib/completions/${compType}/${id}-completions.bash"

                        if [[ -z "${FW_COMPONENTS_TAGLINE[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} tagline; fi
                        if [[ ! -n "${FW_COMPONENTS_TAGLINE[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" tagline; fi

                        excludeIDs=" Module Dependency Project Scenario Script Site Task Tablechars "
                        if [[ "${compType}" != "actions" ]]; then
                        case ${excludeIDs} in
                            *" ${id} "*) ;;
                            *)  if [[ -z "${FW_COMPONENTS_SINGULAR[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} singular; fi
                                if [[ ! -n "${FW_COMPONENTS_SINGULAR[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" singular; fi

                                if [[ -z "${FW_COMPONENTS_PLURAL[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} plural; fi
                                if [[ ! -n "${FW_COMPONENTS_PLURAL[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" plural; fi

                                if [[ -z "${FW_COMPONENTS_TITLE_LONG_SINGULAR[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} "long singular title"; fi
                                if [[ ! -n "${FW_COMPONENTS_TITLE_LONG_SINGULAR[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" "long singular title"; fi

                                if [[ -z "${FW_COMPONENTS_TITLE_LONG_PLURAL[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} "long plural title"; fi
                                if [[ ! -n "${FW_COMPONENTS_TITLE_LONG_PLURAL[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" "long plural title"; fi

                                if [[ -z "${FW_COMPONENTS_TITLE_SHORT_SINGULAR[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} "short singular title"; fi
                                if [[ ! -n "${FW_COMPONENTS_TITLE_SHORT_SINGULAR[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" "short singular title"; fi

                                if [[ -z "${FW_COMPONENTS_TITLE_SHORT_PLURAL[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} "short plural title"; fi
                                if [[ ! -n "${FW_COMPONENTS_TITLE_SHORT_PLURAL[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" "short plural title"; fi

                                if [[ -z "${FW_COMPONENTS_TABLE_DESCR[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} "table description"; fi
                                if [[ ! -n "${FW_COMPONENTS_TABLE_DESCR[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" "table description"; fi

                                if [[ -z "${FW_COMPONENTS_TABLE_VALUE[${id}]:-}" ]];   then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} "table value"; fi
                                if [[ ! -n "${FW_COMPONENTS_TABLE_VALUE[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E815 "${compType:0:-1} ${id}" "table value"; fi

                                if [[ "${id}" != "Exitcodes" ]]; then
                                    if [[ -z "${FW_COMPONENTS_TABLE_EXTRA[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} "table extra"; fi
                                fi ;;
                            esac
                        fi;

                        if [[ -z "${SF_OPERATIONS[${id}]:-}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E817 ${compType:0:-1} ${id} "SF_OPERATIONS entries"; fi
                    done ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
