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
## Validate - command to validates something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_TAGS_COMMANDS["Validate"]="command to validate something"

function Validate() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local strict=false
    local id element dir printDir name expected modid modpath file extension
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        everything)
            strict="${1:-false}"
            Validate elements "${strict}"
            Validate objects "${strict}"
            Validate manual "${strict}"
            ;;

        elements)
            strict="${1:-false}"
            Validate applications "${strict}"
            Validate dependencies "${strict}"
            Validate dirlists "${strict}"
            Validate dirs "${strict}"
            Validate filelists "${strict}"
            Validate files "${strict}"
            Validate modules "${strict}"
            Validate options "${strict}"
            Validate parameters "${strict}"
            Validate projects "${strict}"
            Validate scenarios "${strict}"
            Validate sites "${strict}"
            Validate tasks "${strict}"
            ;;

        objects)
            strict="${1:-false}"
            Validate configuration "${strict}"
            Validate formats "${strict}"
            Validate levels "${strict}"
            Validate messages "${strict}"
            Validate modes "${strict}"
            Validate phases "${strict}"
            Validate settings "${strict}"
            Validate themeitems "${strict}"
            Validate themes "${strict}"
            ;;


        manual)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi

            for element in framework commands components elements instances objects options tags; do
                dir="${SF_HOME}/lib/text/${element}"
                printDir="\$SF_HOME/lib/text/${element}"
                case ${element} in
                    framework)  expected="authors bugs copying description resources security" ;;
                    components) expected="commands elements instances objects" ;;
                    commands)   expected="Add Ask Build Calculate Clear Convert Debug Describe Execute Filter Finalize Format Get List Load Parse Prepare Print Repeat Report Set Show Terminate Test Validate Verify Write" ;;
                    instances)  expected="Cli Tablechars" ;;
                    elements)   expected="Applications Dependencies Dirlists Dirs Filelists Files Modules Options Parameters Projects Scenarios Sites Tasks"
                                expected+=" exit-options run-options" ;;
                    objects)    expected="Configuration Formats Levels Messages Modes Phases Settings Themeitems Themes" ;;
                    options)    expected="all-mode build-mode config-file execute-command dev-mode execute-task format help no-runtime-tests option execute-scenario runtime-tests strict-mode test-colors test-effects test-characters test-terminal use-mode version" ;;
                    tags)       expected="authors name" ;;
                esac

                for name in ${expected}; do
                    Test file exists "${dir}/${name}.txt" "${printDir}/${name}.txt"; Test file can read "${dir}/${name}.txt" "${printDir}/${name}.txt"
                    if [[ "${element}" != "tags" ]]; then
                        Test file exists "${dir}/${name}.adoc" "${printDir}/${name}.adoc"; Test file can read "${dir}/${name}.adoc" "${printDir}/${name}.adoc"
                    fi
                done
                for file in ${dir}/**; do
                    file=${file##*/}; extension=${file##*.}; name=${file%%.*}
                    case "${expected}" in
                        *"${name}"*) ;;
                        *) Report application strictwarning E826 "${file}" "${printDir}"
                    esac
                    case "${extension}" in
                        txt | adoc) ;;
                        *) Report application strictwarning E826 "${file}" "${printDir}"
                    esac
                done
            done ;;


        applications)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_APP_LONG[@]}; do
                    modid="${FW_ELEMENT_APP_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/applications/${id}.txt"; Test file can read "${modpath}/applications/${id}.txt"
                    Test file exists "${modpath}/applications/${id}.adoc"; Test file can read "${modpath}/applications/${id}.adoc"
                done
            fi ;;        dependencies)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                    modid="${FW_ELEMENT_DEP_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/dependencies/${id}.txt"; Test file can read "${modpath}/dependencies/${id}.txt"
                    Test file exists "${modpath}/dependencies/${id}.adoc"; Test file can read "${modpath}/dependencies/${id}.adoc"
                done
            fi ;;

        dirlists)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            ;;

        dirs)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DIR_LONG[@]}; do
                    modid="${FW_ELEMENT_DIR_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/dirs/${id}.txt"; Test file can read "${modpath}/dirs/${id}.txt"
                    Test file exists "${modpath}/dirs/${id}.adoc"; Test file can read "${modpath}/dirs/${id}.adoc"
                done
            fi ;;

        filelists)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            ;;

        files)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_FIL_LONG[@]}; do
                    modid="${FW_ELEMENT_FIL_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/files/${id}.txt"; Test file can read "${modpath}/files/${id}.txt"
                    Test file exists "${modpath}/files/${id}.adoc"; Test file can read "${modpath}/files/${id}.adoc"
                done
            fi ;;

        dependencies)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                    modid="${FW_ELEMENT_DEP_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/dependencies/${id}.txt"; Test file can read "${modpath}/dependencies/${id}.txt"
                    Test file exists "${modpath}/dependencies/${id}.adoc"; Test file can read "${modpath}/dependencies/${id}.adoc"
                done
            fi ;;

        modules)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_MDS_LONG[@]}; do
                    Test file exists "${FW_ELEMENT_MDS_PATH[${id}]}/${id}.txt"; Test file can read "${FW_ELEMENT_MDS_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_ELEMENT_MDS_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_ELEMENT_MDS_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        options)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                    Test file exists "${SF_HOME}/lib/text/options/${id}.txt"; Test file can read "${SF_HOME}/lib/text/options/${id}.txt"
                    Test file exists "${SF_HOME}/lib/text/options/${id}.adoc"; Test file can read "${SF_HOME}/lib/text/options/${id}.adoc"
                done
            fi ;;

        parameters)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_PAR_LONG[@]}; do
                    modid="${FW_ELEMENT_PAR_ORIG[${id}]}"
                    modpath="${FW_ELEMENT_MDS_PATH[${modid}]}"
                    Test file exists "${modpath}/parameters/${id}.txt"; Test file can read "${modpath}/parameters/${id}.txt"
                    Test file exists "${modpath}/parameters/${id}.adoc"; Test file can read "${modpath}/parameters/${id}.adoc"
                done
            fi ;;

        projects)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            ;;

        scenarios)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                    Test file exists "${FW_ELEMENT_SCN_PATH[${id}]}/${id}.txt"; Test file can read "${FW_ELEMENT_SCN_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_ELEMENT_SCN_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_ELEMENT_SCN_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        sites)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            ;;

        tasks)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                    Test file exists "${FW_ELEMENT_TSK_PATH[${id}]}/${id}.txt"; Test file can read "${FW_ELEMENT_TSK_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_ELEMENT_TSK_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_ELEMENT_TSK_PATH[${id}]}/${id}.adoc"
                done
            fi ;;


        configuration)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            ;;

        formats)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_OBJECT_FMT_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_FMT_LONG[@]}; do
                    Test file exists "${FW_OBJECT_FMT_PATH[${id}]}/${id}.txt"; Test file can read "${FW_OBJECT_FMT_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_OBJECT_FMT_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_FMT_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        levels)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_OBJECT_LVL_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_LVL_LONG[@]}; do
                    Test file exists "${FW_OBJECT_LVL_PATH[${id}]}/${id}.txt"; Test file can read "${FW_OBJECT_LVL_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_OBJECT_LVL_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_LVL_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        messages)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_OBJECT_MSG_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                    Test file exists "${FW_OBJECT_MSG_PATH[${id}]}/${id}.txt"; Test file can read "${FW_OBJECT_MSG_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_OBJECT_MSG_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_MSG_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        modes)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_OBJECT_MOD_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_MOD_LONG[@]}; do
                    Test file exists "${FW_OBJECT_MOD_PATH[${id}]}/${id}.txt"; Test file can read "${FW_OBJECT_MOD_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_OBJECT_MOD_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_MOD_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        phases)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_OBJECT_PHA_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                    Test file exists "${FW_OBJECT_PHA_PATH[${id}]}/${id}.txt"; Test file can read "${FW_OBJECT_PHA_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_OBJECT_PHA_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_PHA_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        settings)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            ;;

        themeitems)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            ;;

        themes)
            strict="${1:-false}"
            if [[ "${strict}" == true ]]; then Set strict mode on; fi
            if [[ "${FW_OBJECT_THM_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_THM_LONG[@]}; do
                    Test file exists "${FW_OBJECT_THM_PATH[${id}]}/${id}.txt"; Test file can read "${FW_OBJECT_THM_PATH[${id}]}/${id}.txt"
                    Test file exists "${FW_OBJECT_THM_PATH[${id}]}/${id}.adoc"; Test file can read "${FW_OBJECT_THM_PATH[${id}]}/${id}.adoc"
                done
            fi ;;

        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
