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
## describe-options - task that describes options
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option filter-id        describe option
Cli add option filter-exitop
Cli add option filter-runtop

Parse cli arguments "Options Filters" $*


############################################################################################
##
## test CLI
##
############################################################################################
name=""
exit=""
runtime=""

if [[ "${FW_PARSED_ARG_MAP[i]:-${FW_PARSED_ARG_MAP[id]:-no}}" == yes ]]; then
    Test existing option id "${FW_PARSED_VAL_MAP[i]:-${FW_PARSED_VAL_MAP[id]}}"
    name="${FW_PARSED_VAL_MAP[i]:-${FW_PARSED_VAL_MAP[id]}}"
fi
if [[ "${FW_PARSED_ARG_MAP[e]:-${FW_PARSED_ARG_MAP[exit]:-no}}" == yes ]]; then
    exit="Exit+Options"
fi
if [[ "${FW_PARSED_ARG_MAP[r]:-${FW_PARSED_ARG_MAP[runtime]:-no}}" == yes ]]; then
    runtime="Runtime+Options"
fi



############################################################################################
##
## filter options
##
############################################################################################
arr="$(Options has long)"
remove=""

if [[ -n "${name}" ]]; then
    arr="${name}"
else
    for id in $arr; do
        if [[ -n "${exit}" ]]; then
            if [[ "${exit}" != "${FW_ELEMENT_OPT_CAT[${id}]}" ]]; then
                remove+=" "$id
            fi
        fi
        if [[ -n "${runtime}" ]]; then
            if [[ "${runtime}" != "${FW_ELEMENT_OPT_CAT[${id}]}" ]]; then
                remove+=" "$id
            fi
        fi
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
Print option descriptions "${arr}"

exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}
