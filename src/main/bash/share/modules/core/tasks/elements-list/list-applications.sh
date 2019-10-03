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
## list-applications - task that lists applications
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option table; Cli add option show-values; Cli add option with-legend; Cli add option without-status; Cli add option without-extras

Cli add option filter-origin    applications
Cli add option filter-requested applications
Cli add option filter-status    applications
Cli add option filter-tested    applications
Cli add option filter-not-core  applications

Parse cli arguments "Options Table+Options Filters" $*


############################################################################################
##
## test CLI
##
############################################################################################
origin=""
requested=""
status=""
tested=""

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


showValues=""
if [[ "${FW_PARSED_ARG_MAP[V]:-${FW_PARSED_ARG_MAP[show-values]:-no}}" == "yes" ]]; then showValues="show-values"; fi

withLegend=""
if [[ "${FW_PARSED_ARG_MAP[W]:-${FW_PARSED_ARG_MAP[with-legend]:-no}}" == "yes" ]]; then withLegend="with-legend"; fi

withoutStatus=""
if [[ "${FW_PARSED_ARG_MAP[S]:-${FW_PARSED_ARG_MAP[without-status]:-no}}" == "yes" ]]; then withoutStatus="without-status"; fi

withoutExtras=""
if [[ "${FW_PARSED_ARG_MAP[E]:-${FW_PARSED_ARG_MAP[without-extras]:-no}}" == "yes" ]]; then withoutExtras="without-extras"; fi



############################################################################################
##
## filter applications
##
############################################################################################
arr="$(Applications has)"
remove=""

for id in $arr; do
    if [[ -n "${origin}" ]]; then
        if [[ "${origin}" != "${FW_ELEMENT_APP_ORIG[${id}]}" ]]; then
            remove+=" "$id
        fi
    fi
        case "${requested}" in
            y)  if [[ ! -n "${FW_ELEMENT_APP_REQUESTED[${id}]:-}" ]]; then remove+=" "$id; fi ;;
            n)  if [[   -n "${FW_ELEMENT_APP_REQUESTED[${id}]:-}" ]]; then remove+=" "$id; fi ;;
        esac
    if [[ -n "${status}" ]]; then
        if [[ "${status}" != "${FW_ELEMENT_APP_STATUS[${id}]}" ]]; then
            remove+=" "$id
        fi
    fi
    if [[ -n "${tested}" ]]; then
        case "${tested}" in
            y)  if [[ "${FW_ELEMENT_APP_STATUS[${id}]}" == "N" ]]; then remove+=" "$id; fi ;;
            n)  if [[ "${FW_ELEMENT_APP_STATUS[${id}]}" != "N" ]]; then remove+=" "$id; fi ;;
        esac
    fi
    if [[ "${not_core}" == yes ]];      then if [[ "Core" == "${FW_ELEMENT_APP_ORIG[${id}]}" ]]; then remove+=" "$id; fi; fi
done

for id in $remove; do
    arr=${arr/${id}/}
done



############################################################################################
##
## print applications as list or table
##
############################################################################################
if [[ ${FW_PARSED_ARG_MAP[T]:-${FW_PARSED_ARG_MAP[table]:-no}} == no ]]; then
    printf "\n  "
    Format themed text listHeadFmt Applications
    printf "\n"
    Print application list "$arr" ${showValues}
else
    Print application table "${arr}" ${showValues} ${withLegend} ${withoutStatus} ${withoutExtras}
fi

exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}
