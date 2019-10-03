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
## debug-tasks - task that debugs tasks
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option filter-id        debug task
Cli add option filter-mode      tasks
Cli add option filter-origin    tasks
Cli add option filter-requested tasks
Cli add option filter-status    tasks
Cli add option filter-tested    tasks
Cli add option filter-not-core  tasks

Cli add option task-none-all
Cli add option task-none-build
Cli add option task-none-debug
Cli add option task-none-describe
Cli add option task-none-list
Cli add option task-none-dl
Cli add option task-none-dll

Cli add option task-only-build
Cli add option task-only-debug
Cli add option task-only-describe
Cli add option task-only-list

Parse cli arguments "Options Filters Name+Filters,+none Name+Filters,+only" $*


############################################################################################
##
## test CLI
##
############################################################################################
name=""
mode=""
origin=""
requested=""
status=""
tested=""

if [[ "${FW_PARSED_ARG_MAP[i]:-${FW_PARSED_ARG_MAP[id]:-no}}" == yes ]]; then
    Test existing task id "${FW_PARSED_VAL_MAP[i]:-${FW_PARSED_VAL_MAP[id]}}"
    name="${FW_PARSED_VAL_MAP[i]:-${FW_PARSED_VAL_MAP[id]}}"
fi
if [[ "${FW_PARSED_ARG_MAP[m]:-${FW_PARSED_ARG_MAP[mode]:-no}}" == yes ]]; then
    Test current mode "${FW_PARSED_VAL_MAP[m]:-${FW_PARSED_VAL_MAP[mode]}}"
    mode="${FW_PARSED_VAL_MAP[m]:-${FW_PARSED_VAL_MAP[mode]}}"
fi
if [[ "${FW_PARSED_ARG_MAP[o]:-${FW_PARSED_ARG_MAP[origin]:-no}}" == yes ]]; then
    Test existing module id "${FW_PARSED_VAL_MAP[o]:-${FW_PARSED_VAL_MAP[origin]}}"
    origin="$(Get module id "${FW_PARSED_VAL_MAP[o]:-${FW_PARSED_VAL_MAP[origin]}}")"
fi
if [[ "${FW_PARSED_ARG_MAP[r]:-${FW_PARSED_ARG_MAP[requested]:-no}}" == yes ]]; then
    Test yesno "${FW_PARSED_VAL_MAP[r]:-${FW_PARSED_VAL_MAP[requested]}}" requested
    requested="${FW_PARSED_VAL_MAP[r]:-${FW_PARSED_VAL_MAP[requested]}}"
    requested=${requested:0:1}
    requested=${requested,}
fi
if [[ "${FW_PARSED_ARG_MAP[s]:-${FW_PARSED_ARG_MAP[status]:-no}}" == yes ]]; then
    Test element status "${FW_PARSED_VAL_MAP[s]:-${FW_PARSED_VAL_MAP[status]}}"
    status="$(Get status char "${FW_PARSED_VAL_MAP[s]:-${FW_PARSED_VAL_MAP[status]}}")"
fi
if [[ "${FW_PARSED_ARG_MAP[t]:-${FW_PARSED_ARG_MAP[tested]:-no}}" == yes ]]; then
    Test yesno "${FW_PARSED_VAL_MAP[t]:-${FW_PARSED_VAL_MAP[tested]}}" tested
    tested="${FW_PARSED_VAL_MAP[t]:-${FW_PARSED_VAL_MAP[tested]}}"
    tested=${tested:0:1}
    tested=${tested,}
fi


not_core=no
if [[ "${FW_PARSED_ARG_MAP[n]:-${FW_PARSED_ARG_MAP[not-core]:-no}}" == yes ]]; then not_core=yes; fi


none_build=no
none_debug=no
none_describe=no
none_list=no

if [[ "${FW_PARSED_ARG_MAP[N]:-${FW_PARSED_ARG_MAP[none-all]:-no}}" == yes ]]; then
    none_build=yes; none_debug=yes; none_describe=yes; none_list=yes
else
    if [[ "${FW_PARSED_ARG_MAP[b]:-${FW_PARSED_ARG_MAP[none-build]:-no}}" == yes ]]; then none_build=yes; fi
    if [[ "${FW_PARSED_ARG_MAP[none-debug]:-no}" == yes ]]; then none_debug=yes; fi
    if [[ "${FW_PARSED_ARG_MAP[d]:-${FW_PARSED_ARG_MAP[none-describe]:-no}}" == yes ]]; then none_describe=yes; fi
    if [[ "${FW_PARSED_ARG_MAP[l]:-${FW_PARSED_ARG_MAP[none-list]:-no}}" == yes ]]; then none_list=yes; fi
    if [[ "${FW_PARSED_ARG_MAP[none-dl]:-no}" == yes ]]; then none_describe=yes; none_list=yes; fi
    if [[ "${FW_PARSED_ARG_MAP[none-ddl]:-no}" == yes ]]; then none_debug=yes; none_describe=yes; none_list=yes; fi
fi


only_build=no
only_debug=no
only_describe=no
only_list=no

if [[ "${FW_PARSED_ARG_MAP[B]:-${FW_PARSED_ARG_MAP[only-build]:-no}}" == yes ]]; then only_build=yes; fi
if [[ "${FW_PARSED_ARG_MAP[only-debug]:-no}" == yes ]]; then only_debug=yes; fi
if [[ "${FW_PARSED_ARG_MAP[only-describe]:-no}" == yes ]]; then only_describe=yes; fi
if [[ "${FW_PARSED_ARG_MAP[L]:-${FW_PARSED_ARG_MAP[only-list]:-no}}" == yes ]]; then only_list=yes; fi




############################################################################################
##
## filter tasks
##
############################################################################################
arr="$(Tasks has)"
remove=""

if [[ -n "${name}" ]]; then
    arr="${name}"
else
    for id in $arr; do
        if [[ -n "${mode}" ]]; then
            case ${FW_ELEMENT_TSK_MODES[${id}]} in
                all | ${mode})  ;;
                *)              remove+=" "$id ;;
            esac
        fi
        if [[ -n "${origin}" ]]; then
            if [[ "${origin}" != "${FW_ELEMENT_TSK_ORIG[${id}]}" ]]; then
                remove+=" "$id
            fi
        fi
        if [[ -n "${requested}" ]]; then
            case "${requested}" in
                y)  if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED[${id}]:-}" ]]; then remove+=" "$id; fi ;;
                n)  if [[   -n "${FW_ELEMENT_TSK_REQUESTED[${id}]:-}" ]]; then remove+=" "$id; fi ;;
            esac
        fi
        if [[ -n "${status}" ]]; then
            if [[ "${status}" != "${FW_ELEMENT_TSK_STATUS[${id}]}" ]]; then
                remove+=" "$id
            fi
        fi
        if [[ -n "${tested}" ]]; then
            case "${tested}" in
                y)  if [[ "${FW_ELEMENT_TSK_STATUS[${id}]}" == "N" ]]; then remove+=" "$id; fi ;;
                n)  if [[ "${FW_ELEMENT_TSK_STATUS[${id}]}" != "N" ]]; then remove+=" "$id; fi ;;
            esac
        fi

        if [[ "${not_core}" == yes ]];      then if [[ "Core" == "${FW_ELEMENT_TSK_ORIG[${id}]}" ]]; then remove+=" "$id; fi; fi

        if [[ "${none_build}" == yes ]];    then case "${id}" in "build-"*)    remove+=" "$id ;; esac; fi
        if [[ "${none_debug}" == yes ]];    then case "${id}" in "debug-"*)    remove+=" "$id ;; esac; fi
        if [[ "${none_describe}" == yes ]]; then case "${id}" in "describe-"*) remove+=" "$id ;; esac; fi
        if [[ "${none_list}" == yes ]];     then case "${id}" in "list-"*)     remove+=" "$id ;; esac; fi

        if [[ "${only_build}" == yes ]];    then case "${id}" in "build-"*)    ;; *) remove+=" "$id ;; esac; fi
        if [[ "${only_debug}" == yes ]];    then case "${id}" in "debug-"*)    ;; *) remove+=" "$id ;; esac; fi
        if [[ "${only_describe}" == yes ]]; then case "${id}" in "describe-"*) ;; *) remove+=" "$id ;; esac; fi
        if [[ "${only_list}" == yes ]];     then case "${id}" in "list-"*)     ;; *) remove+=" "$id ;; esac; fi
    done
    for id in $remove; do
        arr=${arr/${id}/}
    done
fi



############################################################################################
##
## print task descriptions
##
############################################################################################
IFS=" " read -a keys <<< "${arr}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
for id in "${keys[@]}"; do
    Debug task ${id}
    printf "\n"
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}; fi
done
