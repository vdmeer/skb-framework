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
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id element dir printDir name expected modid modpath file extension
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        everything)
            Validate elements
            Validate objects
            Validate manual ;;

        elements)
            Validate applications
            Validate dependencies
            Validate dirlists
            Validate dirs
            Validate filelists
            Validate files
            Validate modules
            Validate options
            Validate parameters
            Validate projects
            Validate scenarios
            Validate sites
            Validate tasks ;;

        objects)
            Validate configurations
            Validate formats
            Validate levels
            Validate messages
            Validate modes
            Validate phases
            Validate settings
            Validate themeitems
            Validate themes ;;


        manual)
            for element in framework actions components elements exitcodes instances objects options tags themeitems; do
                dir="${SF_HOME}/lib/text/${element}"
                printDir="\$SF_HOME/lib/text/${element}"
                case ${element} in
                    framework)  expected="authors bugs copying description exit-status resources security" ;;
                    components) expected="actions elements instances objects" ;;
                    actions)   expected="$(Framework has actions)" ;;
                    instances)  expected="$(Framework has instances)" ;;
                    elements)   expected="$(Framework has elements)"
                                expected+=" exit-options run-options" ;;
                    exitcodes)  expected="$(Exitcodes has)" ;;
                    objects)    expected="$(Framework has objects)" ;;
                    options)    expected="$(Options has)" ;;
                    tags)       expected="authors name" ;;
                    themeitems) expected="$(Themeitems has)" ;;
                esac

                for name in ${expected}; do
                    Test file exists "${dir}/${name}.adoc" "${printDir}/${name}.adoc"; Test file can read "${dir}/${name}.adoc" "${printDir}/${name}.adoc"
                done
                for file in ${dir}/**; do
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


        applications)
            if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_APP_LONG[@]}; do
                    modid="${FW_ELEMENT_APP_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/applications/${id}.adoc"; Test file can read "${modpath}/applications/${id}.adoc"
                done
            fi ;;        dependencies)
            if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                    modid="${FW_ELEMENT_DEP_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/dependencies/${id}.adoc"; Test file can read "${modpath}/dependencies/${id}.adoc"
                done
            fi ;;

        dirlists)
            ;;

        dirs)
            if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DIR_LONG[@]}; do
                    modid="${FW_ELEMENT_DIR_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/dirs/${id}.adoc"; Test file can read "${modpath}/dirs/${id}.adoc"
                done
            fi ;;

        filelists)
            ;;

        files)
            if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_FIL_LONG[@]}; do
                    modid="${FW_ELEMENT_FIL_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/files/${id}.adoc"; Test file can read "${modpath}/files/${id}.adoc"
                done
            fi ;;

        dependencies)
            if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                    modid="${FW_ELEMENT_DEP_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/dependencies/${id}.adoc"; Test file can read "${modpath}/dependencies/${id}.adoc"
                done
            fi ;;

        modules)
            if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_MDS_LONG[@]}; do
                    Test file exists "${FW_ELEMENT_MDS_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_ELEMENT_MDS_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        options)
            if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                    Test file exists "${SF_HOME}/lib/text/options/${id}.adoc"; Test file can read "${SF_HOME}/lib/text/options/${id}.adoc"
                done
            fi ;;

        parameters)
            if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_PAR_LONG[@]}; do
                    modid="${FW_ELEMENT_PAR_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/parameters/${id}.adoc"; Test file can read "${modpath}/parameters/${id}.adoc"
                done
            fi ;;

        projects)
            ;;

        scenarios)
            if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                    Test file exists "${FW_ELEMENT_SCN_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_ELEMENT_SCN_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        sites)
            ;;

        tasks)
            if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                    Test file exists "${FW_ELEMENT_TSK_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_ELEMENT_TSK_PATH[${id}]}/${id}.adoc"
                done
            fi ;;


        configurations)
            ;;

        formats)
            if [[ "${FW_OBJECT_FMT_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_FMT_LONG[@]}; do
                    Test file exists "${FW_OBJECT_FMT_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_FMT_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        levels)
            if [[ "${FW_OBJECT_LVL_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_LVL_LONG[@]}; do
                    Test file exists "${FW_OBJECT_LVL_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_LVL_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        messages)
            if [[ "${FW_OBJECT_MSG_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                    Test file exists "${FW_OBJECT_MSG_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_MSG_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        modes)
            if [[ "${FW_OBJECT_MOD_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_MOD_LONG[@]}; do
                    Test file exists "${FW_OBJECT_MOD_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_MOD_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        phases)
            if [[ "${FW_OBJECT_PHA_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                    Test file exists "${FW_OBJECT_PHA_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_PHA_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        settings)
            ;;

        themeitems)
            ;;

        themes)
            if [[ "${FW_OBJECT_THM_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_THM_LONG[@]}; do
                    Test file exists "${FW_OBJECT_THM_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_THM_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
