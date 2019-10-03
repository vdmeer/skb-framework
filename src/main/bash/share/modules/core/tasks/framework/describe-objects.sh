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
## describe-objects - task that describes objects in general
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option target-all

Cli add general option  configuration   c "" "general description of the configuration object" "Targets"
Cli add general option  formats         f "" "general description of the format object" "Targets"
Cli add general option  levels          l "" "general description of the level object" "Targets"
Cli add general option  messages        M "" "general description of message object" "Targets"
Cli add general option  modes           m "" "general description of mode object" "Targets"
Cli add general option  phases          p "" "general description of phase object" "Targets"
Cli add general option  settings        s "" "general description of setting object" "Targets"
Cli add general option  themeitems      T "" "general description of theme item object" "Targets"
Cli add general option  themes          t "" "general description of theme object" "Targets"

Parse cli arguments "Options Target" $*


############################################################################################
##
## set targets
##
############################################################################################
targets="$(Framework has objects)"

if [[ "${FW_PARSED_ARG_MAP[A]:-${FW_PARSED_ARG_MAP[all]:-no}}" == no ]]; then
    if [[ "${FW_PARSED_ARG_MAP[c]:-${FW_PARSED_ARG_MAP[configuration]:-no}}" == no ]]; then targets=${targets/Configuration/}; fi
    if [[ "${FW_PARSED_ARG_MAP[f]:-${FW_PARSED_ARG_MAP[formats]:-no}}" == no ]]; then targets=${targets/Formats/}; fi
    if [[ "${FW_PARSED_ARG_MAP[l]:-${FW_PARSED_ARG_MAP[levels]:-no}}" == no ]]; then targets=${targets/Levels/}; fi
    if [[ "${FW_PARSED_ARG_MAP[M]:-${FW_PARSED_ARG_MAP[messages]:-no}}" == no ]]; then targets=${targets/Messages/}; fi
    if [[ "${FW_PARSED_ARG_MAP[m]:-${FW_PARSED_ARG_MAP[modes]:-no}}" == no ]]; then targets=${targets/Modes/}; fi
    if [[ "${FW_PARSED_ARG_MAP[p]:-${FW_PARSED_ARG_MAP[phases]:-no}}" == no ]]; then targets=${targets/Phases/}; fi
    if [[ "${FW_PARSED_ARG_MAP[s]:-${FW_PARSED_ARG_MAP[settings]:-no}}" == no ]]; then targets=${targets/Settings/}; fi
    if [[ "${FW_PARSED_ARG_MAP[T]:-${FW_PARSED_ARG_MAP[themeitems]:-no}}" == no ]]; then targets=${targets/Themeitems/}; fi
    if [[ "${FW_PARSED_ARG_MAP[t]:-${FW_PARSED_ARG_MAP[themes]:-no}}" == no ]]; then targets=${targets/Themes/}; fi
fi



############################################################################################
##
## print application text
##
############################################################################################
for target in $targets; do
    printf "\n"; Describe object ${target}
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}; fi
done
