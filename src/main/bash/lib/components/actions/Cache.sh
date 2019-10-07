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
## Cache - action to caches something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Cache() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id dir file sedFile array name errno
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        formats)
            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/formats.cache"; touch ${file}
            if [[ -w "${file}" ]]; then
                rm ${file}; sedFile="${file}-sed"
                for array in FW_OBJECT_FMT_LONG FW_OBJECT_FMT_PATH; do declare -p ${array} >> ${sedFile}; echo "" >> ${sedFile}; done
                sed -e "s/declare -A/declare -A -g/g" ${sedFile} > ${file}; rm ${sedFile}
            fi ;;

        framework)
            for name in formats levels messages modes options phases themeitems; do
                Cache ${name}
            done ;;

        levels)
            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/levels.cache"; touch ${file}
            if [[ -w "${file}" ]]; then
                rm ${file}; sedFile="${file}-sed"
                for array in FW_OBJECT_LVL_LONG FW_OBJECT_LVL_PATH FW_OBJECT_LVL_CHAR_ABBR FW_OBJECT_LVL_STRING_THM; do declare -p ${array} >> ${sedFile}; echo "" >> ${sedFile}; done
                sed -e "s/declare -A/declare -A -g/g" ${sedFile} > ${file}; rm ${sedFile}
            fi ;;

        messages)
            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/messages.cache"; touch ${file}
            if [[ -w "${file}" ]]; then
                rm ${file}; sedFile="${file}-sed"
                for array in FW_OBJECT_MSG_LONG FW_OBJECT_MSG_TYPE FW_OBJECT_MSG_CAT FW_OBJECT_MSG_ARGS FW_OBJECT_MSG_TEXT FW_OBJECT_MSG_PATH; do declare -p ${array} >> ${sedFile}; echo "" >> ${sedFile}; done
                sed -e "s/declare -A/declare -A -g/g" ${sedFile} > ${file}; rm ${sedFile}
            fi ;;

        modes)
            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modes.cache"; touch ${file}
            if [[ -w "${file}" ]]; then
                rm ${file}; sedFile="${file}-sed"
                for array in FW_OBJECT_MOD_LONG FW_OBJECT_MOD_PATH; do declare -p ${array} >> ${sedFile}; echo "" >> ${sedFile}; done
                sed -e "s/declare -A/declare -A -g/g" ${sedFile} > ${file}; rm ${sedFile}
            fi ;;

        module)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"; if [[ "${id}" == "API" ]]; then Report process error "${FUNCNAME[0]}" "${cmd1}" E828 "module" "written"; return; fi
            Test existing module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then printf ""; return; fi

            mkdir -p ${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules
            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/${id}.cache"; touch ${file}
            if [[ ! -w "${file}" ]]; then printf "####"; return; fi
##TODO: Error message

            rm ${file}

            ## add applications
            if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_APP_LONG[@]}; do
                    if [[ "${FW_ELEMENT_APP_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_APP_LONG[\"${elemId}\"]=\""${FW_ELEMENT_APP_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_APP_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_APP_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_APP_COMMAND[\"${elemId}\"]=\""${FW_ELEMENT_APP_COMMAND["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_APP_ARGNUM[\"${elemId}\"]=\""${FW_ELEMENT_APP_ARGNUM["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_APP_ARGS[\"${elemId}\"]=\""${FW_ELEMENT_APP_ARGS["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_APP_PHA[\"${elemId}\"]=\""${FW_ELEMENT_APP_PHA["${elemId}"]}"\"" >> ${file}
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add dependencies
            if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_DEP_LONG[@]}; do
                    if [[ "${FW_ELEMENT_DEP_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_DEP_LONG[\"${elemId}\"]=\""${FW_ELEMENT_DEP_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DEP_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_DEP_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DEP_CMD[\"${elemId}\"]=\""${FW_ELEMENT_DEP_CMD["${elemId}"]}"\"" >> ${file}
                        if [[ -n "${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[\"${elemId}\"]=\""${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES["${elemId}"]}"\"" >> ${file}; fi
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add dirs
            if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_DIR_LONG[@]}; do
                    if [[ "${FW_ELEMENT_DIR_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_DIR_LONG[\"${elemId}\"]=\""${FW_ELEMENT_DIR_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DIR_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_DIR_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DIR_VAL[\"${elemId}\"]=\""${FW_ELEMENT_DIR_VAL["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DIR_MOD[\"${elemId}\"]=\""${FW_ELEMENT_DIR_MOD["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DIR_PHA[\"${elemId}\"]=\""${FW_ELEMENT_DIR_PHA["${elemId}"]}"\"" >> ${file}
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add dirlists
            if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_DLS_LONG[@]}; do
                    if [[ "${FW_ELEMENT_DLS_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_DLS_LONG[\"${elemId}\"]=\""${FW_ELEMENT_DLS_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DLS_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_DLS_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DLS_VAL[\"${elemId}\"]=\""${FW_ELEMENT_DLS_VAL["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DLS_MOD[\"${elemId}\"]=\""${FW_ELEMENT_DLS_MOD["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_DLS_PHA[\"${elemId}\"]=\""${FW_ELEMENT_DLS_PHA["${elemId}"]}"\"" >> ${file}
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add files
            if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_FIL_LONG[@]}; do
                    if [[ "${FW_ELEMENT_FIL_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_FIL_LONG[\"${elemId}\"]=\""${FW_ELEMENT_FIL_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_FIL_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_FIL_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_FIL_VAL[\"${elemId}\"]=\""${FW_ELEMENT_FIL_VAL["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_FIL_MOD[\"${elemId}\"]=\""${FW_ELEMENT_FIL_MOD["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_FIL_PHA[\"${elemId}\"]=\""${FW_ELEMENT_FIL_PHA["${elemId}"]}"\"" >> ${file}
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add filelists
            if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_FLS_LONG[@]}; do
                    if [[ "${FW_ELEMENT_FLS_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_FLS_LONG[\"${elemId}\"]=\""${FW_ELEMENT_FLS_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_FLS_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_FLS_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_FLS_VAL[\"${elemId}\"]=\""${FW_ELEMENT_FLS_VAL["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_FLS_MOD[\"${elemId}\"]=\""${FW_ELEMENT_FLS_MOD["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_FLS_PHA[\"${elemId}\"]=\""${FW_ELEMENT_FLS_PHA["${elemId}"]}"\"" >> ${file}
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add parameters
            if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_PAR_LONG[@]}; do
                    if [[ "${FW_ELEMENT_PAR_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_PAR_LONG[\"${elemId}\"]=\""${FW_ELEMENT_PAR_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PAR_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_PAR_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PAR_DEFVAL[\"${elemId}\"]=\""${FW_ELEMENT_PAR_DEFVAL["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PAR_PHA[\"${elemId}\"]=\""${FW_ELEMENT_PAR_PHA["${elemId}"]}"\"" >> ${file}
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add projects
            if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_PRJ_LONG[@]}; do
                    if [[ "${FW_ELEMENT_PRJ_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_PRJ_LONG[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PRJ_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PRJ_MODES[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_MODES["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PRJ_PATH[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_PATH["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PRJ_PATH_TEXT[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_PATH_TEXT["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PRJ_FILE[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_FILE["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_PRJ_TGTS[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_TGTS["${elemId}"]}"\"" >> ${file}
                        if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_APP["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_PRJ_REQUIRED_APP[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_REQUIRED_APP["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DEP["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_PRJ_REQUIRED_DEP[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_REQUIRED_DEP["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_PAR["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_PRJ_REQUIRED_PAR[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_REQUIRED_PAR["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_TSK["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_PRJ_REQUIRED_TSK[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_REQUIRED_TSK["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_FILE["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_PRJ_REQUIRED_FILE[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_REQUIRED_FILE["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_FILELIST["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_PRJ_REQUIRED_FILELIST[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_REQUIRED_FILELIST["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DIR["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_PRJ_REQUIRED_DIR[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_REQUIRED_DIR["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DIRLIST["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_PRJ_REQUIRED_DIRLIST[\"${elemId}\"]=\""${FW_ELEMENT_PRJ_REQUIRED_DIRLIST["${elemId}"]}"\"" >> ${file}; fi
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add scenarios
            if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_SCN_LONG[@]}; do
                    if [[ "${FW_ELEMENT_SCN_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_SCN_LONG[\"${elemId}\"]=\""${FW_ELEMENT_SCN_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_SCN_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_SCN_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_SCN_MODES[\"${elemId}\"]=\""${FW_ELEMENT_SCN_MODES["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_SCN_PATH[\"${elemId}\"]=\""${FW_ELEMENT_SCN_PATH["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_SCN_PATH_TEXT[\"${elemId}\"]=\""${FW_ELEMENT_SCN_PATH_TEXT["${elemId}"]}"\"" >> ${file}
                        if [[ -n "${FW_ELEMENT_SCN_REQUIRED_APP["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SCN_REQUIRED_APP[\"${elemId}\"]=\""${FW_ELEMENT_SCN_REQUIRED_APP["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DEP["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SCN_REQUIRED_DEP[\"${elemId}\"]=\""${FW_ELEMENT_SCN_REQUIRED_DEP["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SCN_REQUIRED_PAR["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SCN_REQUIRED_PAR[\"${elemId}\"]=\""${FW_ELEMENT_SCN_REQUIRED_PAR["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SCN_REQUIRED_TSK["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SCN_REQUIRED_TSK[\"${elemId}\"]=\""${FW_ELEMENT_SCN_REQUIRED_TSK["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SCN_REQUIRED_FILE["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SCN_REQUIRED_FILE[\"${elemId}\"]=\""${FW_ELEMENT_SCN_REQUIRED_FILE["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SCN_REQUIRED_FILELIST["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SCN_REQUIRED_FILELIST[\"${elemId}\"]=\""${FW_ELEMENT_SCN_REQUIRED_FILELIST["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DIR["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SCN_REQUIRED_DIR[\"${elemId}\"]=\""${FW_ELEMENT_SCN_REQUIRED_DIR["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DIRLIST["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SCN_REQUIRED_DIRLIST[\"${elemId}\"]=\""${FW_ELEMENT_SCN_REQUIRED_DIRLIST["${elemId}"]}"\"" >> ${file}; fi
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add sites
            if [[ "${FW_ELEMENT_SIT_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_SIT_LONG[@]}; do
                    if [[ "${FW_ELEMENT_SIT_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_SIT_LONG[\"${elemId}\"]=\""${FW_ELEMENT_SIT_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_SIT_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_SIT_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_SIT_PATH[\"${elemId}\"]=\""${FW_ELEMENT_SIT_PATH["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_SIT_PATH_TEXT[\"${elemId}\"]=\""${FW_ELEMENT_SIT_PATH_TEXT["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_SIT_FILE[\"${elemId}\"]=\""${FW_ELEMENT_SIT_FILE["${elemId}"]}"\"" >> ${file}
                        if [[ -n "${FW_ELEMENT_SIT_REQUIRED_APP["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SIT_REQUIRED_APP[\"${elemId}\"]=\""${FW_ELEMENT_SIT_REQUIRED_APP["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DEP["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SIT_REQUIRED_DEP[\"${elemId}\"]=\""${FW_ELEMENT_SIT_REQUIRED_DEP["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SIT_REQUIRED_PAR["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SIT_REQUIRED_PAR[\"${elemId}\"]=\""${FW_ELEMENT_SIT_REQUIRED_PAR["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SIT_REQUIRED_TSK["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SIT_REQUIRED_TSK[\"${elemId}\"]=\""${FW_ELEMENT_SIT_REQUIRED_TSK["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SIT_REQUIRED_FILE["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SIT_REQUIRED_FILE[\"${elemId}\"]=\""${FW_ELEMENT_SIT_REQUIRED_FILE["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SIT_REQUIRED_FILELIST["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SIT_REQUIRED_FILELIST[\"${elemId}\"]=\""${FW_ELEMENT_SIT_REQUIRED_FILELIST["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DIR["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SIT_REQUIRED_DIR[\"${elemId}\"]=\""${FW_ELEMENT_SIT_REQUIRED_DIR["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DIRLIST["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_SIT_REQUIRED_DIRLIST[\"${elemId}\"]=\""${FW_ELEMENT_SIT_REQUIRED_DIRLIST["${elemId}"]}"\"" >> ${file}; fi
                        echo "" >> ${file}
                    fi
                done
            fi

            ## add tasks
            if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then
                for elemId in ${!FW_ELEMENT_TSK_LONG[@]}; do
                    if [[ "${FW_ELEMENT_TSK_ORIG[${elemId}]}" == "${id}" ]]; then
                        echo "FW_ELEMENT_TSK_LONG[\"${elemId}\"]=\""${FW_ELEMENT_TSK_LONG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_TSK_ORIG[\"${elemId}\"]=\""${FW_ELEMENT_TSK_ORIG["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_TSK_MODES[\"${elemId}\"]=\""${FW_ELEMENT_TSK_MODES["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_TSK_PATH[\"${elemId}\"]=\""${FW_ELEMENT_TSK_PATH["${elemId}"]}"\"" >> ${file}
                        echo "FW_ELEMENT_TSK_PATH_TEXT[\"${elemId}\"]=\""${FW_ELEMENT_TSK_PATH_TEXT["${elemId}"]}"\"" >> ${file}
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_APP["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_TSK_REQUIRED_APP[\"${elemId}\"]=\""${FW_ELEMENT_TSK_REQUIRED_APP["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DEP["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_TSK_REQUIRED_DEP[\"${elemId}\"]=\""${FW_ELEMENT_TSK_REQUIRED_DEP["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_PAR["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_TSK_REQUIRED_PAR[\"${elemId}\"]=\""${FW_ELEMENT_TSK_REQUIRED_PAR["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_TSK["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_TSK_REQUIRED_TSK[\"${elemId}\"]=\""${FW_ELEMENT_TSK_REQUIRED_TSK["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FILE["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_TSK_REQUIRED_FILE[\"${elemId}\"]=\""${FW_ELEMENT_TSK_REQUIRED_FILE["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FILELIST["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_TSK_REQUIRED_FILELIST[\"${elemId}\"]=\""${FW_ELEMENT_TSK_REQUIRED_FILELIST["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIR["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_TSK_REQUIRED_DIR[\"${elemId}\"]=\""${FW_ELEMENT_TSK_REQUIRED_DIR["${elemId}"]}"\"" >> ${file}; fi
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIRLIST["${elemId}"]:-}" ]]; then echo "FW_ELEMENT_TSK_REQUIRED_DIRLIST[\"${elemId}\"]=\""${FW_ELEMENT_TSK_REQUIRED_DIRLIST["${elemId}"]}"\"" >> ${file}; fi
                        echo "alias ${elemId}=\"Execute task ${elemId}\"" >> ${file}
                        echo "" >> ${file}
                    fi
                done
            fi ;;

        options)
            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/options.cache"; touch ${file}
            if [[ -w "${file}" ]]; then
                rm ${file}; sedFile="${file}-sed"
                for array in FW_ELEMENT_OPT_LONG FW_ELEMENT_OPT_SHORT FW_ELEMENT_OPT_LS FW_ELEMENT_OPT_ARG FW_ELEMENT_OPT_CAT FW_ELEMENT_OPT_LEN; do declare -p ${array} >> ${sedFile}; echo "" >> ${sedFile}; done
                for elemId in ${!FW_ELEMENT_OPT_LONG[@]}; do echo "FW_ELEMENT_OPT_SET[\"${elemId}\"]=\"no\"; FW_ELEMENT_OPT_VAL[\"${elemId}\"]=\"\"" >> ${sedFile}; done
                echo "FW_ELEMENT_OPT_EXTRA=\"\"" >> ${sedFile}; echo "" >> ${sedFile}
                sed -e "s/declare -A/declare -A -g/g" ${sedFile} > ${file}; rm ${sedFile}
            fi ;;

        phases)
            file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/phases.cache"; touch ${file}
            if [[ -w "${file}" ]]; then
                rm ${file}; sedFile="${file}-sed"
                for array in FW_OBJECT_PHA_LONG FW_OBJECT_PHA_PRT_LVL FW_OBJECT_PHA_LOG_LVL FW_OBJECT_PHA_ERRCNT FW_OBJECT_PHA_WRNCNT FW_OBJECT_PHA_ERRCOD FW_OBJECT_PHA_PATH; do declare -p ${array} >> ${sedFile}; echo "" >> ${sedFile}; done
                sed -e "s/declare -A/declare -A -g/g" ${sedFile} > ${file}; rm ${sedFile}
            fi ;;

        themeitems)
             file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themeitems.cache"; touch ${file}
             if [[ -w "${file}" ]]; then
                rm ${file}; sedFile="${file}-sed"
                declare -p FW_OBJECT_TIM_LONG >> ${sedFile}; echo "" >> ${sedFile}
                sed -e "s/declare -A/declare -A -g/g" ${sedFile} > ${file}; rm ${sedFile}
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
