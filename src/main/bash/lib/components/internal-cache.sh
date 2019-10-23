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
## internal / cache - internal functions called by the API, writing to cache files
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_internal_cache_object_formats () {
    local id module="${1}" file="${2}"
    for id in ${!FW_OBJECT_FMT_LONG[@]}; do
        if [[ "${FW_OBJECT_FMT_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_OBJECT_FMT_LONG[\"${id}\"]=\"${FW_OBJECT_FMT_LONG["${id}"]}\"
FW_OBJECT_FMT_DECMDS[\"${id}\"]=\"${FW_OBJECT_FMT_DECMDS["${id}"]}\"
FW_OBJECT_FMT_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_object_levels () {
    local id module="${1}" file="${2}"
    for id in ${!FW_OBJECT_LVL_LONG[@]}; do
        if [[ "${FW_OBJECT_LVL_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_OBJECT_LVL_LONG[\"${id}\"]=\"${FW_OBJECT_LVL_LONG["${id}"]}\"
FW_OBJECT_LVL_DECMDS[\"${id}\"]=\"${FW_OBJECT_LVL_DECMDS["${id}"]}\"
FW_OBJECT_LVL_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_OBJECT_LVL_CHAR_ABBR[\"${id}\"]=\"${FW_OBJECT_LVL_CHAR_ABBR["${id}"]}\"
FW_OBJECT_LVL_STRING_THM[\"${id}\"]=\"${FW_OBJECT_LVL_STRING_THM["${id}"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_object_messages () {
    local id module="${1}" file="${2}"
    for id in ${!FW_OBJECT_MSG_LONG[@]}; do
        if [[ "${FW_OBJECT_MSG_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_OBJECT_MSG_LONG[\"${id}\"]=\"${FW_OBJECT_MSG_LONG["${id}"]}\"
FW_OBJECT_MSG_DECMDS[\"${id}\"]=\"${FW_OBJECT_MSG_DECMDS["${id}"]}\"
FW_OBJECT_MSG_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_OBJECT_MSG_TYPE[\"${id}\"]=\"${FW_OBJECT_MSG_TYPE["${id}"]}\"
FW_OBJECT_MSG_CAT[\"${id}\"]=\"${FW_OBJECT_MSG_CAT["${id}"]}\"
FW_OBJECT_MSG_ARGS[\"${id}\"]=\"${FW_OBJECT_MSG_ARGS["${id}"]}\"
FW_OBJECT_MSG_TEXT[\"${id}\"]=\"${FW_OBJECT_MSG_TEXT["${id}"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_object_modes () {
    local id module="${1}" file="${2}"
    for id in ${!FW_OBJECT_MOD_LONG[@]}; do
        if [[ "${FW_OBJECT_MOD_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_OBJECT_MOD_LONG[\"${id}\"]=\"${FW_OBJECT_MOD_LONG["${id}"]}\"
FW_OBJECT_MOD_DECMDS[\"${id}\"]=\"${FW_OBJECT_MOD_DECMDS["${id}"]}\"
FW_OBJECT_MOD_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_object_phases () {
    local id module="${1}" file="${2}"
    for id in ${!FW_OBJECT_PHA_LONG[@]}; do
        if [[ "${FW_OBJECT_PHA_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_OBJECT_PHA_LONG[\"${id}\"]=\"${FW_OBJECT_PHA_LONG["${id}"]}\"
FW_OBJECT_PHA_DECMDS[\"${id}\"]=\"${FW_OBJECT_PHA_DECMDS["${id}"]}\"
FW_OBJECT_PHA_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_OBJECT_PHA_PRT_LVL[\"${id}\"]=\"${FW_OBJECT_PHA_PRT_LVL["${id}"]}\"
FW_OBJECT_PHA_LOG_LVL[\"${id}\"]=\"${FW_OBJECT_PHA_LOG_LVL["${id}"]}\"
FW_OBJECT_PHA_ERRCNT[\"${id}\"]=\"0\"
FW_OBJECT_PHA_WRNCNT[\"${id}\"]=\"0\"
FW_OBJECT_PHA_MSGCOD[\"${id}\"]=\"\"
FW_OBJECT_PHA_MSGCODCNT[\"${id}\"]=\"0\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_object_themeitems () {
    local id module="${1}" file="${2}"
    for id in ${!FW_OBJECT_TIM_LONG[@]}; do
        if [[ "${FW_OBJECT_TIM_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_OBJECT_TIM_LONG[\"${id}\"]=\"${FW_OBJECT_TIM_LONG["${id}"]}\"
FW_OBJECT_TIM_DECMDS[\"${id}\"]=\"${FW_OBJECT_TIM_DECMDS["${id}"]}\"
FW_OBJECT_TIM_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_OBJECT_TIM_SOURCE[\"${id}\"]=\"\"
FW_OBJECT_TIM_VAL[\"${id}\"]=\"\"
FW_OBJECT_TIM_STATUS[\"${id}\"]=\"N\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_theme () {
    local id="${1}" modID="${2}" file="${3}" themeFile="${4}" themeFileText="${5}"
    local count=0 line itemId itemVal
    printf "#!/usr/bin/env bash

##
## Theme ${id} - raw theme items
## - generated by skb-framework ${SF_VERSION} on $(date)
## - for module ${modID}
## - from source ${themeFileText}
##

" >> ${file}

    while read line; do
        case "${line}" in
            "Set object themeitem "*)
                line=${line##"Set object themeitem "}
                itemId="${line%% *}"
                itemVal="${line#*to * }"
                shopt -s extglob
                itemVal="${itemVal##*( )}"
                shopt -u extglob
                printf "
FW_OBJECT_TIM_VAL[${itemId}]=${itemVal}
FW_OBJECT_TIM_SOURCE[${itemId}]=\"${id}\"
" >> ${file}
                count=$(( count + 1 )) ;;
        esac
        done < ${themeFile}
}



function __skb_internal_cache_store () {
    local file="${1}" sedFile
    sedFile="${file}-sed"
    Stores build all
    declare -p FW_OBJECT_STO_CHARS >> ${sedFile}
    declare -p FW_OBJECT_STO_LEGENDS >> ${sedFile}
    declare -p FW_OBJECT_STO_SET >> ${sedFile}
    declare -p FW_OBJECT_STO_TEMPLATES >> ${sedFile}
    printf "export FW_OBJECT_STO_STORED=\"${FW_OBJECT_STO_STORED}\"" >> ${sedFile}
    printf "export FW_OBJECT_STO_COUNT=4\n\n" >> ${sedFile}
    sed -e "s/declare -A/declare -A -g/g" -e "s/FW_ELEMENT_OPT_/FW_INSTANCE_CLI_/g" ${sedFile} > ${file}
    rm ${sedFile}
}



function __skb_internal_cache_fw_options () {
    local id file="${1}" sedFile array
    sedFile="${file}-sed"
    for array in FW_ELEMENT_OPT_LONG FW_ELEMENT_OPT_SHORT FW_ELEMENT_OPT_LS FW_ELEMENT_OPT_SORT FW_ELEMENT_OPT_ARG FW_ELEMENT_OPT_CAT FW_ELEMENT_OPT_LEN; do declare -p ${array} >> ${sedFile}; echo "" >> ${sedFile}; done
    for id in ${!FW_ELEMENT_OPT_LONG[@]}; do echo "FW_ELEMENT_OPT_SET[\"${id}\"]=\"no\"; FW_ELEMENT_OPT_VAL[\"${id}\"]=\"\"" >> ${sedFile}; done
    sed -e "s/declare -A/declare -A -g/g" -e "s/FW_ELEMENT_OPT_/FW_INSTANCE_CLI_/g" ${sedFile} > ${file}; rm ${sedFile}
}




function __skb_internal_cache_element_applications () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_APP_LONG[@]}; do
        if [[ "${FW_ELEMENT_APP_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_APP_LONG[\"${id}\"]=\"${FW_ELEMENT_APP_LONG["${id}"]}\"
FW_ELEMENT_APP_DECMDS[\"${id}\"]=\"${FW_ELEMENT_APP_DECMDS["${id}"]}\"
FW_ELEMENT_APP_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_APP_COMMAND[\"${id}\"]=\"${FW_ELEMENT_APP_COMMAND["${id}"]}\"
FW_ELEMENT_APP_ARGNUM[\"${id}\"]=${FW_ELEMENT_APP_ARGNUM["${id}"]}
FW_ELEMENT_APP_ARGS[\"${id}\"]=\"${FW_ELEMENT_APP_ARGS["${id}"]}\"
FW_ELEMENT_APP_PHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_dependencies () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
        if [[ "${FW_ELEMENT_DEP_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_DEP_LONG[\"${id}\"]=\"${FW_ELEMENT_DEP_LONG["${id}"]}\"
FW_ELEMENT_DEP_DECMDS[\"${id}\"]=\"${FW_ELEMENT_DEP_DECMDS["${id}"]}\"
FW_ELEMENT_DEP_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_DEP_COMMAND[\"${id}\"]=\"${FW_ELEMENT_DEP_COMMAND["${id}"]}\"
FW_ELEMENT_DEP_REQOUT_COUNT[\"${id}\"]=${FW_ELEMENT_DEP_REQOUT_COUNT["${id}"]}
FW_ELEMENT_DEP_REQOUT_DEP[\"${id}\"]=\"${FW_ELEMENT_DEP_REQOUT_DEP["${id}"]:-}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_dirlists () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_DLS_LONG[@]}; do
        if [[ "${FW_ELEMENT_DLS_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_DLS_LONG[\"${id}\"]=\"${FW_ELEMENT_DLS_LONG["${id}"]}\"
FW_ELEMENT_DLS_DECMDS[\"${id}\"]=\"${FW_ELEMENT_DLS_DECMDS["${id}"]}\"
FW_ELEMENT_DLS_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_DLS_VAL[\"${id}\"]=\"${FW_ELEMENT_DLS_VAL["${id}"]}\"
FW_ELEMENT_DLS_MOD[\"${id}\"]=\"${FW_ELEMENT_DLS_MOD["${id}"]}\"
FW_ELEMENT_DLS_PHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_dirs () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_DIR_LONG[@]}; do
        if [[ "${FW_ELEMENT_DIR_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_DIR_LONG[\"${id}\"]=\"${FW_ELEMENT_DIR_LONG["${id}"]}\"
FW_ELEMENT_DIR_DECMDS[\"${id}\"]=\"${FW_ELEMENT_DIR_DECMDS["${id}"]}\"
FW_ELEMENT_DIR_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_DIR_VAL[\"${id}\"]=\"${FW_ELEMENT_DIR_VAL["${id}"]}\"
FW_ELEMENT_DIR_MOD[\"${id}\"]=\"${FW_ELEMENT_DIR_MOD["${id}"]}\"
FW_ELEMENT_DIR_PHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_filelists () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_FLS_LONG[@]}; do
        if [[ "${FW_ELEMENT_FLS_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_FLS_LONG[\"${id}\"]=\"${FW_ELEMENT_FLS_LONG["${id}"]}\"
FW_ELEMENT_FLS_DECMDS[\"${id}\"]=\"${FW_ELEMENT_FLS_DECMDS["${id}"]}\"
FW_ELEMENT_FLS_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_FLS_VAL[\"${id}\"]=\"${FW_ELEMENT_FLS_VAL["${id}"]}\"
FW_ELEMENT_FLS_MOD[\"${id}\"]=\"${FW_ELEMENT_FLS_MOD["${id}"]}\"
FW_ELEMENT_FLS_PHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_files () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_FIL_LONG[@]}; do
        if [[ "${FW_ELEMENT_FIL_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_FIL_LONG[\"${id}\"]=\"${FW_ELEMENT_FIL_LONG["${id}"]}\"
FW_ELEMENT_FIL_DECMDS[\"${id}\"]=\"${FW_ELEMENT_FIL_DECMDS["${id}"]}\"
FW_ELEMENT_FIL_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_FIL_VAL[\"${id}\"]=\"${FW_ELEMENT_FIL_VAL["${id}"]}\"
FW_ELEMENT_FIL_MOD[\"${id}\"]=\"${FW_ELEMENT_FIL_MOD["${id}"]}\"
FW_ELEMENT_FIL_PHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_parameters () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_PAR_LONG[@]}; do
        if [[ "${FW_ELEMENT_PAR_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_PAR_LONG[\"${id}\"]=\"${FW_ELEMENT_PAR_LONG["${id}"]}\"
FW_ELEMENT_PAR_DECMDS[\"${id}\"]=\"${FW_ELEMENT_PAR_DECMDS["${id}"]}\"
FW_ELEMENT_PAR_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_PAR_DEFVAL[\"${id}\"]=\"${FW_ELEMENT_PAR_DEFVAL["${id}"]}\"
FW_ELEMENT_PAR_VAL[\"${id}\"]=\"${FW_ELEMENT_PAR_VAL["${id}"]}\"
FW_ELEMENT_PAR_PHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_projects () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_PRJ_LONG[@]}; do
        if [[ "${FW_ELEMENT_PRJ_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_PRJ_LONG[\"${id}\"]=\"${FW_ELEMENT_PRJ_LONG["${id}"]}\"
FW_ELEMENT_PRJ_DECMDS[\"${id}\"]=\"${FW_ELEMENT_PRJ_DECMDS["${id}"]}\"
FW_ELEMENT_PRJ_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_PRJ_MODES[\"${id}\"]=\"${FW_ELEMENT_PRJ_MODES["${id}"]}\"
FW_ELEMENT_PRJ_PATH[\"${id}\"]=\"${FW_ELEMENT_PRJ_PATH["${id}"]}\"
FW_ELEMENT_PRJ_PATH_TEXT[\"${id}\"]=\"${FW_ELEMENT_PRJ_PATH_TEXT["${id}"]}\"
FW_ELEMENT_PRJ_RDIR[\"${id}\"]=\"${FW_ELEMENT_PRJ_RDIR["${id}"]}\"
FW_ELEMENT_PRJ_TGTS[\"${id}\"]=\"${FW_ELEMENT_PRJ_TGTS["${id}"]}\"
FW_ELEMENT_PRJ_SHOW_EXEC[\"${id}\"]=\"${FW_ELEMENT_PRJ_SHOW_EXEC["${id}"]}\"
FW_ELEMENT_PRJ_REQOUT_COUNT[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_COUNT["${id}"]}\"
FW_ELEMENT_PRJ_REQOUT_APP[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_APP["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_DEP[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_DEP["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_PAR[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_PAR["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_PRJ[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_PRJ["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_SCN[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_SCN["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_SIT[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_SIT["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_TSK[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_TSK["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_FIL[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_FIL["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_FLS[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_FLS["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_DIR[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_DIR["${id}"]:-}\"
FW_ELEMENT_PRJ_REQOUT_DLS[\"${id}\"]=\"${FW_ELEMENT_PRJ_REQOUT_DLS["${id}"]:-}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_scenarios () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
        if [[ "${FW_ELEMENT_SCN_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_SCN_LONG[\"${id}\"]=\"${FW_ELEMENT_SCN_LONG["${id}"]}\"
FW_ELEMENT_SCN_DECMDS[\"${id}\"]=\"${FW_ELEMENT_SCN_DECMDS["${id}"]}\"
FW_ELEMENT_SCN_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_SCN_MODES[\"${id}\"]=\"${FW_ELEMENT_SCN_MODES["${id}"]}\"
FW_ELEMENT_SCN_PATH[\"${id}\"]=\"${FW_ELEMENT_SCN_PATH["${id}"]}\"
FW_ELEMENT_SCN_PATH_TEXT[\"${id}\"]=\"${FW_ELEMENT_SCN_PATH_TEXT["${id}"]}\"
FW_ELEMENT_SCN_SHOW_EXEC[\"${id}\"]=\"${FW_ELEMENT_SCN_SHOW_EXEC["${id}"]}\"
FW_ELEMENT_SCN_REQOUT_COUNT[\"${id}\"]=\"${FW_ELEMENT_SCN_REQOUT_COUNT["${id}"]}\"
FW_ELEMENT_SCN_REQOUT_APP[\"${id}\"]=\"${FW_ELEMENT_SCN_REQOUT_APP["${id}"]:-}\"
FW_ELEMENT_SCN_REQOUT_SCN[\"${id}\"]=\"${FW_ELEMENT_SCN_REQOUT_SCN["${id}"]:-}\"
FW_ELEMENT_SCN_REQOUT_TSK[\"${id}\"]=\"${FW_ELEMENT_SCN_REQOUT_TSK["${id}"]:-}\"
alias scenario-${id}=\"Execute scenarion ${id}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_scripts () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_SCR_LONG[@]}; do
        if [[ "${FW_ELEMENT_SCR_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_SCR_LONG[\"${id}\"]=\"${FW_ELEMENT_SCR_LONG["${id}"]}\"
FW_ELEMENT_SCR_DECMDS[\"${id}\"]=\"${FW_ELEMENT_SCR_DECMDS["${id}"]}\"
FW_ELEMENT_SCR_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_SCR_MODES[\"${id}\"]=\"${FW_ELEMENT_SCR_MODES["${id}"]}\"
FW_ELEMENT_SCR_PATH[\"${id}\"]=\"${FW_ELEMENT_SCR_PATH["${id}"]}\"
FW_ELEMENT_SCR_PATH_TEXT[\"${id}\"]=\"${FW_ELEMENT_SCR_PATH_TEXT["${id}"]}\"
FW_ELEMENT_SCR_RDIR[\"${id}\"]=\"${FW_ELEMENT_SCR_RDIR["${id}"]}\"
FW_ELEMENT_SCR_SHOW_EXEC[\"${id}\"]=\"${FW_ELEMENT_SCR_SHOW_EXEC["${id}"]}\"
FW_ELEMENT_SCR_REQOUT_COUNT[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_COUNT["${id}"]}\"
FW_ELEMENT_SCR_REQOUT_APP[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_APP["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_DEP[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_DEP["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_PAR[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_PAR["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_PRJ[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_PRJ["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_SCN[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_SCN["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_SCR[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_SCR["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_SIT[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_SIT["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_TSK[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_TSK["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_FIL[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_FIL["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_FLS[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_FLS["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_DIR[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_DIR["${id}"]:-}\"
FW_ELEMENT_SCR_REQOUT_DLS[\"${id}\"]=\"${FW_ELEMENT_SCR_REQOUT_DLS["${id}"]:-}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_sites () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_SIT_LONG[@]}; do
        if [[ "${FW_ELEMENT_SIT_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_SIT_LONG[\"${id}\"]=\"${FW_ELEMENT_SIT_LONG["${id}"]}\"
FW_ELEMENT_SIT_DECMDS[\"${id}\"]=\"${FW_ELEMENT_SIT_DECMDS["${id}"]}\"
FW_ELEMENT_SIT_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_SIT_MODES[\"${id}\"]=\"${FW_ELEMENT_SIT_MODES["${id}"]}\"
FW_ELEMENT_SIT_PATH[\"${id}\"]=\"${FW_ELEMENT_SIT_PATH["${id}"]}\"
FW_ELEMENT_SIT_PATH_TEXT[\"${id}\"]=\"${FW_ELEMENT_SIT_PATH_TEXT["${id}"]}\"
FW_ELEMENT_SIT_RDIR[\"${id}\"]=\"${FW_ELEMENT_SIT_RDIR["${id}"]}\"
FW_ELEMENT_SIT_SHOW_EXEC[\"${id}\"]=\"${FW_ELEMENT_SIT_SHOW_EXEC["${id}"]}\"
FW_ELEMENT_SIT_REQOUT_COUNT[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_COUNT["${id}"]}\"
FW_ELEMENT_SIT_REQOUT_APP[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_APP["${id}"]:-}\"
FW_ELEMENT_SIT_REQOUT_DEP[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_DEP["${id}"]:-}\"
FW_ELEMENT_SIT_REQOUT_PAR[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_PAR["${id}"]:-}\"
FW_ELEMENT_SIT_REQOUT_SCN[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_SCN["${id}"]:-}\"
FW_ELEMENT_SIT_REQOUT_TSK[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_TSK["${id}"]:-}\"
FW_ELEMENT_SIT_REQOUT_FIL[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_FIL["${id}"]:-}\"
FW_ELEMENT_SIT_REQOUT_FLS[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_FLS["${id}"]:-}\"
FW_ELEMENT_SIT_REQOUT_DIR[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_DIR["${id}"]:-}\"
FW_ELEMENT_SIT_REQOUT_DLS[\"${id}\"]=\"${FW_ELEMENT_SIT_REQOUT_DLS["${id}"]:-}\"
" >> ${file}
        fi
    done
}



function __skb_internal_cache_element_tasks () {
    local id module="${1}" file="${2}"
    for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
        if [[ "${FW_ELEMENT_TSK_DECMDS["${id}"]}" == "${module}" ]]; then
            printf "
FW_ELEMENT_TSK_LONG[\"${id}\"]=\"${FW_ELEMENT_TSK_LONG["${id}"]}\"
FW_ELEMENT_TSK_DECMDS[\"${id}\"]=\"${FW_ELEMENT_TSK_DECMDS["${id}"]}\"
FW_ELEMENT_TSK_DECPHA[\"${id}\"]=\"\${FW_OBJECT_SET_VAL[\"CURRENT_PHASE\"]}\"
FW_ELEMENT_TSK_MODES[\"${id}\"]=\"${FW_ELEMENT_TSK_MODES["${id}"]}\"
FW_ELEMENT_TSK_PATH[\"${id}\"]=\"${FW_ELEMENT_TSK_PATH["${id}"]}\"
FW_ELEMENT_TSK_PATH_TEXT[\"${id}\"]=\"${FW_ELEMENT_TSK_PATH_TEXT["${id}"]}\"
FW_ELEMENT_TSK_SHOW_EXEC[\"${id}\"]=\"${FW_ELEMENT_TSK_SHOW_EXEC["${id}"]}\"
FW_ELEMENT_TSK_REQOUT_COUNT[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_COUNT["${id}"]}\"
FW_ELEMENT_TSK_REQOUT_APP[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_APP["${id}"]:-}\"
FW_ELEMENT_TSK_REQOUT_DEP[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_DEP["${id}"]:-}\"
FW_ELEMENT_TSK_REQOUT_PAR[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_PAR["${id}"]:-}\"
FW_ELEMENT_TSK_REQOUT_TSK[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_TSK["${id}"]:-}\"
FW_ELEMENT_TSK_REQOUT_FIL[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_FIL["${id}"]:-}\"
FW_ELEMENT_TSK_REQOUT_FLS[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_FLS["${id}"]:-}\"
FW_ELEMENT_TSK_REQOUT_DIR[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_DIR["${id}"]:-}\"
FW_ELEMENT_TSK_REQOUT_DLS[\"${id}\"]=\"${FW_ELEMENT_TSK_REQOUT_DLS["${id}"]:-}\"
alias ${id}=\"Execute task ${id}\"
" >> ${file}
        fi
    done
}

