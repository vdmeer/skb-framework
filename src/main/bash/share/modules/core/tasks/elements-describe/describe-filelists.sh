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
## describe-filelists - task that describes filelists
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option filter-id        describe "file list"
Cli add option filter-origin    "file lists"
Cli add option filter-requested "file lists"
Cli add option filter-status    "file lists"
Cli add option filter-tested    "file lists"
Cli add option filter-not-core  "file lists"

Parse cli arguments "Options Filters" $*


############################################################################################
##
## test CLI
##
############################################################################################
name=""
origin=""
requested=""
status=""
tested=""

if [[ "${FW_PARSED_ARG_MAP[i]:-${FW_PARSED_ARG_MAP[id]:-no}}" == yes ]]; then
    Test existing file id "${FW_PARSED_VAL_MAP[i]:-${FW_PARSED_VAL_MAP[id]}}"
    name="${FW_PARSED_VAL_MAP[i]:-${FW_PARSED_VAL_MAP[id]}}"
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



############################################################################################
##
## filter filelists
##
############################################################################################
arr="$(Filelists has)"
remove=""
if [[ -n "${name}" ]]; then
    arr="${name}"
else
    for id in $arr; do
        if [[ -n "${origin}" ]]; then
            if [[ "${origin}" != "${FW_ELEMENT_FLS_ORIG[${id}]}" ]]; then
                remove+=" "$id
            fi
        fi
        if [[ -n "${requested}" ]]; then
            case "${requested}" in
                y)  if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED[${id}]:-}" ]]; then remove+=" "$id; fi ;;
                n)  if [[   -n "${FW_ELEMENT_FLS_REQUESTED[${id}]:-}" ]]; then remove+=" "$id; fi ;;
            esac
        fi
        if [[ -n "${status}" ]]; then
            if [[ "${status}" != "${FW_ELEMENT_FLS_STATUS[${id}]}" ]]; then
                remove+=" "$id
            fi
        fi
        if [[ -n "${tested}" ]]; then
            case "${tested}" in
                y)  if [[ "${FW_ELEMENT_FLS_STATUS[${id}]}" == "N" ]]; then remove+=" "$id; fi ;;
                n)  if [[ "${FW_ELEMENT_FLS_STATUS[${id}]}" != "N" ]]; then remove+=" "$id; fi ;;
            esac
        fi
        if [[ "${not_core}" == yes ]];      then if [[ "Core" == "${FW_ELEMENT_FLS_ORIG[${id}]}" ]]; then remove+=" "$id; fi; fi
    done
    for id in $remove; do
        arr=${arr/${id}/}
    done
fi



############################################################################################
##
## print filelists descriptions
##
############################################################################################
Print filelist descriptions "${arr}"

exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}
