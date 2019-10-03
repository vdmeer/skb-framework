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
## list-modules - task that lists modules
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option table; Cli add option show-values; Cli add option with-legend; Cli add option without-status; Cli add option without-extras

Parse cli arguments "Options Table+Options" $*


############################################################################################
##
## test CLI
##
############################################################################################
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
## print modules as list or table
##
############################################################################################
if [[ ${FW_PARSED_ARG_MAP[T]:-${FW_PARSED_ARG_MAP[table]:-no}} == no ]]; then
    printf "\n  "
    Format themed text listHeadFmt Modules
    printf "\n"
    Print module list ${showValues}
else
    Print module table ${showValues} ${withLegend} ${withoutStatus} ${withoutExtras}
fi

exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}
