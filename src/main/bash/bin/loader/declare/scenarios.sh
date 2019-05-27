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
## Declare: scenarios
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##


declare -A DMAP_SCN_ORIGIN              # map [id]=origin
declare -A DMAP_SCN_DECL                # map [id]=decl-file w/o .id ending
declare -A DMAP_SCN_SHORT               # map [id]=short-scenario ID
declare -A DMAP_SCN_EXEC                # map [id]=scenario-script
declare -A DMAP_SCN_DESCR               # map [id]="descr-tag-line"
declare -A DMAP_SCN_MODES               # map [id]="modes"
declare -A DMAP_SCN_MODE_FLAVOR         # map [id]=flavor

declare -A DMAP_SCN_REQ_TASK_MAN        # map [id]=(task-id, ...)
declare -A DMAP_SCN_REQ_TASK_OPT        # map [id]=(task-id, ...)



##
## set dummies for the runtime maps, declare errors otherwise
##
DMAP_SCN_REQ_TASK_MAN["DUMMY"]=dummy
DMAP_SCN_REQ_TASK_OPT["DUMMY"]=dummy



##
## function ScenarioRequire
## - sets requirements for scenario, realizes DSL for scenarios
## $1: scenario-id
## $2: requirement type, one of: task
## $3: requirement valua, one of: task-id
## $4: warning, if set to anything
##
ScenarioRequire() {
    if [[ -z $1 ]]; then
        ConsoleError " ->" "scn-require - no scenario ID given"
        return
    elif [[ -z $2 ]]; then
        ConsoleError " ->" "scn-require - missing requirement type for scenario '$1'"
        return
    elif [[ -z $3 ]]; then
        ConsoleError " ->" "scn-require - missing requirement value for scenario '$1'"
        return
    fi

    local ID=$1
    local TYPE=$2
    local VALUE=$3
    local OPTIONAL=${4:-}
    ConsoleDebug "scenario $ID requires '$TYPE' value '$VALUE' option '$OPTIONAL'"

    if [[ -z $OPTIONAL ]]; then
        case "$TYPE" in
            task)   DMAP_SCN_REQ_TASK_MAN[$ID]="${DMAP_SCN_REQ_TASK_MAN[$ID]:-} $VALUE" ;;
            *)      ConsoleError " ->" "scn-require -scenario $ID requires unknown type '$TYPE'" ;;
        esac
    else
        case "$TYPE" in
            task)   DMAP_SCN_REQ_TASK_OPT[$ID]="${DMAP_SCN_REQ_TASK_OPT[$ID]:-} $VALUE" ;;
            *)      ConsoleError " ->" "scn-require -scenario $ID requires unknown type '$TYPE'" ;;
        esac
    fi
}




##
## function: DeclareScenarioOrigin
## - declares scenarios from origin (a directory)
## $1: origin path
## $2: origin name, e.g. FW_HOME, APP_HOME, or 1 for 1st path
##
DeclareScenarioOrigin() {
    local ORIGIN_PATH=$1
    local ORIGIN=$2

    ConsoleDebug "scanning $ORIGIN from $ORIGIN_PATH"
    local SCN_PATH=$ORIGIN_PATH/${APP_PATH_MAP["SCENARIOS"]}
    if [[ ! -d $SCN_PATH ]]; then
        ConsoleWarn " ->" "declare scenario - did not find scenario directory '$SCN_PATH' at origin '$ORIGIN'"
    else
        local ID
        local SHORT
        local TEST_ID
        local EXECUTABLE
        local MODES
        local MODE_FLAVOR
        local DESCRIPTION
        local NO_ERRORS=true
        local mode
        local file
        local TASK

        for file in $SCN_PATH/**/*.id; do
            if [ ! -f $file ]; then
                continue    ## avoid any strange file, and empty directory
            fi
            ID=${file##*/}
            ID=${ID%.*}
            EXECUTABLE=${file%.*}
            EXECUTABLE+=".scn"

            local HAVE_ERRORS=false

            SHORT=
            MODES=
            MODE_FLAVOR=
            DESCRIPTION=
            source "$file"

            if [[ ! -f $EXECUTABLE ]]; then
                ConsoleError " ->" "declare scenario - '$ID' without script file"
                HAVE_ERRORS=true
            elif [[ ! -r $EXECUTABLE ]]; then
                ConsoleError " ->" "declare scenario - '$ID' script not readable"
                HAVE_ERRORS=true
            fi

            if [[ -z "${MODES:-}" ]]; then
                ConsoleError " ->" "declare scenario - '$ID' has no modes defined"
                HAVE_ERRORS=true
            else
                for mode in $MODES; do
                    case $mode in
                        dev | build | use)
                            ConsoleDebug "scenario '$ID' found mode '$mode'"
                            ;;
                        *)
                            ConsoleError " ->" "declare scenario - '$ID' with unknown mode '$mode'"
                            HAVE_ERRORS=true
                            ;;
                    esac
                done
            fi

            if [[ -z "${MODE_FLAVOR:-}" ]]; then
                ConsoleError " ->" "declare scenario - '$ID' has no app mode flavor defined"
                HAVE_ERRORS=true
            else
                case $MODE_FLAVOR in
                    std | install)
                        ConsoleDebug "scenario '$ID' found app mode flavor '$MODE_FLAVOR'"
                        ;;
                    *)
                        ConsoleError " ->" "declare scenario - '$ID' with unknown app mode flavor '$MODE_FLAVOR'"
                        HAVE_ERRORS=true
                        ;;
                esac
            fi

            if [[ -z "${DESCRIPTION:-}" ]]; then
                ConsoleError " ->" "declare scenario - '$ID' has no description"
                HAVE_ERRORS=true
            fi

            if [[ ! -z ${DMAP_SCN_ORIGIN[$ID]:-} ]]; then
                ConsoleError " ->" "overwriting ${DMAP_SCN_ORIGIN[$ID]}:::$ID with $ORIGIN:::$ID"
                HAVE_ERRORS=true
            fi
            if [[ ! -z ${SHORT:-} && ! -z ${DMAP_SCN_SHORT[${SHORT:-}]:-} ]]; then
                ConsoleError " ->" "overwriting scenario short from ${DMAP_SCN_SHORT[$SHORT]} to $ID"
                HAVE_ERRORS=true
            fi

            if [[ $HAVE_ERRORS == true ]]; then
                ConsoleError " ->" "declare scenario - could not declare scenario"
                NO_ERRORS=false
            else
                DMAP_SCN_ORIGIN[$ID]=$ORIGIN
                DMAP_SCN_DECL[$ID]=${file%.*}
                DMAP_SCN_EXEC[$ID]=$EXECUTABLE
                DMAP_SCN_MODES[$ID]="$MODES"
                DMAP_SCN_MODE_FLAVOR[$ID]="$MODE_FLAVOR"
                DMAP_SCN_DESCR[$ID]="$DESCRIPTION"
                if [[ ! -z ${SHORT:-} ]]; then
                    DMAP_SCN_SHORT[$SHORT]=$ID
                    ConsoleDebug "declared $ORIGIN:::$ID with short '$SHORT'"
                else
                    ConsoleDebug "declared $ORIGIN:::$ID without short"
                fi
            fi
        done
    fi
}



##
## function: DeclareScenarios
## - declares scenarios from multiple sources
##
DeclareScenarios() {
    local ORIG_PATH
    local COUNT=1

    ConsoleInfo "-->" "declare scenarios"
    ConsoleResetErrors

    DeclareScenarioOrigin ${CONFIG_MAP["FW_HOME"]} FW_HOME
    if [[ "${CONFIG_MAP["FW_HOME"]}" != ${CONFIG_MAP["APP_HOME"]} ]]; then
        DeclareScenarioOrigin ${CONFIG_MAP["APP_HOME"]} APP_HOME
    fi
    if [[ -n "${CONFIG_MAP["SCENARIO_PATH"]:-}" ]]; then
        for ORIG_PATH in ${CONFIG_MAP["SCENARIO_PATH"]}; do
            DeclareScenarioOrigin $ORIG_PATH $COUNT
            COUNT=$(($COUNT + 1))
        done
    fi
    ConsoleInfo "-->" "done"
}
