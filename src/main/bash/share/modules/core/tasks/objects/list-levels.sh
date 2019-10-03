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
## list-levels - task that lists levels
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option table; Cli add option without-status

Parse cli arguments "Options Table+Options" $*


############################################################################################
##
## test CLI
##
############################################################################################
withoutStatus=""
if [[ "${FW_PARSED_ARG_MAP[S]:-${FW_PARSED_ARG_MAP[without-status]:-no}}" == "yes" ]]; then withoutStatus="without-status"; fi



############################################################################################
##
## print levels as list or table
##
############################################################################################
if [[ ${FW_PARSED_ARG_MAP[T]:-${FW_PARSED_ARG_MAP[table]:-no}} == no ]]; then
    printf "\n  "
    Format themed text listHeadFmt Levels
    printf "\n"
    Print level list
else
    Print level table ${withoutStatus}
fi
