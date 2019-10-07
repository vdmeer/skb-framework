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
## Show - action to show something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Show() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id i padding stats count1 count2 statRule statHalfRule statSource statId file
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        statistics)
            statRule="  ────────────────────────────────────────────────────────────────────"
            statHalfRule="  ───────────────────────────────      ───────────────────────────────"

            stats="overview"
            if [[ "${#}" == 1 ]]; then stats="${1}"; fi
            case ${stats} in
                overview)
                    printf "\n  "; Format text bold Statistics; printf "\n"

                    printf "%s\n" "${statHalfRule}"
                        if [[ "${FW_OBJECT_CFG_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_CFG_LONG[@]}; else count1=0; fi
                        if [[ "${FW_OBJECT_SET_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_SET_LONG[@]}; else count2=0; fi
                        printf "   Configurations:           % 3s        Settings:                 % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_OBJECT_FMT_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_FMT_LONG[@]}; else count1=0; fi
                        if [[ "${FW_OBJECT_LVL_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_LVL_LONG[@]}; else count2=0; fi
                        printf "   Formats:                  % 3s        Levels:                   % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_OBJECT_MOD_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_MOD_LONG[@]}; else count1=0; fi
                        if [[ "${FW_OBJECT_PHA_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_PHA_LONG[@]}; else count2=0; fi
                        printf "   Modes:                    % 3s        Phases:                   % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_OBJECT_THM_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_THM_LONG[@]}; else count1=0; fi
                        if [[ "${FW_OBJECT_TIM_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_TIM_LONG[@]}; else count2=0; fi
                        printf "   Themes:                   % 3s        Theme Items:              % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_OBJECT_MSG_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_MSG_LONG[@]}; else count1=0; fi
                        printf "   Messages:                 % 3s\n"                                            "${count1}"

                    printf "%s\n" "${statHalfRule}"
                        if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_APP_LONG[@]}; else count1=0; fi
                        if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_DEP_LONG[@]}; else count2=0; fi
                        printf "   Applications:             % 3s        Dependencies:             % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_DIR_LONG[@]}; else count1=0; fi
                        if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_DLS_LONG[@]}; else count2=0; fi
                        printf "   Directoriess:             % 3s        Directory Lists:          % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_FIL_LONG[@]}; else count1=0; fi
                        if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_FLS_LONG[@]}; else count2=0; fi
                        printf "   Files:                    % 3s        File Lists:               % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_OPT_LONG[@]}; else count1=0; fi
                        if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_PAR_LONG[@]}; else count2=0; fi
                        printf "   Options:                  % 3s        Parameters:               % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_MDS_LONG[@]}; else count1=0; fi
                        printf "   Modules:                  % 3s\n"                                            "${count1}"

                        if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_PRJ_LONG[@]}; else count1=0; fi
                        if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_SCN_LONG[@]}; else count2=0; fi
                        printf "   Projects:                 % 3s        Scenarios:                % 3s\n"      "${count1}"     "${count2}"

                        if [[ "${FW_ELEMENT_SIT_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_SIT_LONG[@]}; else count1=0; fi
                        if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_TSK_LONG[@]}; else count2=0; fi
                        printf "   Sites:                    % 3s        Tasks:                    % 3s\n"      "${count1}"     "${count2}"

                    printf "%s\n" "${statHalfRule}"
                    printf "\n" ;;


                applications)
                    printf "\n  "; Format text bold Applications; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_APP_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                dependencies)
                    printf "\n  "; Format text bold Dependencies; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_DEP_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                dirlists)
                    printf "\n  "; Format text bold "Directory Lists"; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_DLS_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                dirs)
                    printf "\n  "; Format text bold Directories; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_DIR_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                filelists)
                    printf "\n  "; Format text bold "File Lists"; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_FLS_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                files)
                    printf "\n  "; Format text bold Files; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_FIL_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                options)
                    printf "\n  "; Format text bold Options; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_OPT_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                            if [[ "${FW_ELEMENT_OPT_CAT[${id}]}" == "Exit+Options" ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_ELEMENT_OPT_CAT[${id}]}" == "Runtime+Options" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - as exit option:         % 3s        - as runtime option:      % 3s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_OPT_LS[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -z "${FW_ELEMENT_OPT_LS[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - with short & long:      % 3s        - with long:              % 3s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_OPT_ARG[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                        done
                        printf "   - with argument:          % 3s\n"      "${count1}"
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                parameters)
                    printf "\n  "; Format text bold Parameters; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_PAR_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                projects)
                    printf "\n  "; Format text bold Projects; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_PRJ_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                scenarios)
                    printf "\n  "; Format text bold Scenarios; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_SCN_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            if [[ "${FW_ELEMENT_SCN_STATUS[${id}]}" != "N" ]]; then count1=$((count1 + 1)); fi
                        done
                        printf "   - tested:                 % 3s\n"      "${count1}"

                        printf "%s\n" "${statRule}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            case ${FW_ELEMENT_SCN_MODES[${id}]} in
                                all)    count1=$((count1 + 1)) ;;
                                build)  count2=$((count2 + 1)) ;;
                            esac
                        done
                        printf "   - for mode all:           % 3s        - for mode build:         % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            case ${FW_ELEMENT_SCN_MODES[${id}]} in
                                dev)    count1=$((count1 + 1)) ;;
                                use)    count2=$((count2 + 1)) ;;
                            esac
                        done
                        printf "   - for mode dev:           % 3s        - for mode use:           % 3s\n"      "${count1}"     "${count2}"

                        printf "%s\n" "${statRule}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_APP[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DEP[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require application:    % 3s        - require dependency:     % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_PAR[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require parameter:      % 3s        - require task:           % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_FILE[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require file:           % 3s        - require file list:      % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DIR[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require directory:      % 3s        - require directory list: % 3s\n"      "${count1}"     "${count2}"

                        printf "%s\n" "${statRule}"
                        statSource=" "; count1=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            case ${statSource} in
                                *" ${FW_ELEMENT_SCN_ORIG[${id}]} "*) ;;
                                *) statSource+="${FW_ELEMENT_SCN_ORIG[${id}]} "; count1=$((count1 + 1)) ;;
                            esac
                        done
                        printf "   From origins:             % 3s\n" "${count1}"
                        for statId in ${statSource}; do
                            count1=0
                            for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                                case ${FW_ELEMENT_SCN_ORIG[${id}]} in
                                    ${statId}) count1=$((count1 + 1)) ;;
                                esac
                            done
                            printf "   - %s:" "${statId}"
                            padding=$(( 24 - ${#statId} ))
                            for ((i = 1; i < ${padding}; i++)); do printf " "; done
                            printf "% 3s\n" "${count1}"
                        done
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                sites)
                    printf "\n  "; Format text bold Sites; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_SIT_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_SIT_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                tasks)
                    printf "\n  "; Format text bold Tasks; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_TSK_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ "${FW_ELEMENT_TSK_STATUS[${id}]}" != "N" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUESTED[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - tested:                 % 3s        - requested:              % 3s\n"      "${count1}"     "${count2}"

                        printf "%s\n" "${statRule}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            case ${FW_ELEMENT_TSK_MODES[${id}]} in
                                all)    count1=$((count1 + 1)) ;;
                                build)  count2=$((count2 + 1)) ;;
                            esac
                        done
                        printf "   - for mode all:           % 3s        - for mode build:         % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            case ${FW_ELEMENT_TSK_MODES[${id}]} in
                                dev)    count1=$((count1 + 1)) ;;
                                use)    count2=$((count2 + 1)) ;;
                            esac
                        done
                        printf "   - for mode dev:           % 3s        - for mode use:           % 3s\n"      "${count1}"     "${count2}"

                        printf "%s\n" "${statRule}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_APP[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require application:    % 3s        - require dependency:     % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require parameter:      % 3s        - require task:           % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FILE[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require file:           % 3s        - require file list:      % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require directory:      % 3s        - require directory list: % 3s\n"      "${count1}"     "${count2}"

                        printf "%s\n" "${statRule}"
                        statSource=" "; count1=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            case ${statSource} in
                                *" ${FW_ELEMENT_TSK_ORIG[${id}]} "*) ;;
                                *) statSource+="${FW_ELEMENT_TSK_ORIG[${id}]} "; count1=$((count1 + 1)) ;;
                            esac
                        done
                        printf "   From origins:             % 3s\n" "${count1}"
                        for statId in ${statSource}; do
                            count1=0
                            for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                                case ${FW_ELEMENT_TSK_ORIG[${id}]} in
                                    ${statId}) count1=$((count1 + 1)) ;;
                                esac
                            done
                            printf "   - %s:" "${statId}"
                            padding=$(( 24 - ${#statId} ))
                            for ((i = 1; i < ${padding}; i++)); do printf " "; done
                            printf "% 3s\n" "${count1}"
                        done
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                messages)
                    printf "\n  "; Format text bold Messages; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_OBJECT_MSG_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_MSG_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "error" ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "warning" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - type error:             % 3s        - type warning:           % 3s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "message" ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "info" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - type message:           % 3s        - type info:              % 3s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "debug" ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "trace" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - type debug:             % 3s        - type trace:             % 3s\n"      "${count1}"     "${count2}"

                        printf "%s\n" "${statRule}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 0 ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 1 ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - with 0 argument:        % 3s        - with 1 argumennt:       % 3s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 2 ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 3 ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - with 2 arguments:       % 3s        - with 3 arguments:       % 3s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 4 ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 5 ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - with 4 arguments:       % 3s        - with 5 arguments:       % 3s\n"      "${count1}"     "${count2}"

                        count1=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" > 5 ]]; then count1=$((count1 + 1)); fi
                        done
                        printf "   - more than 5 arguments:  % 3s\n"      "${count1}"
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                phases)
                    printf "\n  "; Format text bold Phases; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_OBJECT_PHA_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_PHA_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            count1=$((count1 + ${FW_OBJECT_PHA_WRNCNT[${id}]}))
                            count2=$((count2 + ${FW_OBJECT_PHA_ERRCNT[${id}]}))
                        done
                        printf "   - with warnings:          % 3s        - with errors:            % 3s\n"      "${count1}"     "${count2}"

                        printf "%s\n" "${statRule}"
                        printf "   by print level\n"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" fatalerror "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" error "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level fatalerror:   % 3s        - for level error:        % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" text "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" message "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level text:         % 3s        - for level message:      % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" warning "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" info "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level warning:      % 3s        - for level info:         % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" debug "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" trace "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level debug:        % 3s        - for level trace:        % 3s\n"      "${count1}"     "${count2}"

                        printf "%s\n" "${statRule}"
                        printf "   by log level\n"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" fatalerror "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" error "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level fatalerror:   % 3s        - for level error:        % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" text "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" message "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level text:         % 3s        - for level message:      % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" warning "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" info "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level warning:      % 3s        - for level info:         % 3s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" debug "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" trace "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level debug:        % 3s        - for level trace:        % 3s\n"      "${count1}"     "${count2}"
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                settings)
                    printf "\n  "; Format text bold Settings; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_OBJECT_SET_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_SET_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        statSource=" "; count1=0
                        for id in ${!FW_OBJECT_SET_LONG[@]}; do
                            case ${statSource} in
                                *" ${FW_OBJECT_SET_PHA[${id}]} "*) ;;
                                *) statSource+="${FW_OBJECT_SET_PHA[${id}]} "; count1=$((count1 + 1)) ;;
                            esac
                        done
                        printf "   - from sources:           % 3s\n" "${count1}"

                        printf "%s\n" "${statRule}"
                        printf "   by source:\n"
                        for statId in ${statSource}; do
                            count1=0
                            for id in ${!FW_OBJECT_SET_LONG[@]}; do
                                case ${FW_OBJECT_SET_PHA[${id}]} in
                                    ${statId}) count1=$((count1 + 1)) ;;
                                esac
                            done
                            printf "   - %s:" "${statId}"
                            padding=$(( 24 - ${#statId} ))
                            for ((i = 1; i < ${padding}; i++)); do printf " "; done
                            printf "% 3s\n" "${count1}"
                        done
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;

                themeitems)
                    printf "\n  "; Format text bold "Theme Items"; printf "\n"
                    printf "%s\n" "${statRule}"
                    if [[ "${FW_OBJECT_TIM_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_TIM_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 3s\n" "${count1}"
                    if (( count1 > 0 )); then
                        statSource=" "; count1=0
                        for id in ${!FW_OBJECT_TIM_LONG[@]}; do
                            case ${statSource} in
                                *" ${FW_OBJECT_TIM_SOURCE[${id}]} "*) ;;
                                *) statSource+="${FW_OBJECT_TIM_SOURCE[${id}]} "; count1=$((count1 + 1)) ;;
                            esac
                        done
                        printf "   - from sources:           % 3s\n" "${count1}"

                        printf "%s\n" "${statRule}"
                        printf "   by source:\n"
                        for statId in ${statSource}; do
                            count1=0
                            for id in ${!FW_OBJECT_TIM_LONG[@]}; do
                                case ${FW_OBJECT_TIM_SOURCE[${id}]} in
                                    ${statId}) count1=$((count1 + 1)) ;;
                                esac
                            done
                            printf "   - %s:" "${statId}"
                            padding=$(( 24 - ${#statId} ))
                            for ((i = 1; i < ${padding}; i++)); do printf " "; done
                            printf "% 3s\n" "${count1}"
                        done
                    fi
                    printf "%s\n" "${statRule}"
                    printf "\n" ;;
            esac ;;

        log | fast | load | medium | slow)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                log-file)
                    file="${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}"
                    if [[ -r "${file}" ]]; then  tput smcup; less -r -C -f -M -d ${file}; tput rmcup; fi ;;

                fast-runtime | load-runtime | medium-runtime | slow-runtime)
                    case ${cmd1} in
                        fast)                   file="${FW_RUNTIME_CONFIG_FAST}" ;;
                        load | medium | slow)   file="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_${cmd1^^}"]}" ;;
                    esac
                    if [[ -r "${file}" ]]; then tput smcup; less -C -f -M -d ${file}; tput rmcup; fi ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
