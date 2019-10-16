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
## internal / statistics - internal functions called by the API, printing statistics
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_internal_stats_fullrule () {
    printf "  "
    Repeat print formatted character 68 "${FW_OBJECT_TIM_VAL["statsFullruleChar"]}" statsFullruleFmt
    printf "\n"
}


function __skb_internal_stats_halfrule () {
    printf "  "
    Repeat print formatted character 31 "${FW_OBJECT_TIM_VAL["statsHalfruleChar"]}" statsHalfruleFmt
    printf "      "
    Repeat print formatted character 31 "${FW_OBJECT_TIM_VAL["statsHalfruleChar"]}" statsHalfruleFmt
    printf "\n"
}


function __skb_internal_stats_overview () {
    local count1 count2

    printf "\n  "; Format text bold Statistics; printf "\n"

    __skb_internal_stats_fullrule
        count1=0; for name in ${SF_HOME}/lib/components/*/*.sh; do count1=$(( count1 + 1 )); done
        count2=${#SF_OPERATIONS[*]}
        printf "   Components:              % 4s        Operations:              % 4s\n"      "${count1}"     "${count2}"

    __skb_internal_stats_halfrule
        count1=0; for name in ${SF_HOME}/lib/components/elements/*.sh; do count1=$(( count1 + 1 )); done
        count2=0; for name in ${SF_HOME}/lib/components/objects/*.sh; do count2=$(( count2 + 1 )); done
                        printf "   Elements:                % 4s        Objects:                 % 4s\n"      "${count1}"     "${count2}"

        count1=0; for name in ${SF_HOME}/lib/components/instances/*.sh; do count1=$(( count1 + 1 )); done
        count2=0; for name in ${SF_HOME}/lib/components/actions/*.sh; do count2=$(( count2 + 1 )); done
        printf "   Instances:               % 4s        Actions:                 % 4s\n"      "${count1}"     "${count2}"

    __skb_internal_stats_halfrule
        if [[ "${FW_OBJECT_CFG_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_CFG_LONG[@]}; else count1=0; fi
        if [[ "${FW_OBJECT_FMT_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_FMT_LONG[@]}; else count2=0; fi
        printf "   Configurations:          % 4s        Formats:                 % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_OBJECT_LVL_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_LVL_LONG[@]}; else count1=0; fi
        if [[ "${FW_OBJECT_MSG_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_MSG_LONG[@]}; else count2=0; fi
        printf "   Levels:                  % 4s        Kessages:                % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_OBJECT_MOD_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_MOD_LONG[@]}; else count1=0; fi
        if [[ "${FW_OBJECT_PHA_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_PHA_LONG[@]}; else count2=0; fi
        printf "   Modes:                   % 4s        Phases:                  % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_OBJECT_SET_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_SET_LONG[@]}; else count1=0; fi
        if [[ "${FW_OBJECT_TIM_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_TIM_LONG[@]}; else count2=0; fi
        printf "   Settings:                % 4s        Theme items:             % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_OBJECT_THM_LONG[*]}" != "" ]]; then count1=${#FW_OBJECT_THM_LONG[@]}; else count1=0; fi
        if [[ "${FW_OBJECT_VAL_LONG[*]}" != "" ]]; then count2=${#FW_OBJECT_VAL_LONG[@]}; else count2=0; fi
        printf "   Themes:                  % 4s        Variables:               % 4s\n"      "${count1}"     "${count2}"

    __skb_internal_stats_halfrule
        if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_APP_LONG[@]}; else count1=0; fi
        if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_DEP_LONG[@]}; else count2=0; fi
        printf "   Applications:            % 4s        Dependencies:            % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_DIR_LONG[@]}; else count1=0; fi
        if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_DLS_LONG[@]}; else count2=0; fi
        printf "   Directoriess:            % 4s        Directory Lists:         % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_FIL_LONG[@]}; else count1=0; fi
        if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_FLS_LONG[@]}; else count2=0; fi
        printf "   Files:                   % 4s        File Lists:              % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_MDS_LONG[@]}; else count1=0; fi
        if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_OPT_LONG[@]}; else count2=0; fi
        printf "   Modules:                 % 4s        Options:                 % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_PRJ_LONG[@]}; else count1=0; fi
        if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_PAR_LONG[@]}; else count2=0; fi
        printf "   Projects:                % 4s        Parameters:              % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_SCN_LONG[@]}; else count1=0; fi
        if [[ "${FW_ELEMENT_SCR_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_SCR_LONG[@]}; else count2=0; fi
        printf "   Scenarios:               % 4s        Scripts:                 % 4s\n"      "${count1}"     "${count2}"

        if [[ "${FW_ELEMENT_SIT_LONG[*]}" != "" ]]; then count1=${#FW_ELEMENT_SIT_LONG[@]}; else count1=0; fi
        if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then count2=${#FW_ELEMENT_TSK_LONG[@]}; else count2=0; fi
        printf "   Sites:                   % 4s        Tasks:                   % 4s\n"      "${count1}"     "${count2}"

    __skb_internal_stats_fullrule
    printf "\n"
}


function __skb_internal_stats_time () {
    printf "\n  "; Format text bold Time; printf "\n"
    __skb_internal_stats_fullrule
        timeStamp="$(date --date=@$(Get start time) +"%c")"
        printf "   Started on:     %s\n"      "${timeStamp}"
        printf "   Running for:    %s\n"      "$(Calculate runtime $(Get start time) $(date +%s.%N))"
    __skb_internal_stats_fullrule
    printf "\n"
}

