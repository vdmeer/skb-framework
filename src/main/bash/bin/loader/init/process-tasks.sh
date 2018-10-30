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
## Loader Initialisation: process tasks
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##



declare -A RTMAP_TASK_STATUS        # map [id]="status" -> Not Error Warn Success
declare -A RTMAP_TASK_LOADED        # map of loaded tasks [id]=ok
declare -A RTMAP_TASK_UNLOADED      # map of unloaded tasks [id]=ok

RTMAP_TASK_LOADED["DUMMY"]=dummy
RTMAP_TASK_UNLOADED["DUMMY"]=dummy


declare -A RTMAP_DEP_STATUS         # map/export for dependency status: [id]=[N]ot-done, [S]uccess, [W]arning(s), [E]rrors
declare -A RTMAP_DEP_TESTED         # array/export for tested task dependencies
RTMAP_DEP_TESTED["DUMMY"]=dummy

declare -A RTMAP_REQUESTED_DEP      # map for requested dependencies
declare -A RTMAP_REQUESTED_PARAM    # map for requested parameters

##
## Add standard parameters settable from the outside as requested
##
RTMAP_REQUESTED_PARAM["SHELL_PROMPT"]="SHELL_PROMPT"
RTMAP_REQUESTED_PARAM["CACHE_DIR"]="CACHE_DIR"

RTMAP_REQUESTED_DEP["DUMMY"]=dummy



##
## function ProcessTaskTestFile
## - tests a file for existence
## $1: setting ID (parameter ID)
## $2: man | opt
## $3: task ID for messages
##
ProcessTaskTestFile() {
    if [[ ! -f "${CONFIG_MAP[$1]}" ]]; then
        ConsoleWarnStrict " ->" "test file/task $3: not a regular file for setting '$1' as '${CONFIG_MAP[$1]}'"
        if [[ ( "$2" == opt && "${CONFIG_MAP["STRICT"]}" == "on" ) || "$2" == man ]]; then
            return 1
        else
            return 0
        fi
    fi
    if [[ ! -r "${CONFIG_MAP[$1]}" ]]; then
        ConsoleWarnStrict " ->" "test file/task $3: file not readable for setting '$1' as '${CONFIG_MAP[$1]}'"
        if [[ ( "$2" == opt && "${CONFIG_MAP["STRICT"]}" == "on" ) || "$2" == man ]]; then
            return 1
        else
            return 0
        fi
    fi
    return 0
}



##
## function ProcessTaskTestFileList
## - tests a file list for existence of every file included
## $1: setting ID (parameter ID)
## $2: man | opt
## $3: task ID for messages
##
ProcessTaskTestFileList() {
    local FILE
    local RESULT=0

    for FILE in ${CONFIG_MAP[$1]}; do
        if [[ ! -f "$FILE" ]]; then
            ConsoleWarnStrict " ->" "test file-list/task $3/param $1: not a regular file '$FILE'"
            if [[ ( "$2" == opt && "${CONFIG_MAP["STRICT"]}" == "on" ) || "$2" == man ]]; then
                RESULT=1
            fi
        fi
        if [[ ! -r "$FILE" ]]; then
            ConsoleWarnStrict "  ->" "test file-list/task $3/param $1: file nor readable '$FILE'"
            if [[ ( "$2" == opt && "${CONFIG_MAP["STRICT"]}" == "on" ) || "$2" == man ]]; then
                RESULT=1
            fi
        fi
    done
    echo $RESULT
}



##
## function ProcessTaskTestDir
## - tests a file for existence
## $1: setting ID (parameter ID)
## $2: man | opt
## $3: task ID for messages
##
ProcessTaskTestDir() {
    if [[ ! -d "${CONFIG_MAP[$1]}" ]]; then
        ConsoleWarnStrict " ->" "test directories for task $3: not a redable directory for $1 as '${CONFIG_MAP[$1]}'"
        if [[ ( "$2" == opt && "${CONFIG_MAP["STRICT"]}" == "on" ) || "$2" == man ]]; then
            return 1
        else
            return 0
        fi
    fi
    return 0
}



##
## function ProcessTaskTestDirList
## - tests a file for existence
## $1: setting ID (parameter ID)
## $2: man | opt
## $3: task ID for messages
##
ProcessTaskTestDirList() {
    local DIR
    local RESULT=0

    for DIR in ${CONFIG_MAP[$1]}; do
        if [[ ! -d "$DIR" ]]; then
            ConsoleWarnStrict " ->" "test directory-list/task $3/param $1: not a directory '$DIR'"
            if [[ ( "$2" == opt && "${CONFIG_MAP["STRICT"]}" == "on" ) || "$2" == man ]]; then
                RESULT=1
            fi
        fi
    done
    echo $RESULT
}



##
## function ProcessTaskTestDirCD
## - tests a file for existence
## $1: setting ID (parameter ID)
## $2: man | opt
## $3: task ID for messages
##
ProcessTaskTestDirCD() {
    if ConsoleIsDebug; then MD_OPT="$MD_OPT -v"; fi
    mkdir $MD_OPT ${CONFIG_MAP[$1]} 2> /dev/null
    MD_ERR=$?
    if (( $MD_ERR != 0 )) || [[ ! -d ${CONFIG_MAP[$1]} ]]; then
        ConsoleWarnStrict " ->" "test directories-cd for task $3: not a directory for $1 as ${CONFIG_MAP[$1]}, tried mkdir"
        if [[ ( "$2" == opt && "${CONFIG_MAP["STRICT"]}" == "on" ) || "$2" == man ]]; then
            return 1
        else
            return 0
        fi
    fi
    return 0
}



##
## function: ProcessTaskReqParam
## - tests all required parameters for a task
## $1: task id
##
ProcessTaskReqParam() {
    local ID=$1
    local PARAM
    local FOUND

    if [[ ! -z "${DMAP_TASK_REQ_PARAM_MAN[$ID]:-}" ]]; then
        for PARAM in ${DMAP_TASK_REQ_PARAM_MAN[$ID]}; do
            FOUND=false
            ConsoleTrace "   $ID - param man $PARAM"
            if [[ -z ${DMAP_PARAM_ORIGIN[$PARAM]:-} ]]; then
                ConsoleError " ->" "process-task/param - $ID unknown parameter '$PARAM'"
                RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} par-id::$PARAM"
                SetArtifactStatus task $ID E
            else
                RTMAP_REQUESTED_PARAM[$PARAM]=$PARAM
                if [[ -z "${CONFIG_MAP[$PARAM]:-}" ]]; then
                    ConsoleError " ->" "process-task/param - $ID with unset parameter '$PARAM', set as '${CONFIG_MAP["FLAVOR"]}_$PARAM'"
                    RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} par-set::$PARAM"
                    SetArtifactStatus task $ID E
                else
                    case ${DMAP_PARAM_IS[$PARAM]:-} in
                        file)
                            if [[ "$(ProcessTaskTestFile "$PARAM" man $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        file-list)
                            if [[ "$(ProcessTaskTestFileList "$PARAM" man $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        dir)
                            if [[ "$(ProcessTaskTestDir "$PARAM" man $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        dir-list)
                            if [[ "$(ProcessTaskTestDirList "$PARAM" man $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        dir-cd)
                            if [[ "$(ProcessTaskTestDirCD "$PARAM" man $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        *)
                            FOUND=true
                            ;;
                    esac
                    if [[ $FOUND == true ]]; then
                        SetArtifactStatus task $ID S
                        RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} param"
#                         RTMAP_TASK_LOADED[$ID]=ok
                        ConsoleDebug "process-task/param - processed '$ID' for parameter '$PARAM' with success"
                    fi
                fi
            fi
        done
    fi

    if [[ ! -z "${DMAP_TASK_REQ_PARAM_OPT[$ID]:-}" ]]; then
        for PARAM in ${DMAP_TASK_REQ_PARAM_OPT[$ID]}; do
            FOUND=false
            ConsoleTrace "   $ID - param opt $PARAM"
            if [[ -z ${DMAP_PARAM_ORIGIN[$PARAM]:-} ]]; then
                ConsoleError " ->" "process-task/param - $ID unknown parameter '$PARAM'"
                RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} par-id::$PARAM"
                SetArtifactStatus task $ID E
            else
                RTMAP_REQUESTED_PARAM[$PARAM]=$PARAM
                if [[ -z "${CONFIG_MAP[$PARAM]:-}" ]]; then
                    ConsoleWarnStrict " ->" "process-task/param - $ID with unset parameter '$PARAM'"
                    if [[ "${CONFIG_MAP["STRICT"]}" == "on" ]]; then
                        RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} par-set::$PARAM"
                        SetArtifactStatus task $ID E
                    else
                        SetArtifactStatus task $ID W
                        RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} param"
#                         RTMAP_TASK_LOADED[$ID]=ok
                        ConsoleDebug "process-task/param - processed '$ID' for parameter '$PARAM' with warn"
                    fi
                else
                    case ${DMAP_PARAM_IS[$PARAM]:-} in
                        file)
                            if [[ "$(ProcessTaskTestFile "$PARAM" opt $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        file-list)
                            if [[ "$(ProcessTaskTestFileList "$PARAM" opt $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        dir)
                            if [[ "$(ProcessTaskTestDir "$PARAM" opt $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        dir-list)
                            if [[ "$(ProcessTaskTestDirList "$PARAM" opt $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                            ;;
                        dir-cd)
                            if [[ "$(ProcessTaskTestDirCD "$PARAM" opt $ID)" == "0" ]]; then
                                FOUND=true
                            fi
                                ;;
                        *)
                            FOUND=true
                            ;;
                    esac
                    if [[ $FOUND ]]; then
                        SetArtifactStatus task $ID S
                        RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} param"
#                         RTMAP_TASK_LOADED[$ID]=ok
                        ConsoleDebug "process-task/param - processed '$ID' for parameter '$PARAM' with success"
                    else
                        RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} par-set::$PARAM"
                        SetArtifactStatus task $ID E
                    fi
                fi
            fi
        done
    fi
}



##
## function: TestDependency
## - tests a dependency
## $1: dependency-id
##
TestDependency() {
    local DEP=$1

    RTMAP_REQUESTED_DEP[$DEP]=[$DEP]
    if [[ "${RTMAP_DEP_TESTED[$DEP]:-}" == "ok" ]]; then
        ConsoleDebug "process-task/dep - dependency '$DEP' already tested"
    else
        ConsoleDebug "process-task/dep - testing dependency '$DEP'"
        local COMMAND=${DMAP_DEP_CMD[$DEP]}
        if [[ "${COMMAND:0:1}" == "/" ]];then
            if [[ -n "$($COMMAND)" ]]; then
                RTMAP_DEP_TESTED[$DEP]="ok"
                SetArtifactStatus dep $DEP S
            else
                SetArtifactStatus dep $DEP E
            fi
        else
            if [[ -x "$(command -v $COMMAND)" ]]; then
                RTMAP_DEP_TESTED[$DEP]="ok"
                SetArtifactStatus dep $DEP S
            else
                SetArtifactStatus dep $DEP E
            fi
        fi
    fi
}



##
## function: ProcessTaskReqDep
## - tests all required dependencies for a task
## $1: task id
##
ProcessTaskReqDep() {
    local ID=$1
    local DEP

    if [[ ! -z "${DMAP_TASK_REQ_DEP_MAN[$ID]:-}" ]]; then
        for DEP in ${DMAP_TASK_REQ_DEP_MAN[$ID]}; do
            ConsoleTrace "   $ID - dep man $DEP"
            if [[ -z ${DMAP_DEP_ORIGIN[$DEP]:-} ]]; then
                ConsoleError " ->" "process-task/dep - $ID unknown dependency '$DEP'"
                RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} dep-id::$DEP"
                SetArtifactStatus task $ID E
            else
                TestDependency $DEP
                if [[ "${RTMAP_DEP_TESTED[$DEP]:-}" == "ok" ]]; then
                    SetArtifactStatus task $ID S
                    RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} dep"
#                     RTMAP_TASK_LOADED[$ID]=ok
                    ConsoleDebug "process-task/dep - processed '$ID' for dependency '$DEP' with success"
                else
                    ConsoleError " ->" "process-task/dep - $ID dependency '$DEP' not found"
                    RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} dep-cmd::$DEP"
                    SetArtifactStatus task $ID E
                fi
            fi
        done
    fi

    if [[ ! -z "${DMAP_TASK_REQ_DEP_OPT[$ID]:-}" ]]; then
        for DEP in ${DMAP_TASK_REQ_DEP_OPT[$ID]}; do
            ConsoleTrace "   $ID - dep opt $DEP"
            if [[ -z ${DMAP_DEP_ORIGIN[$DEP]:-} ]]; then
                ConsoleError " ->" "process-task/dep - $ID unknown dependency '$DEP'"
                RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} dep-id::$DEP"
                SetArtifactStatus task $ID E
            else
                TestDependency $DEP
                if [[ "${RTMAP_DEP_TESTED[$DEP]:-}" == "ok" ]]; then
                    SetArtifactStatus task $ID S
                    RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} dep"
#                     RTMAP_TASK_LOADED[$ID]=ok
                    ConsoleDebug "process-task/dep - processed '$ID' for dependency '$DEP' with success"
                else
                    ConsoleWarnStrict " ->" "process-task/dep - $ID dependency '$DEP' not found"
                    if [[ "${CONFIG_MAP["STRICT"]}" == "on" ]]; then
                        RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} dep-cmd::$DEP"
                        SetArtifactStatus task $ID E
                    else
                        SetArtifactStatus task $ID W
                        RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} dep"
#                         RTMAP_TASK_LOADED[$ID]=ok
                        ConsoleDebug "process-task/dep - processed '$ID' for dependency '$DEP' with warn"
                    fi
                fi
            fi
        done
    fi
}


##
## function: ProcessTaskReqTask
## - tests all required tasks for a task
## ! does not test against unloaded tasks!
## $1: task id
##
ProcessTaskReqTask() {
    local ID=$1
    local TASK

    if [[ ! -z "${DMAP_TASK_REQ_TASK_MAN[$ID]:-}" ]]; then
        for TASK in ${DMAP_TASK_REQ_TASK_MAN[$ID]}; do
            ConsoleTrace "   $ID - task man $TASK"
            if [[ -z ${DMAP_TASK_ORIGIN[$TASK]:-} ]]; then
                ConsoleError " ->" "process-task/task - $ID unknown task '$TASK'"
                RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} task-id::$TASK"
                SetArtifactStatus task $ID E
            else
                if [[ ! -z "${RTMAP_TASK_UNLOADED[$TASK]:-}" ]]; then
                    ConsoleError " ->" "process-task/task - $ID with unloaded task '$TASK'"
                    RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} task-set::$TASK"
                    SetArtifactStatus task $ID E
                else
                    SetArtifactStatus task $ID S
                    RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} task"
#                     RTMAP_TASK_LOADED[$ID]=ok
                    ConsoleDebug "process-task/task - processed '$ID' for task '$TASK' with success"
                fi
            fi
        done
    fi

    if [[ ! -z "${DMAP_TASK_REQ_TASK_OPT[$ID]:-}" ]]; then
        for TASK in ${DMAP_TASK_REQ_TASK_OPT[$ID]}; do
            ConsoleTrace "   $ID - task opt $TASK"
            if [[ -z ${DMAP_TASK_ORIGIN[$TASK]:-} ]]; then
                ConsoleError " ->" "process-task/task - $ID unknown task '$TASK'"
                RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} task-id::$TASK"
                SetArtifactStatus task $ID E
            else
                if [[ ! -z "${RTMAP_TASK_UNLOADED[$TASK]:-}" ]]; then
                    ConsoleWarnStrict " ->" "process-task/task - $ID with unloaded task '$TASK'"
                    if [[ "${CONFIG_MAP["STRICT"]}" == "on" ]]; then
                        RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} task-set::$TASK"
                        SetArtifactStatus task $ID E
                    else
                        SetArtifactStatus task $ID W
                        RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} task"
#                         RTMAP_TASK_LOADED[$ID]=ok
                        ConsoleDebug "process-task/task - processed '$ID' for task '$TASK' with warn"
                    fi
                else
                    SetArtifactStatus task $ID S
                    RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} task"
#                     RTMAP_TASK_LOADED[$ID]=ok
                    ConsoleDebug "process-task/task - processed '$ID' for task '$TASK' with success"
                fi
            fi
        done
    fi
}



##
## function: ProcessTaskReqDir
## - tests all required directories for a task
## $1: task id
##
ProcessTaskReqDir() {
    local ID=$1
    local DIR

    if [[ ! -z "${DMAP_TASK_REQ_DIR_MAN[$ID]:-}" ]]; then
        for DIR in ${DMAP_TASK_REQ_DIR_MAN[$ID]}; do
            ConsoleTrace "   $ID - dir man $DIR"
            if [[ ! -d $DIR ]]; then
                ConsoleError " ->" "process-task/dir - $ID not a directory '$DIR'"
                RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} dir::$DIR"
                SetArtifactStatus task $ID E
            else
                SetArtifactStatus task $ID S
                RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} dir"
#                 RTMAP_TASK_LOADED[$ID]=ok
                ConsoleDebug "process-task/dir - processed '$ID' for directory '$DIR' with success"
            fi
        done
    fi

    if [[ ! -z "${DMAP_TASK_REQ_DIR_OPT[$ID]:-}" ]]; then
        for DIR in ${DMAP_TASK_REQ_DIR_OPT[$ID]}; do
            ConsoleTrace "   $ID - dir opt $DIR"
            if [[ ! -d $DIR ]]; then
                ConsoleWarnStrict " ->" "process-task/dir - $ID not a directory '$DIR'"
                if [[ "${CONFIG_MAP["STRICT"]}" == "on" ]]; then
                    RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} dir::$DIR"
                    SetArtifactStatus task $ID E
                else
                    SetArtifactStatus task $ID W
                    RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} dir"
#                     RTMAP_TASK_LOADED[$ID]=ok
                    ConsoleDebug "process-task/dir - processed '$ID' for directory '$DIR' with warn"
                fi
            else
                SetArtifactStatus task $ID S
                RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} dir"
#                 RTMAP_TASK_LOADED[$ID]=ok
                ConsoleDebug "process-task/dir - processed '$ID' for directory '$DIR' with success"
            fi
        done
    fi
}



##
## function: ProcessTaskReqFile
## - tests all required files for a task
## $1: task id
##
ProcessTaskReqFile() {
    local ID=$1
    local FILE

    if [[ ! -z "${DMAP_TASK_REQ_FILE_MAN[$ID]:-}" ]]; then
        for FILE in ${DMAP_TASK_REQ_FILE_MAN[$ID]}; do
            ConsoleTrace "   $ID - file man $FILE"
            if [[ ! -f $FILE ]]; then
                ConsoleError " ->" "process-task/file - $ID not a file '$FILE'"
                RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} file::$FILE"
                SetArtifactStatus task $ID E
            else
                SetArtifactStatus task $ID S
                RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} file"
#                 RTMAP_TASK_LOADED[$ID]=ok
                ConsoleDebug "process-task/file - processed '$ID' for file '$FILE' with success"
            fi
        done
    fi

    if [[ ! -z "${DMAP_TASK_REQ_FILE_OPT[$ID]:-}" ]]; then
        for FILE in ${DMAP_TASK_REQ_FILE_OPT[$ID]}; do
            ConsoleTrace "   $ID - file opt $FILE"
            if [[ ! -f $FILE ]]; then
                ConsoleWarnStrict " ->" "process-task/file - $ID not a file '$FILE'"
                if [[ "${CONFIG_MAP["STRICT"]}" == "on" ]]; then
                    RTMAP_TASK_UNLOADED[$ID]="${RTMAP_TASK_UNLOADED[$ID]:-} file::$FILE"
                    SetArtifactStatus task $ID E
                else
                    SetArtifactStatus task $ID W
                    RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} file"
#                     RTMAP_TASK_LOADED[$ID]=ok
                    ConsoleDebug "process-task/file - processed '$ID' for file '$FILE' with warn"
                fi
            else
                SetArtifactStatus task $ID S
                RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} file"
#                 RTMAP_TASK_LOADED[$ID]=ok
                ConsoleDebug "process-task/file - processed '$ID' for file '$FILE' with success"
            fi
        done
    fi
}



##
## function: ProcessTasks
## - process all tasks
##
ProcessTasks() {
    ConsoleResetErrors
    ConsoleInfo "-->" "process tasks"

    local ID
    local PARAM

    ## initialize the status maps
    for ID in "${!DMAP_DEP_ORIGIN[@]}"; do
         RTMAP_DEP_STATUS[$ID]="N"
    done
    for ID in "${!DMAP_TASK_ORIGIN[@]}"; do
        RTMAP_TASK_STATUS[$ID]="N"
    done

    ## run for decl, params, dep, dir, file first
    local LOAD_TASK
    for ID in "${!DMAP_TASK_ORIGIN[@]}"; do
        LOAD_TASK=false
        if [[ "${CONFIG_MAP["APP_MODE"]}" == "all" ]]; then
            LOAD_TASK=true
        else 
            case ${DMAP_TASK_MODES[$ID]} in
                *${CONFIG_MAP["APP_MODE"]}*)
                    LOAD_TASK=true
                    ;;
            esac
        fi

        if [[ $LOAD_TASK == true ]]; then
            RTMAP_TASK_LOADED[$ID]="${RTMAP_TASK_LOADED[$ID]:-} mode"
#            RTMAP_TASK_LOADED[$ID]=ok
            ConsoleDebug "process-task/mode - processed '$ID' for mode with success"
            SetArtifactStatus task $ID S

            ProcessTaskReqParam $ID
            ProcessTaskReqDep $ID
            ProcessTaskReqDir $ID
            ProcessTaskReqFile $ID
        else
            ConsoleDebug "task '$ID' not defined for current mode '${CONFIG_MAP["APP_MODE"]}', not loaded"
            SetArtifactStatus task $ID N
        fi
    done

    ## run for tasks again
    for ID in "${!DMAP_TASK_ORIGIN[@]}"; do
        case ${DMAP_TASK_MODES[$ID]} in
            *${CONFIG_MAP["APP_MODE"]}*)
                ProcessTaskReqTask $ID
                ;;
        esac
    done

    ## now remove all tasks from RTMAP_TASK_LOADED that are in RTMAP_TASK_UNLOADED
    for ID in "${!RTMAP_TASK_UNLOADED[@]}"; do
        if [[ ! -z "${RTMAP_TASK_LOADED[$ID]:-}" ]]; then
            unset RTMAP_TASK_LOADED[$ID]
        fi
    done

    ## remove any setting in CONFIG_MAP that should not be there
    ## - default value loaded but not requested
    for ID in ${!CONFIG_MAP[@]}; do                                         ## for every setting
        if [[ ! -z "${DMAP_PARAM_DEFVAL[$ID]:-}" ]]; then                   ## if is from parameter that has a default value
            if [[ "${CONFIG_SRC[$ID]:-}" == "D" ]]; then                    ## if the setting is from default value, i.e. not environment or file
                if [[ -z ${RTMAP_REQUESTED_PARAM[$ID]:-} ]]; then           ## if the parameter is NOT required by any task (and not file/directory in next line)
                    case ${DMAP_PARAM_IS[$ID]:-} in
                        file | dir | dir-cd | file-list | dir-list)         ## if parameter is file or directory
                            unset CONFIG_MAP['$ID']                             ## then remove it
                            unset CONFIG_SRC['$ID']                             ## and the source note
                            ;;
                    esac
                fi
            fi
        fi
    done

    ConsoleInfo "-->" "done"
}
