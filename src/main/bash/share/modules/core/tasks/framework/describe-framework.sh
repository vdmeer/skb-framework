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
## describe-framework - task that describes framework aspects
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option target-all

Cli add general option  authors     a "" "the authors of the framework" "Targets"
Cli add general option  description d "" "a description of the framework" "Targets"
Cli add general option  bugs        b "" "information about bugs and problem reporting" "Targets"
Cli add general option  copying     c "" "information on the framework license" "Targets"
Cli add general option  resources   r "" "further (online) resources" "Targets"
Cli add general option  security    s "" "security aspects of the framework" "Targets"

Parse cli arguments "Options Targets" $*


############################################################################################
##
## set targets
##
############################################################################################
targets="description security bugs authors resources copying"

if [[ "${FW_PARSED_ARG_MAP[A]:-${FW_PARSED_ARG_MAP[all]:-no}}" == no ]]; then
    if [[ "${FW_PARSED_ARG_MAP[a]:-${FW_PARSED_ARG_MAP[authors]:-no}}" == no ]]; then targets=${targets/authors/}; fi
    if [[ "${FW_PARSED_ARG_MAP[b]:-${FW_PARSED_ARG_MAP[bugs]:-no}}" == no ]]; then targets=${targets/bugs/}; fi
    if [[ "${FW_PARSED_ARG_MAP[c]:-${FW_PARSED_ARG_MAP[copying]:-no}}" == no ]]; then targets=${targets/copying/}; fi
    if [[ "${FW_PARSED_ARG_MAP[d]:-${FW_PARSED_ARG_MAP[description]:-no}}" == no ]]; then targets=${targets/description/}; fi
    if [[ "${FW_PARSED_ARG_MAP[r]:-${FW_PARSED_ARG_MAP[resources]:-no}}" == no ]]; then targets=${targets/resources/}; fi
    if [[ "${FW_PARSED_ARG_MAP[s]:-${FW_PARSED_ARG_MAP[security]:-no}}" == no ]]; then targets=${targets/security/}; fi
fi



############################################################################################
##
## print framework text
##
############################################################################################
for target in $targets; do
    printf "\n"; Describe framework ${target}
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}; fi
done
