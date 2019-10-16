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
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id i stats count1 count2 statSource statId file timeStamp char width tsStart tsEnd
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        statistics)
            stats="overview"
            if [[ "${#}" == 0 ]]; then
                : ## nothing to do here
            elif [[ "${#}" == 1 ]]; then
                stats="${1}"
            else
                if [[ "${1}" != "for" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} ${1} ..." E803 "${2}"; return; fi
                stats="${2}"
            fi

            case ${stats} in
                overview)   __skb_internal_stats_overview ;;
                time)       __skb_internal_stats_time ;;

                applications)
                    printf "\n  "; Format text bold Applications; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_APP_LONG[@]}; else count1=0; fi
                    printf "   Declared:               % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                dependencies)
                    printf "\n  "; Format text bold Dependencies; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_DEP_LONG[@]}; else count1=0; fi
                    printf "   Declared:               % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                dirlists)
                    printf "\n  "; Format text bold "Directory Lists"; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_DLS_LONG[@]}; else count1=0; fi
                    printf "   Declared:               % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                dirs)
                    printf "\n  "; Format text bold Directories; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_DIR_LONG[@]}; else count1=0; fi
                    printf "   Declared:               % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                filelists)
                    printf "\n  "; Format text bold "File Lists"; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_FLS_LONG[@]}; else count1=0; fi
                    printf "   Declared:               % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                files)
                    printf "\n  "; Format text bold Files; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_FIL_LONG[@]}; else count1=0; fi
                    printf "   Declared:               % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                options)
                    printf "\n  "; Format text bold Options; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_OPT_LONG[@]}; else count1=0; fi
                    printf "   Declared:                % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                            if [[ "${FW_ELEMENT_OPT_CAT[${id}]}" == "Exit+Options" ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_ELEMENT_OPT_CAT[${id}]}" == "Runtime+Options" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - as exit option:        % 4s        - as runtime option:     % 4s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_OPT_LS[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -z "${FW_ELEMENT_OPT_LS[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - with short & long:     % 4s        - with long:             % 4s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_OPT_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_OPT_ARG[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                        done
                        printf "   - with argument:         % 4s\n"      "${count1}"
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                parameters)
                    printf "\n  "; Format text bold Parameters; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_PAR_LONG[@]}; else count1=0; fi
                    printf "   Declared:                % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                projects)
                    printf "\n  "; Format text bold Projects; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_PRJ_LONG[@]}; else count1=0; fi
                    printf "   Declared:                % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                scenarios)
                    printf "\n  "; Format text bold Scenarios; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_SCN_LONG[@]}; else count1=0; fi
                    printf "   Declared:                % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            if [[ "${FW_ELEMENT_SCN_STATUS[${id}]}" != "N" ]]; then count1=$((count1 + 1)); fi
                        done
                        printf "   - tested:                % 4s\n"      "${count1}"

                        __skb_internal_stats_fullrule
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            case ${FW_ELEMENT_SCN_MODES[${id}]} in
                                all)    count1=$((count1 + 1)) ;;
                                build)  count2=$((count2 + 1)) ;;
                            esac
                        done
                        printf "   - for mode all:           % 4s        - for mode build:         % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            case ${FW_ELEMENT_SCN_MODES[${id}]} in
                                dev)    count1=$((count1 + 1)) ;;
                                use)    count2=$((count2 + 1)) ;;
                            esac
                        done
                        printf "   - for mode dev:           % 4s        - for mode use:           % 4s\n"      "${count1}"     "${count2}"

                        __skb_internal_stats_fullrule
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_APP[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require application:    % 4s        - require task:           % 4s\n"      "${count1}"     "${count2}"

                        __skb_internal_stats_fullrule
                        statSource=" "; count1=0
                        for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                            case ${statSource} in
                                *" ${FW_ELEMENT_SCN_DECMDS[${id}]} "*) ;;
                                *) statSource+="${FW_ELEMENT_SCN_DECMDS[${id}]} "; count1=$((count1 + 1)) ;;
                            esac
                        done
                        printf "   From origins:             % 4s\n" "${count1}"
                        for statId in ${statSource}; do
                            count1=0
                            for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                                case ${FW_ELEMENT_SCN_DECMDS[${id}]} in
                                    ${statId}) count1=$((count1 + 1)) ;;
                                esac
                            done
                            printf "   - %s:" "${statId}"
                            Repeat print character $(( 23 - ${#statId} )) " "
                            printf "% 4s\n" "${count1}"
                        done
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                sites)
                    printf "\n  "; Format text bold Sites; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_SIT_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_SIT_LONG[@]}; else count1=0; fi
                    printf "   Declared:                % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        :
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                tasks)
                    printf "\n  "; Format text bold Tasks; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_TSK_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ "${FW_ELEMENT_TSK_STATUS[${id}]}" != "N" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUESTED[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - tested:                 % 4s        - requested:              % 4s\n"      "${count1}"     "${count2}"

                        __skb_internal_stats_fullrule
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            case ${FW_ELEMENT_TSK_MODES[${id}]} in
                                all)    count1=$((count1 + 1)) ;;
                                build)  count2=$((count2 + 1)) ;;
                            esac
                        done
                        printf "   - for mode all:           % 4s        - for mode build:         % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            case ${FW_ELEMENT_TSK_MODES[${id}]} in
                                dev)    count1=$((count1 + 1)) ;;
                                use)    count2=$((count2 + 1)) ;;
                            esac
                        done
                        printf "   - for mode dev:           % 4s        - for mode use:           % 4s\n"      "${count1}"     "${count2}"

                        __skb_internal_stats_fullrule
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_APP[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require application:    % 4s        - require dependency:     % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require parameter:      % 4s        - require task:           % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FIL[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FLS[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require file:           % 4s        - require file list:      % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]:-}" ]]; then count1=$((count1 + 1)); fi
                            if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DLS[${id}]:-}" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - require directory:      % 4s        - require directory list: % 4s\n"      "${count1}"     "${count2}"

                        __skb_internal_stats_fullrule
                        statSource=" "; count1=0
                        for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                            case ${statSource} in
                                *" ${FW_ELEMENT_TSK_DECMDS[${id}]} "*) ;;
                                *) statSource+="${FW_ELEMENT_TSK_DECMDS[${id}]} "; count1=$((count1 + 1)) ;;
                            esac
                        done
                        printf "   From origins:             % 4s\n" "${count1}"
                        for statId in ${statSource}; do
                            count1=0
                            for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                                case ${FW_ELEMENT_TSK_DECMDS[${id}]} in
                                    ${statId}) count1=$((count1 + 1)) ;;
                                esac
                            done
                            printf "   - %s:" "${statId}"
                            Repeat print character $(( 23 - ${#statId} )) " "
                            printf "% 4s\n" "${count1}"
                        done
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                messages)
                    printf "\n  "; Format text bold Messages; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_OBJECT_MSG_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_MSG_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "error" ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "warning" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - type error:             % 4s        - type warning:           % 4s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "message" ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "info" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - type message:           % 4s        - type info:              % 4s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "debug" ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_TYPE[${id}]}" == "trace" ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - type debug:             % 4s        - type trace:             % 4s\n"      "${count1}"     "${count2}"

                        __skb_internal_stats_fullrule
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 0 ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 1 ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - with 0 argument:        % 4s        - with 1 argumennt:       % 4s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 2 ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 3 ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - with 2 arguments:       % 4s        - with 3 arguments:       % 4s\n"      "${count1}"     "${count2}"

                        count1=0; count2=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 4 ]]; then count1=$((count1 + 1)); fi
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" == 5 ]]; then count2=$((count2 + 1)); fi
                        done
                        printf "   - with 4 arguments:       % 4s        - with 5 arguments:       % 4s\n"      "${count1}"     "${count2}"

                        count1=0
                        for id in ${!FW_OBJECT_MSG_LONG[@]}; do
                            if [[ "${FW_OBJECT_MSG_ARGS[${id}]}" > 5 ]]; then count1=$((count1 + 1)); fi
                        done
                        printf "   - more than 5 arguments:  % 4s\n"      "${count1}"
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                phases)
                    printf "\n  "; Format text bold Phases; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_OBJECT_PHA_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_PHA_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            count1=$((count1 + ${FW_OBJECT_PHA_WRNCNT[${id}]}))
                            count2=$((count2 + ${FW_OBJECT_PHA_ERRCNT[${id}]}))
                        done
                        printf "   - with warnings:          % 4s        - with errors:            % 4s\n"      "${count1}"     "${count2}"

                        __skb_internal_stats_fullrule
                        printf "   by print level\n"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" fatalerror "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" error "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level fatalerror:   % 4s        - for level error:        % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" text "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" message "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level text:         % 4s        - for level message:      % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" warning "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" info "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level warning:      % 4s        - for level info:         % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" debug "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" trace "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level debug:        % 4s        - for level trace:        % 4s\n"      "${count1}"     "${count2}"

                        __skb_internal_stats_fullrule
                        printf "   by log level\n"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" fatalerror "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" error "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level fatalerror:   % 4s        - for level error:        % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" text "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" message "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level text:         % 4s        - for level message:      % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" warning "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" info "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level warning:      % 4s        - for level info:         % 4s\n"      "${count1}"     "${count2}"
                        count1=0; count2=0
                        for id in ${!FW_OBJECT_PHA_LONG[@]}; do
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" debug "*) count1=$((count1 + 1)) ;; esac
                            case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" trace "*) count2=$((count2 + 1)) ;; esac
                        done
                        printf "   - for level debug:        % 4s        - for level trace:        % 4s\n"      "${count1}"     "${count2}"
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                settings)
                    printf "\n  "; Format text bold Settings; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_OBJECT_SET_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_SET_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        statSource=" "; count1=0
                        for id in ${!FW_OBJECT_SET_LONG[@]}; do
                            case ${statSource} in
                                *" ${FW_OBJECT_SET_PHASET[${id}]} "*) ;;
                                *) statSource+="${FW_OBJECT_SET_PHASET[${id}]} "; count1=$((count1 + 1)) ;;
                            esac
                        done
                        printf "   - from sources:           % 4s\n" "${count1}"

                        __skb_internal_stats_fullrule
                        printf "   by source:\n"
                        for statId in ${statSource}; do
                            count1=0
                            for id in ${!FW_OBJECT_SET_LONG[@]}; do
                                case ${FW_OBJECT_SET_PHASET[${id}]} in
                                    ${statId}) count1=$((count1 + 1)) ;;
                                esac
                            done
                            printf "   - %s:" "${statId}"
                            Repeat print character $(( 23 - ${#statId} )) " "
                            printf "% 4s\n" "${count1}"
                        done
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                themeitems)
                    printf "\n  "; Format text bold "Theme Items"; printf "\n"
                    __skb_internal_stats_fullrule
                    if [[ "${FW_OBJECT_TIM_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_TIM_LONG[@]}; else count1=0; fi
                    printf "   Declared:                 % 4s\n" "${count1}"
                    if (( count1 > 0 )); then
                        statSource=" "; count1=0
                        for id in ${!FW_OBJECT_TIM_LONG[@]}; do
                            case ${statSource} in
                                *" ${FW_OBJECT_TIM_SOURCE[${id}]} "*) ;;
                                *) statSource+="${FW_OBJECT_TIM_SOURCE[${id}]} "; count1=$((count1 + 1)) ;;
                            esac
                        done
                        printf "   - from sources:           % 4s\n" "${count1}"

                        __skb_internal_stats_fullrule
                        printf "   by source:\n"
                        for statId in ${statSource}; do
                            count1=0
                            for id in ${!FW_OBJECT_TIM_LONG[@]}; do
                                case ${FW_OBJECT_TIM_SOURCE[${id}]} in
                                    ${statId}) count1=$((count1 + 1)) ;;
                                esac
                            done
                            printf "   - %s:" "${statId}"
                            Repeat print character $(( 23 - ${#statId} )) " "
                            printf "% 4s\n" "${count1}"
                        done
                    fi
                    __skb_internal_stats_fullrule
                    printf "\n" ;;

                *)
                    Report process error "${FUNCNAME[0]}" "${cmdString1} for" E803 "${stats}"; return
            esac ;;

        cache | log | fast | load | medium | slow | \
        project | scenario | script | site | task)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                cache-file)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    file="${FW_OBJECT_CFG_VAL["CACHE_DIR"]}"/${1}.cache
                    Test file can read "${file}" "${1}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    if [[ -r "${file}" ]]; then  tput smcup; less -C -f -M -d ${file}; tput rmcup; fi ;;

                log-file)
                    file="${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}"
                    if [[ -r "${file}" ]]; then  tput smcup; less -r -C -f -M -d ${file}; tput rmcup; fi ;;

                fast-runtime | load-runtime | medium-runtime | slow-runtime)
                    case ${cmd1} in
                        fast)                   file="${FW_RUNTIME_CONFIG_FAST}" ;;
                        load | medium | slow)   file="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_${cmd1^^}"]}" ;;
                    esac
                    if [[ -r "${file}" ]]; then tput smcup; less -C -f -M -d ${file}; tput rmcup; fi ;;

                project-execution | scenario-execution | script-execution | site-execution | task-execution)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        project-execution-start | scenario-execution-start | script-execution-start | site-execution-start | task-execution-start)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; width=$(tput cols)

                            printf "\n"
                            case ${cmd1} in
                                project)    Format ansi start "${FW_OBJECT_TIM_VAL["execPrjBgrndFmt"]}" ;;
                                scenario)   Format ansi start "${FW_OBJECT_TIM_VAL["execScnBgrndFmt"]}" ;;
                                script)     Format ansi start "${FW_OBJECT_TIM_VAL["execScrBgrndFmt"]}" ;;
                                site)       Format ansi start "${FW_OBJECT_TIM_VAL["execSitBgrndFmt"]}" ;;
                                task)       Format ansi start "${FW_OBJECT_TIM_VAL["execTskBgrndFmt"]}" ;;
                            esac
                            Format execution line ${width} execLine; printf "\n"
                            Format themed text execStartNameFmt "  ${id} "
                            timeStamp=$(date +"%T")
                            Format themed text execStartTimeFmt " ${timeStamp} "
                            Format themed text execStartTextFmt " executing ${cmd1}"
                            lineLength=$(( 7 + ${#id} + ${#timeStamp} + 9 + ${#cmd1} ))

                            Repeat print formatted character $(( width - lineLength )) " " execStartTextFmt
                            printf "\n"
                            Format execution line ${width} execStartRule; Format ansi end
                            printf "\n\n" ;;

                        project-execution-end | scenario-execution-end | script-execution-end | site-execution-end | task-execution-end)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 3 "$#"; return; fi
                            id="${1}"; width=$(tput cols)
                            tsStart="${2}"; tsEnd="${3}"

                            timeStamp=$(date +"%T")
                            runtime="$(Calculate runtime ${tsStart} ${tsEnd})"
                            printf "\n\n"
                            case ${cmd1} in
                                project)    Format ansi start "${FW_OBJECT_TIM_VAL["execPrjBgrndFmt"]}" ;;
                                scenario)   Format ansi start "${FW_OBJECT_TIM_VAL["execScnBgrndFmt"]}" ;;
                                script)     Format ansi start "${FW_OBJECT_TIM_VAL["execScrBgrndFmt"]}" ;;
                                site)       Format ansi start "${FW_OBJECT_TIM_VAL["execSitBgrndFmt"]}" ;;
                                task)       Format ansi start "${FW_OBJECT_TIM_VAL["execTskBgrndFmt"]}" ;;
                            esac
                            Format execution line ${width} execEndRule; printf "\n"
                            Format themed text execEndDoneFmt "  done (${cmd1}): ${id}";        lineLength=$(( 11 + ${#cmd1} + ${#id} ))
                            Format themed text execEndTimeFmt "  ${timeStamp} (${runtime}) ";   lineLength=$(( lineLength + 6 + ${#timeStamp} + ${#runtime} ))
                            Format themed text execEndStatusFmt " -  status: ";                 lineLength=$(( lineLength + 12 ))
                            if [[ "${FW_OBJECT_PHA_ERRCNT[${cmd1^}]}" > 0 ]]; then
                                Format themed text execEndErrorFmt "error "
                                case ${FW_OBJECT_PHA_ERRCNT[${cmd1^}]} in
                                    1)  Format themed text execEndStatusFmt "(${FW_OBJECT_PHA_ERRCNT[${cmd1^}]} error)";    lineLength=$(( lineLength + 14 + ${#FW_OBJECT_PHA_ERRCNT[${cmd1^}]} )) ;;
                                    *)  Format themed text execEndStatusFmt "(${FW_OBJECT_PHA_ERRCNT[${cmd1^}]} errors)";   lineLength=$(( lineLength + 15 + ${#FW_OBJECT_PHA_ERRCNT[${cmd1^}]} )) ;;
                                esac
                            elif [[ "${FW_OBJECT_PHA_WRNCNT[${cmd1^}]}" > 0 ]]; then
                                Format themed text execEndWarningFmt "warning "
                                case ${FW_OBJECT_PHA_WRNCNT[${cmd1^}]} in
                                    1)  Format themed text execEndStatusFmt "(${FW_OBJECT_PHA_WRNCNT[${cmd1^}]} warning)";  lineLength=$(( lineLength + 18 + ${#FW_OBJECT_PHA_WRNCNT[${cmd1^}]} )) ;;
                                    *)  Format themed text execEndStatusFmt "(${FW_OBJECT_PHA_WRNCNT[${cmd1^}]} warnings)"; lineLength=$(( lineLength + 19 + ${#FW_OBJECT_PHA_WRNCNT[${cmd1^}]} )) ;;
                                esac
                            else
                                Format themed text execEndSuccessFmt "success "; lineLength=$(( lineLength + 8 ))
                            fi

                            Repeat print formatted character $(( width - lineLength )) " " execEndDoneFmt
                            printf "\n"
                            Format execution line ${width} execLine; Format ansi end; printf "\n" ;;

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
