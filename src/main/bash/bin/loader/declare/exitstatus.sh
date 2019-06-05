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
## Declare: exit status
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##



declare -A DMAP_ES                      # map [id]="origin"
declare -A DMAP_ES_PROBLEM              # map [id]="problem"
declare -A DMAP_ES_DESCR                # map [id]="descr-tag-line"



##
## function: DeclareExitStatus
## - declares exit-status
##
DeclareExitStatus() {
    if [[ ! -d $FW_HOME/${FW_PATH_MAP["EXITSTATUS"]} ]]; then
        ConsolePrint error "declare-exitstatus - did not find option directory, tried \$FW_HOME/${FW_PATH_MAP["EXITSTATUS"]}"
        ConsolePrint info "done"
    else
        ConsolePrint debug "building new declaration map from directory: \$FW_HOME/${FW_PATH_MAP["EXITSTATUS"]}"
        ResetCounter errors

        local file
        local ID
        local PROBLEM
        local ORIGIN
        local DESCRIPTION
        local NO_ERRORS=true

        for file in $FW_HOME/${FW_PATH_MAP["EXITSTATUS"]}/**/*.id; do
            ID=${file##*/}
            ID=${ID%.*}

            if [[ ! -z ${DMAP_ES[$ID]:-} ]]; then
                ConsolePrint error "internal error: DMAP_ES for id '$ID' already set"
            else
                local HAVE_ERRORS=false

                DESCRIPTION=
                source "$file"

                if [[ -z "${DESCRIPTION:-}" ]]; then
                    ConsolePrint error "declare exit-status - '$ID' has no description"
                    HAVE_ERRORS=true
                fi
                if [[ -z "${PROBLEM:-}" ]]; then
                    ConsolePrint error "declare exit-status - '$ID' has no problem defined"
                    HAVE_ERRORS=true
                fi
                if [[ -z "${ORIGIN:-}" ]]; then
                    ConsolePrint error "declare exit-status - '$ID' has no origin defined"
                    HAVE_ERRORS=true
                fi

                if [[ $HAVE_ERRORS == true ]]; then
                    ConsolePrint error "declare exit-status - could not declare exit-status"
                    NO_ERRORS=false
                else
                    DMAP_ES[$ID]=$ORIGIN
                    DMAP_ES_PROBLEM[$ID]=$PROBLEM
                    DMAP_ES_DESCR[$ID]=$DESCRIPTION
                    ConsolePrint debug "declared exit-status $ID"
                fi
            fi
        done
    fi
    ConsolePrint info "done"
}
