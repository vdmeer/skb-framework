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
## Loader Initialisation: process scenarios
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.3
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##



declare -A RTMAP_SCN_STATUS             # map [id]="status" -> Not Error Warn Success
declare -A RTMAP_SCN_LOADED             # map of loaded scenarios [id]=ok
declare -A RTMAP_SCN_UNLOADED           # map of unloaded scenarios [id]=ok

RTMAP_SCN_LOADED["DUMMY"]=dummy
RTMAP_SCN_UNLOADED["DUMMY"]=dummy



##
## function: ProcessScenarioReqTask
## - tests all required tasks for a scenario
## ! does not test against unloaded scenarios!
## $1: scenario id
##
ProcessScenarioReqTask() {
    local ID=$1
    local TASK

    if [[ ! -z "${DMAP_SCN_REQ_TASK_MAN[$ID]:-}" ]]; then
        for TASK in ${DMAP_SCN_REQ_TASK_MAN[$ID]}; do
            ConsoleTrace "   $ID - task man $TASK"
            if [[ -z ${DMAP_TASK_ORIGIN[$TASK]:-} ]]; then
                ConsoleError " ->" "process-scenario/task - $ID unknown task '$TASK'"
                RTMAP_SCN_UNLOADED[$ID]="${RTMAP_SCN_UNLOADED[$ID]:-} task-id::$TASK"
                SetArtifactStatus scn $ID E
            else
                if [[ ! -z "${RTMAP_TASK_UNLOADED[$TASK]:-}" ]]; then
                    ConsoleError " ->" "process-scenario/task - $ID with unloaded task '$TASK'"
                    RTMAP_SCN_UNLOADED[$ID]="${RTMAP_SCN_UNLOADED[$ID]:-} task-set::$TASK"
                    SetArtifactStatus scn $ID E
                else
                    SetArtifactStatus scn $ID S
                    RTMAP_SCN_LOADED[$ID]="${RTMAP_SCN_LOADED[$ID]:-} task"
                    ConsoleDebug "process-scenario/task - processed '$ID' for task '$TASK' with success"
                fi
            fi
        done
    fi

    if [[ ! -z "${DMAP_SCN_REQ_TASK_OPT[$ID]:-}" ]]; then
        for TASK in ${DMAP_SCN_REQ_TASK_OPT[$ID]}; do
            ConsoleTrace "   $ID - task opt $TASK"
            if [[ -z ${DMAP_TASK_ORIGIN[$TASK]:-} ]]; then
                ConsoleError " ->" "process-scenario/task - $ID unknown task '$TASK'"
                RTMAP_SCN_UNLOADED[$ID]="${RTMAP_SCN_UNLOADED[$ID]:-} task-id::$TASK"
                SetArtifactStatus scn $ID E
            else
                if [[ ! -z "${RTMAP_TASK_UNLOADED[$TASK]:-}" ]]; then
                    ConsoleWarnStrict " ->" "process-scenario/task - $ID with unloaded task '$TASK'"
                    if [[ "${CONFIG_MAP["STRICT"]}" == "on" ]]; then
                        RTMAP_SCN_UNLOADED[$ID]="${RTMAP_SCN_UNLOADED[$ID]:-} task-set::$TASK"
                        SetArtifactStatus scn $ID E
                    else
                        SetArtifactStatus scn $ID W
                        RTMAP_SCN_LOADED[$ID]="${RTMAP_SCN_LOADED[$ID]:-} task"
                        ConsoleDebug "process-scenario/task - processed '$ID' for task '$TASK' with warn"
                    fi
                else
                    SetArtifactStatus scn $ID S
                    RTMAP_SCN_LOADED[$ID]="${RTMAP_SCN_LOADED[$ID]:-} task"
                    ConsoleDebug "process-scenario/task - processed '$ID' for task '$TASK' with success"
                fi
            fi
        done
    fi
}



##
## function: ProcessScenarios
## - process all scenarios
##
ProcessScenarios() {
    ConsoleResetErrors
    ConsoleInfo "-->" "process scenarios"

    local ID
    local LOAD_SCN

    ## initialize the status maps
    for ID in "${!DMAP_SCN_ORIGIN[@]}"; do
        RTMAP_SCN_STATUS[$ID]="N"
    done

    for ID in "${!DMAP_SCN_ORIGIN[@]}"; do
        LOAD_SCN=false
        if [[ "${CONFIG_MAP["APP_MODE"]}" == "all" ]]; then
            LOAD_SCN=true
        else 
            case ${DMAP_SCN_MODES[$ID]} in
                *${CONFIG_MAP["APP_MODE"]}*)
                    LOAD_SCN=true
                    ;;
            esac
        fi

        if [[ $LOAD_SCN == false ]]; then
            ConsoleDebug "scenario '$ID' not defined for current mode '${CONFIG_MAP["APP_MODE"]}', not loaded"
            SetArtifactStatus scn $ID N
            continue
        fi

        if [[ "${CONFIG_MAP["APP_MODE_FLAVOR"]}" == "${DMAP_SCN_MODE_FLAVOR[$ID]:-}" ]]; then
            LOAD_SCN=true
        elif [[ "${DMAP_SCN_MODE_FLAVOR[$ID]:-}" == "std" ]]; then
            LOAD_SCN=true
        else
            ConsoleDebug "scenario '$ID' not defined for current app mode flavor '${CONFIG_MAP["APP_MODE_FLAVOR"]}', not loaded"
            SetArtifactStatus scn $ID N
            LOAD_SCN=false
        fi


        if [[ $LOAD_SCN == true ]]; then
            RTMAP_SCN_LOADED[$ID]="${RTMAP_SCN_LOADED[$ID]:-} mode"
            ConsoleDebug "process-scenario/mode - processed '$ID' for mode and flavor with success"
            SetArtifactStatus scn $ID S

            ProcessScenarioReqTask $ID
        fi
    done

    ## now remove all scenarios from RTMAP_SCN_LOADED that are in RTMAP_SCN_UNLOADED
    for ID in "${!RTMAP_SCN_UNLOADED[@]}"; do
        if [[ ! -z "${RTMAP_SCN_LOADED[$ID]:-}" ]]; then
            unset RTMAP_SCN_LOADED[$ID]
        fi
    done

    ConsoleInfo "-->" "done"
}
