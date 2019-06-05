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
## Declare: (Shell) commands
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



declare -A DMAP_CMD                     # map [id]=short | --
declare -A DMAP_CMD_SHORT               # map [id]=long
declare -A DMAP_CMD_ARG                 # map [id]=argument
declare -A DMAP_CMD_DESCR               # map [id]="descr-tag-line"



##
## function: DeclareCommands
## - declares Shell commands from FW_HOME directory
##
DeclareCommands() {
    ConsolePrint info "declare commands"
    ResetCounter errors

    if [[ ! -d $FW_HOME/${FW_PATH_MAP["COMMANDS"]} ]]; then
        ConsolePrint error "declare-cmd - did not find command directory, tried \$FW_HOME/${FW_PATH_MAP["COMMANDS"]}"
        ConsolePrint info "done"
    else
        ConsolePrint debug "building new declaration map from directory: \$FW_HOME/${FW_PATH_MAP["COMMANDS"]}"
        ResetCounter errors

        local file
        local ID
        local COMMAND
        local SHORT
        local ARGUMENT
        local DESCRIPTION
        local NO_ERRORS=true

        for file in $FW_HOME/${FW_PATH_MAP["COMMANDS"]}/**/*.id; do
            ID=${file##*/}
            ID=${ID%.*}

            if [[ ! -z ${DMAP_CMD[$ID]:-} ]]; then
                ConsolePrint error "internal error: DMAP_CMD for id '$ID' already set"
            else
                local HAVE_ERRORS=false

                SHORT=
                ARGUMENT=
                DESCRIPTION=
                source "$file"

                if [[ -z "${DESCRIPTION:-}" ]]; then
                    ConsolePrint error "declare command - '$ID' has no description"
                    HAVE_ERRORS=true
                fi

                if [[ $HAVE_ERRORS == true ]]; then
                    ConsolePrint error "declare command - could not declare command"
                    NO_ERRORS=false
                else
                    if [[ -n "$SHORT" ]]; then
                        DMAP_CMD[$ID]=$SHORT
                        DMAP_CMD_SHORT[$SHORT]=$ID
                    else
                        DMAP_CMD[$ID]="--"
                    fi
                    DMAP_CMD_ARG[$ID]=$ARGUMENT
                    DMAP_CMD_DESCR[$ID]=$DESCRIPTION
                    ConsolePrint debug "declared command $ID"
                fi
            fi
        done
    fi
    ConsolePrint info "done"
}
