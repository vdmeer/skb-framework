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
## list-scenarios - task that lists scenarios
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME:-}" ]]; then printf " $(basename $0): please run from skb-framework\n\n"; exit 10; fi
source ${SF_HOME}/lib/task-runtime.sh

Clioptions add option table; Clioptions add option show-values; Clioptions add option with-legend; Clioptions add option without-status; Clioptions add option without-extras

Clioptions add option filter-mode      scenarios
Clioptions add option filter-origin    scenarios
Clioptions add option filter-status    scenarios
Clioptions add option filter-tested    scenarios
Clioptions add option filter-not-core  scenarios

Parse cli "Options Table+Options Filters" $*


############################################################################################
##
## test CLI
##
############################################################################################
mode=""
origin=""
status=""
tested=""

if [[ "${FW_INSTANCE_CLI_SET["mode"]}" == "yes" ]]; then
    Test existing mode id "${FW_INSTANCE_CLI_VAL["mode"]}"
    mode="${FW_INSTANCE_CLI_VAL["mode"]}"
fi
if [[ "${FW_INSTANCE_CLI_SET["origin"]}" == "yes" ]]; then
    Test existing module id "${FW_INSTANCE_CLI_VAL["origin"]}"
    origin="${FW_INSTANCE_CLI_VAL["origin"]}"
fi
if [[ "${FW_INSTANCE_CLI_SET["status"]}" == "yes" ]]; then
    Test element status "${FW_INSTANCE_CLI_VAL["status"]}"
    status="$(Get status char "${FW_INSTANCE_CLI_VAL["status"]}")"
fi
if [[ "${FW_INSTANCE_CLI_SET["tested"]}" == "yes" ]]; then
    Test yesno "${FW_INSTANCE_CLI_VAL["tested"]}" tested
    tested="${FW_INSTANCE_CLI_VAL["tested"]}"
    tested=${tested:0:1}
    tested=${tested,}
fi


not_core=no
if [[ "${FW_INSTANCE_CLI_SET["not-core"]}" == "yes" ]]; then not_core=yes; fi


showValues=""
if [[ "${FW_INSTANCE_CLI_SET["show-values"]}" == "yes" ]]; then showValues="show-values"; fi

withLegend=""
if [[ "${FW_INSTANCE_CLI_SET["with-legend"]}" == "yes" ]]; then withLegend="with-legend"; fi

withoutStatus=""
if [[ "${FW_INSTANCE_CLI_SET["without-status"]}" == "yes" ]]; then withoutStatus="without-status"; fi

withoutExtras=""
if [[ "${FW_INSTANCE_CLI_SET["without-extras"]}" == "yes" ]]; then withoutExtras="without-extras"; fi



############################################################################################
##
## filter scenarios
##
############################################################################################
arr="$(Scenarios has)"
remove=""

for id in $arr; do
    if [[ -n "${mode}" ]]; then
        if [[ "${mode}" == "test" ]]; then
            : # always available in test mode
        else
            case ${FW_ELEMENT_TSK_MODES[${id}]} in
                all | ${mode})  ;;
                *)              remove+=" "$id ;;
            esac
        fi
    fi
    if [[ -n "${origin}" ]]; then
        if [[ "${origin}" != "${FW_ELEMENT_SCN_DECMDS[${id}]}" ]]; then
            remove+=" "$id
        fi
    fi
    if [[ -n "${status}" ]]; then
        if [[ "${status}" != "${FW_ELEMENT_SCN_STATUS[${id}]}" ]]; then
            remove+=" "$id
        fi
    fi
    if [[ -n "${tested}" ]]; then
        case "${tested}" in
            y)  if [[ "${FW_ELEMENT_SCN_STATUS[${id}]}" == "N" ]]; then remove+=" "$id; fi ;;
            n)  if [[ "${FW_ELEMENT_SCN_STATUS[${id}]}" != "N" ]]; then remove+=" "$id; fi ;;
        esac
    fi
    if [[ "${not_core}" == yes ]];      then if [[ "Core" == "${FW_ELEMENT_SCN_DECMDS[${id}]}" ]]; then remove+=" "$id; fi; fi
done

for id in $remove; do
    arr=${arr/${id}/}
done



############################################################################################
##
## print scenarios as list or table
##
############################################################################################
if [[ "${FW_INSTANCE_CLI_SET["table"]}" == "no" ]]; then
    printf "\n  "
    Format themed text listHeadFmt Scenarios
    printf "\n"
    Print scenario list "$arr" ${showValues}
else
    Print scenario table "${arr}" ${showValues} ${withLegend} ${withoutStatus} ${withoutExtras}
fi
