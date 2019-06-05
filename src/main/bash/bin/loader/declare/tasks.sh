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
## Declare: tasks
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



declare -A DMAP_TASK_ORIGIN             # map [id]=origin
declare -A DMAP_TASK_DECL               # map [id]=decl-file w/o .id ending
declare -A DMAP_TASK_SHORT              # map [id]=short-cmd
declare -A DMAP_TASK_EXEC               # map [id]=exec-script
declare -A DMAP_TASK_DESCR              # map [id]="descr-tag-line"
declare -A DMAP_TASK_MODES              # map [id]="modes"
declare -A DMAP_TASK_MODE_FLAVOR        # map [id]=flavor

declare -A DMAP_TASK_REQ_PARAM_MAN      # map [id]=(param-id, ...)
declare -A DMAP_TASK_REQ_PARAM_OPT      # map [id]=(param-id, ...)
declare -A DMAP_TASK_REQ_DEP_MAN        # map [id]=(dependency-id, ...)
declare -A DMAP_TASK_REQ_DEP_OPT        # map [id]=(dependency-id, ...)
declare -A DMAP_TASK_REQ_TASK_MAN       # map [id]=(task-id, ...)
declare -A DMAP_TASK_REQ_TASK_OPT       # map [id]=(task-id, ...)
declare -A DMAP_TASK_REQ_DIR_MAN        # map [id]=(dir, ...)
declare -A DMAP_TASK_REQ_DIR_OPT        # map [id]=(dir, ...)
declare -A DMAP_TASK_REQ_FILE_MAN       # map [id]=(file, ...)
declare -A DMAP_TASK_REQ_FILE_OPT       # map [id]=(file, ...)



##
## set dummies for the runtime maps, declare errors otherwise
##
DMAP_TASK_REQ_PARAM_MAN["DUMMY"]=dummy
DMAP_TASK_REQ_PARAM_OPT["DUMMY"]=dummy
DMAP_TASK_REQ_DEP_MAN["DUMMY"]=dummy
DMAP_TASK_REQ_DEP_OPT["DUMMY"]=dummy
DMAP_TASK_REQ_TASK_MAN["DUMMY"]=dummy
DMAP_TASK_REQ_TASK_OPT["DUMMY"]=dummy
DMAP_TASK_REQ_DIR_MAN["DUMMY"]=$FW_HOME
DMAP_TASK_REQ_DIR_OPT["DUMMY"]=$FW_HOME
DMAP_TASK_REQ_FILE_MAN["DUMMY"]=$FW_HOME/etc/version.txt
DMAP_TASK_REQ_FILE_OPT["DUMMY"]=$FW_HOME/etc/version.txt



##
## function TaskRequire
## - sets requirements for task, realizes DSL for tasks
## $1: task-id
## $2: requirement type, one of: param, dep, dir, file, task
## $3: requirement value, one of: param-id, dep-id, directory, file, task-id
## $4: warning, if set to anything
##
TaskRequire() {
    if [[ -z $1 ]]; then
        ConsolePrint error "task-require - no task ID given"
        return
    elif [[ -z $2 ]]; then
        ConsolePrint error "task-require - missing requirement type for task '$1'"
        return
    elif [[ -z $3 ]]; then
        ConsolePrint error "task-require - missing requirement value for task '$1'"
        return
    fi

    local ID=$1
    local TYPE=$2
    local VALUE=$3
    local OPTIONAL=${4:-}
    ConsolePrint debug "task $ID requires '$TYPE' value '$VALUE' option '$OPTIONAL'"

    if [[ -z $OPTIONAL ]]; then
        case "$TYPE" in
            param)  DMAP_TASK_REQ_PARAM_MAN[$ID]="${DMAP_TASK_REQ_PARAM_MAN[$ID]:-} $VALUE" ;;
            dep)    DMAP_TASK_REQ_DEP_MAN[$ID]="${DMAP_TASK_REQ_DEP_MAN[$ID]:-} $VALUE" ;;
            task)   DMAP_TASK_REQ_TASK_MAN[$ID]="${DMAP_TASK_REQ_TASK_MAN[$ID]:-} $VALUE" ;;
            dir)    DMAP_TASK_REQ_DIR_MAN[$ID]="${DMAP_TASK_REQ_DIR_MAN[$ID]:-} $VALUE" ;;
            file)   DMAP_TASK_REQ_FILE_MAN[$ID]="${DMAP_TASK_REQ_FILE_MAN[$ID]:-} $VALUE" ;;
            *)      ConsolePrint error "task-require -task $ID requires unknown type '$TYPE'" ;;
        esac
    else
        case "$TYPE" in
            param)  DMAP_TASK_REQ_PARAM_OPT[$ID]="${DMAP_TASK_REQ_PARAM_OPT[$ID]:-} $VALUE" ;;
            dep)    DMAP_TASK_REQ_DEP_OPT[$ID]="${DMAP_TASK_REQ_DEP_OPT[$ID]:-} $VALUE" ;;
            task)   DMAP_TASK_REQ_TASK_OPT[$ID]="${DMAP_TASK_REQ_TASK_OPT[$ID]:-} $VALUE" ;;
            dir)    DMAP_TASK_REQ_DIR_OPT[$ID]="${DMAP_TASK_REQ_DIR_OPT[$ID]:-} $VALUE" ;;
            file)   DMAP_TASK_REQ_FILE_OPT[$ID]="${DMAP_TASK_REQ_FILE_OPT[$ID]:-} $VALUE" ;;
            *)      ConsolePrint error "task-require -task $ID requires unknown type '$TYPE'" ;;
        esac
    fi
}



##
## function: DeclareTasksOrigin
## - declares tasks from origin
## $1: origin, CONFIG_MAP identifier, i.e. FW_HOME or APP_HOME
##
DeclareTasksOrigin() {
    local ORIGIN=$1

    ConsolePrint info "scanning $ORIGIN"
    local TASK_PATH=${CONFIG_MAP[$ORIGIN]}/${APP_PATH_MAP["TASK_DECL"]}
    if [[ ! -d $TASK_PATH ]]; then
        ConsolePrint warn "declare task - did not find task directory '$TASK_PATH' at origin '$ORIGIN'"
    else
        local ID
        local SHORT
        local EXECUTABLE
        local EXEC_PATH
        local MODES
        local MODE_FLAVOR
        local DESCRIPTION
        local NO_ERRORS=true
        local mode
        local files
        local file

        for file in $TASK_PATH/**/*.id; do
            if [ ! -f $file ]; then
                continue    ## avoid any strange file, and empty directory
            fi
            ID=${file##*/}
            ID=${ID%.*}

            local HAVE_ERRORS=false

            SHORT=
            EXEC_PATH=
            EXECUTABLE=
            MODES=
            MODE_FLAVOR=
            DESCRIPTION=
            source "$file"

            if [[ -z ${EXEC_PATH:-} ]]; then
                EXECUTABLE=${CONFIG_MAP[$ORIGIN]}/${APP_PATH_MAP["TASK_SCRIPT"]}/$ID.sh
            else
                EXECUTABLE=${CONFIG_MAP[$ORIGIN]}/$EXEC_PATH/$ID.sh
            fi
            if [[ ! -f $EXECUTABLE ]]; then
                ConsolePrint error "declare task - '$ID' without script (executable)"
                HAVE_ERRORS=true
            elif [[ ! -x $EXECUTABLE ]]; then
                ConsolePrint error "declare task - '$ID' script not executable"
                HAVE_ERRORS=true
            fi

            if [[ -z "${MODES:-}" ]]; then
                ConsolePrint error "declare task - '$ID' has no modes defined"
                HAVE_ERRORS=true
            else
                for mode in $MODES; do
                    case $mode in
                        dev | build | use)
                            ConsolePrint debug "task '$ID' found mode '$mode'"
                            ;;
                        *)
                            ConsolePrint error "declare task - '$ID' with unknown mode '$mode'"
                            HAVE_ERRORS=true
                            ;;
                    esac
                done
            fi

            if [[ -z "${MODE_FLAVOR:-}" ]]; then
                ConsolePrint error "declare task - '$ID' has no app mode flavor defined"
                HAVE_ERRORS=true
            else
                case $MODE_FLAVOR in
                    std | install)
                        ConsolePrint debug "task '$ID' found app mode flavor '$MODE_FLAVOR'"
                        ;;
                    *)
                        ConsolePrint error "declare task - '$ID' with unknown app mode flavor '$MODE_FLAVOR'"
                        HAVE_ERRORS=true
                        ;;
                esac
            fi

            if [[ -z "${DESCRIPTION:-}" ]]; then
                ConsolePrint error "declare task - '$ID' has no description"
                HAVE_ERRORS=true
            fi

            if [[ ! -z ${DMAP_CMD[$ID]:-} ]]; then
                ConsolePrint error "declare task - '$ID' already used as long shell command"
                HAVE_ERRORS=true
            fi
            if [[ ! -z ${DMAP_CMD[$SHORT]:-} ]]; then
                ConsolePrint error "declare task - '$ID' short '$SHORT' already used as long shell command"
                HAVE_ERRORS=true
            fi

            if [[ ! -z ${DMAP_CMD_SHORT[$ID]:-} ]]; then
                ConsolePrint error "declare task - task '$ID' already used as short shell command"
                HAVE_ERRORS=true
            fi
            if [[ ! -z ${DMAP_CMD_SHORT[$SHORT]:-} ]]; then
                ConsolePrint error "declare task - '$ID' short '$SHORT' already used as short shell command"
                HAVE_ERRORS=true
            fi

            if [[ ! -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
                ConsolePrint error "overwriting ${DMAP_TASK_ORIGIN[$ID]}:::$ID with $ORIGIN:::$ID"
                HAVE_ERRORS=true
            fi
            if [[ ! -z ${SHORT:-} && ! -z ${DMAP_TASK_SHORT[${SHORT:-}]:-} ]]; then
                ConsolePrint error "overwriting task short from ${DMAP_TASK_SHORT[$SHORT]} to $ID"
                HAVE_ERRORS=true
            fi
            if [[ $HAVE_ERRORS == true ]]; then
                ConsolePrint error "declare task - could not declare task"
                NO_ERRORS=false
            else
                DMAP_TASK_ORIGIN[$ID]=$ORIGIN
                DMAP_TASK_DECL[$ID]=${file%.*}
                DMAP_TASK_EXEC[$ID]=$EXECUTABLE
                DMAP_TASK_MODES[$ID]="$MODES"
                DMAP_TASK_MODE_FLAVOR[$ID]="$MODE_FLAVOR"
                DMAP_TASK_DESCR[$ID]="$DESCRIPTION"
                if [[ ! -z ${SHORT:-} ]]; then
                    DMAP_TASK_SHORT[$SHORT]=$ID
                    ConsolePrint info "declared $ORIGIN:::$ID with short '$SHORT'"
                else
                    ConsolePrint info "declared $ORIGIN:::$ID without short"
                fi
            fi
        done
    fi
}



##
## function: DeclareTasks
## - declares tasks from multiple sources
##
DeclareTasks() {
    ConsolePrint info "declare tasks"
    ResetCounter errors

    DeclareTasksOrigin FW_HOME
    if [[ "${CONFIG_MAP["FW_HOME"]}" != ${CONFIG_MAP["APP_HOME"]} ]]; then
        DeclareTasksOrigin APP_HOME
    fi
    ConsolePrint info "done"
}
