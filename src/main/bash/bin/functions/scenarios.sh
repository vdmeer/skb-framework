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
## Functions for scenarios
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##


##
## function: GetScenarioID
## - returns a scenario ID for a given ID or SHORT, empty string if not declared
## $1: ID to process
##
GetScenarioID() {
    local ID=$1

    if [[ ! -z ${ID:-} ]]; then
        if [[ -z ${DMAP_SCN_ORIGIN[$ID]:-} ]]; then
            for SHORT in ${!DMAP_SCN_SHORT[@]}; do
                if [[ "$SHORT" == "$ID" ]]; then
                    printf ${DMAP_SCN_SHORT[$SHORT]}
                fi
            done
        else
            printf $ID
        fi
    else
        printf ""
    fi
}


