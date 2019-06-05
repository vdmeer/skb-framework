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
## Declare: (CLI) Options
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##



declare -A DMAP_OPT_ORIGIN              # map [id]=type (exit, run)
declare -A DMAP_OPT_SHORT               # map [id]=short-cmd
declare -A DMAP_OPT_ARG                 # map [id]=argument
declare -A DMAP_OPT_DESCR               # map [id]="descr-tag-line"



##
## function: DeclareOptions
## - declares CLI options from FW_HOME directory
##
DeclareOptions() {
    ConsolePrint info "declare options"
    ResetCounter errors

    if [[ ! -d $FW_HOME/${FW_PATH_MAP["OPTIONS"]} ]]; then
        ConsolePrint error "declare-opt - did not find option directory, tried \$FW_HOME/${FW_PATH_MAP["OPTIONS"]}"
        ConsolePrint info "done"
    else
        ConsolePrint debug "building new declaration map from directory: \$FW_HOME/${FW_PATH_MAP["OPTIONS"]}"
        ResetCounter errors

        local file
        local ID
        local SHORT
        local ARGUMENT
        local DESCRIPTION
        local NO_ERRORS=true

        for file in $FW_HOME/${FW_PATH_MAP["OPTIONS"]}/**/*.id; do
            ID=${file##*/}
            ID=${ID%.*}

            if [[ ! -z ${DMAP_OPT_ORIGIN[$ID]:-} ]]; then
                ConsolePrint error "internal error: DMAP_OPT_ORIGIN for id '$ID' already set"
            else
                local HAVE_ERRORS=false

                SHORT=
                ARGUMENT=
                DESCRIPTION=
                source "$file"

                if [[ -z "${DESCRIPTION:-}" ]]; then
                    ConsolePrint error "declare option - '$ID' has no description"
                    HAVE_ERRORS=true
                fi

                if [[ $HAVE_ERRORS == true ]]; then
                    ConsolePrint error "declare option - could not declare option"
                    NO_ERRORS=false
                else
                    DMAP_OPT_SHORT[$ID]=$SHORT
                    DMAP_OPT_ARG[$ID]=$ARGUMENT
                    DMAP_OPT_DESCR[$ID]=$DESCRIPTION
                    case "$file" in
                        *"${FW_PATH_MAP["OPTIONS"]}/run/"*)  DMAP_OPT_ORIGIN[$ID]=run ;;
                        *"${FW_PATH_MAP["OPTIONS"]}/exit/"*) DMAP_OPT_ORIGIN[$ID]=exit ;;
                    esac
                    ConsolePrint debug "declared option $ID"
                fi
            fi
        done
    fi
    ConsolePrint info "done"
}
