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
## list-tasks - task that lists tasks
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Clioptions add option table; Clioptions add option show-values; Clioptions add option with-legend; Clioptions add option without-status; Clioptions add option without-extras

Clioptions add option filter-mode      tasks
Clioptions add option filter-origin    tasks
Clioptions add option filter-requested tasks
Clioptions add option filter-status    tasks
Clioptions add option filter-tested    tasks
Clioptions add option filter-not-core  tasks

Clioptions add option task-none-all
Clioptions add option task-none-build
Clioptions add option task-none-debug
Clioptions add option task-none-describe
Clioptions add option task-none-list
Clioptions add option task-none-dl
Clioptions add option task-none-dll

Clioptions add option task-only-build
Clioptions add option task-only-debug
Clioptions add option task-only-describe
Clioptions add option task-only-list

Parse cli "Options Table+Options Filters Name+Filters,+none Name+Filters,+only" $*


############################################################################################
##
## test CLI
##
############################################################################################
mode=""
origin=""
requested=""
status=""
tested=""

if [[ "${FW_INSTANCE_CLI_SET["mode"]}" == "yes" ]]; then
    Test current mode "${FW_INSTANCE_CLI_VAL["mode"]}"
    mode="${FW_INSTANCE_CLI_VAL["mode"]}"
fi
if [[ "${FW_INSTANCE_CLI_SET["origin"]}" == "yes" ]]; then
    Test existing module id "${FW_INSTANCE_CLI_VAL["origin"]}"
    origin="${FW_INSTANCE_CLI_VAL["origin"]}"
fi
if [[ "${FW_INSTANCE_CLI_SET["requested"]}" == "yes" ]]; then
    Test yesno "${FW_INSTANCE_CLI_VAL["requested"]}" requested
    requested="${FW_INSTANCE_CLI_VAL["requested"]}"
    requested=${requested:0:1}
    requested=${requested,}
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


none_build=no
none_debug=no
none_describe=no
none_list=no

if [[ "${FW_INSTANCE_CLI_SET["none-all"]}" == "yes" ]]; then
    none_build=yes; none_debug=yes; none_describe=yes; none_list=yes
else
    if [[ "${FW_INSTANCE_CLI_SET["none-build"]}" == "yes" ]]; then none_build=yes; fi
    if [[ "${FW_INSTANCE_CLI_SET["none-debug"]}" == "yes" ]]; then none_debug=yes; fi
    if [[ "${FW_INSTANCE_CLI_SET["none-describe"]}" == "yes" ]]; then none_describe=yes; fi
    if [[ "${FW_INSTANCE_CLI_SET["none-list"]}" == "yes" ]]; then none_list=yes; fi
    if [[ "${FW_INSTANCE_CLI_SET["none-dl"]}" == "yes" ]]; then none_describe=yes; none_list=yes; fi
    if [[ "${FW_INSTANCE_CLI_SET["none-ddl"]}" == "yes" ]]; then none_debug=yes; none_describe=yes; none_list=yes; fi
fi


only_build=no
only_debug=no
only_describe=no
only_list=no

if [[ "${FW_INSTANCE_CLI_SET["only-build"]}" == "yes" ]]; then only_build=yes; fi
if [[ "${FW_INSTANCE_CLI_SET["only-debug"]}" == "yes" ]]; then only_debug=yes; fi
if [[ "${FW_INSTANCE_CLI_SET["only-describe"]}" == "yes" ]]; then only_describe=yes; fi
if [[ "${FW_INSTANCE_CLI_SET["only-list"]}" == "yes" ]]; then only_list=yes; fi


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
## filter tasks
##
############################################################################################
arr="$(Tasks has)"
remove=""

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



############################################################################################
##
## print tasks as list or table
##
############################################################################################
if [[ "${FW_INSTANCE_CLI_SET["table"]}" == "no" ]]; then
    printf "\n  "
    Format themed text listHeadFmt Tasks
    printf "\n"
    Print task list "$arr" ${showValues}
else
    Print task table "${arr}" ${showValues} ${withLegend} ${withoutStatus} ${withoutExtras}
fi

exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}
