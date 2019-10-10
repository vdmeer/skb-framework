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
## list-files - task that lists files
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME:-}" ]]; then printf " $(basename $0): please run from skb-framework\n\n"; exit 10; fi
source ${SF_HOME}/lib/task-runtime.sh

Clioptions add option table; Clioptions add option show-values; Clioptions add option with-legend; Clioptions add option without-status; Clioptions add option without-extras

Clioptions add option filter-origin    files
Clioptions add option filter-requested files
Clioptions add option filter-status    files
Clioptions add option filter-tested    files
Clioptions add option filter-not-core  files

Parse cli "Options Table+Options Filters" $*


############################################################################################
##
## test CLI
##
############################################################################################
origin=""
requested=""
status=""
tested=""

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
## filter files
##
############################################################################################
arr="$(Files has)"
remove=""

for id in $arr; do
    if [[ -n "${origin}" ]]; then
        if [[ "${origin}" != "${FW_ELEMENT_FIL_ORIG[${id}]}" ]]; then
            remove+=" "$id
        fi
    fi
    if [[ -n "${requested}" ]]; then
        case "${requested}" in
            y)  if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED[${id}]:-}" ]]; then remove+=" "$id; fi ;;
            n)  if [[   -n "${FW_ELEMENT_FIL_REQUESTED[${id}]:-}" ]]; then remove+=" "$id; fi ;;
        esac
    fi
    if [[ -n "${status}" ]]; then
        if [[ "${status}" != "${FW_ELEMENT_FIL_STATUS[${id}]}" ]]; then
            remove+=" "$id
        fi
    fi
    if [[ -n "${tested}" ]]; then
        case "${tested}" in
            y)  if [[ "${FW_ELEMENT_FIL_STATUS[${id}]}" == "N" ]]; then remove+=" "$id; fi ;;
            n)  if [[ "${FW_ELEMENT_FIL_STATUS[${id}]}" != "N" ]]; then remove+=" "$id; fi ;;
        esac
    fi
    if [[ "${not_core}" == yes ]];      then if [[ "Core" == "${FW_ELEMENT_FIL_ORIG[${id}]}" ]]; then remove+=" "$id; fi; fi
done

for id in $remove; do
    arr=${arr/${id}/}
done



############################################################################################
##
## print files as list or table
##
############################################################################################
if [[ "${FW_INSTANCE_CLI_SET["table"]}" == "no" ]]; then
    printf "\n  "
    Format themed text listHeadFmt Files
    printf "\n"
    Print file list "$arr" ${showValues}
else
    Print file table "${arr}" ${showValues} ${withLegend} ${withoutStatus} ${withoutExtras}
fi
