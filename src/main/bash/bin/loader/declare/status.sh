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
## Functions: status - manage artifact status
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.3
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##



##
## funct: CalculateNewArtifactStatus
## - calculates the new status
## $1: old status
## $2: new status
##
CalculateNewArtifactStatus() {
    local ST_OLD=$1
    local ST_NEW=$2

    case "$ST_OLD" in
        N)
            echo "$ST_NEW"
            ;;
        E)
            case "$ST_NEW" in
                N)  echo N ;;
                *)  echo E ;;
            esac
            ;;
        W)
            case "$ST_NEW" in
                N | S | W)  echo W ;;
                E)          echo E ;;
            esac
            ;;
        S)
            case "$ST_NEW" in
                N | S)      echo S ;;
                W)          echo W ;;
                E)          echo E ;;
            esac
            ;;
    esac
}



##
## function: SetArtifactStatus
## - sets the status of an artifact if new status is higher than old one
## $1: type, one of: task, dep, scn
## $2: artifact ID
## $3: new status: (N, notdone), (S, success), (W, warning), (E, error)
##
SetArtifactStatus() {
    local ARTIFACT_TYPE=$1
    local ID=$2
    local STATUS=$3

    local OLD

    case "$ARTIFACT_TYPE" in
        dep)
            if [[ -z ${DMAP_DEP_ORIGIN[$ID]:-} ]]; then
                ConsoleError " ->" "set-artifact-status - unknown dependency '$ID'"
                return
            fi
            OLD=${RTMAP_DEP_STATUS[$ID]:-}
            ;;
        task)
            ID=$(GetTaskID $ID)
            if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
                ConsoleError " ->" "set-artifact-status - unknown task '$ID'"
                return
            fi
            OLD=${RTMAP_TASK_STATUS[$ID]:-}
            ;;
        scn)
            ID=$(GetScenarioID $ID)
            if [[ -z ${DMAP_SCN_ORIGIN[$ID]:-} ]]; then
                ConsoleError " ->" "set-artifact-status - unknown scenario '$ID'"
                return
            fi
            OLD=${RTMAP_SCN_STATUS[$ID]:-}
            ;;
        *)
            ConsoleError " ->" "set-artifact-status - unknown artifact type '$ARTIFACT_TYPE'"
            return
            ;;
    esac

    case "$STATUS" in
        N | notdone)    STATUS=N ;;
        S | success)    STATUS=S ;;
        W | warning)    STATUS=W ;;
        E | error)      STATUS=E ;;
        *)
            ConsoleError " ->" "set-artifact-status - unknown status '$STATUS'"
            return
            ;;
    esac

    case "$ARTIFACT_TYPE" in
        dep)    RTMAP_DEP_STATUS[$ID]=$(CalculateNewArtifactStatus $OLD $STATUS) ;;
        task)   RTMAP_TASK_STATUS[$ID]=$(CalculateNewArtifactStatus $OLD $STATUS) ;;
        scn)    RTMAP_SCN_STATUS[$ID]=$(CalculateNewArtifactStatus $OLD $STATUS) ;;
    esac
}



##
## function: MissingReqIsError
## - determines if a missing requirement is an error
## - true or false
## $1: warning argument
##
# MissingReqIsError() {
#     if [[ -n "$WARN" ]]; then
#         if [[ "${CONFIG_MAP["STRICT"]}" == "on" ]]; then
#             return 0
#         else
#             return 1
#         fi
#     else
#         return 0
#     fi
# }
