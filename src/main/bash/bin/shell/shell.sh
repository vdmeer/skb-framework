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
## Framework Interactive Shell
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##
## NOTE: do not remove lines that start with "#tag::" or "#end::"
## - the lines mark import regions for AsciiDoctor includes
## - they are used in the documentation, e.g. the Developer Guide
##

##
## basic options / settings
## l1 - changes bugs into errors, safer
##
#tag::init[]
set -o errexit -o pipefail -o noclobber -o nounset
#end::init[]


##
## Test if we are run from parent with configuration
## - load configuration
##
#tag::test-parent[]
if [[ -z ${FW_HOME:-} || -z ${FW_L1_CONFIG-} ]]; then
    printf " ==> please run from framework or application\n\n"
    exit 40
fi
source $FW_L1_CONFIG
CONFIG_MAP["RUNNING_IN"]="shell"
#end::test-parent[]



##
## load main functions
## - reset errors and warnings
##
#tag::include[]
source $FW_HOME/bin/api/_include
source $FW_HOME/bin/api/describe/task.sh
source $FW_HOME/bin/shell/history.sh

ConsoleResetErrors
ConsoleResetWarnings
ConsoleMessage "\n"
#end::include[]



##
## initialize variables
##
#tag::settings[]
SCMD=                           # a shell-command from input
SARG=                           # argument(s), if any, for a shell command
STIME=                          # time a command was entered
RELOAD_CFG=false                # flag to reload configuration, e.g. after a change of settings
declare -A HISTORY              # the shell's history of executed commands
HISTORY[-1]="help"              # dummy first entry, size calculation doesn't seem to work otherwise
#end::settings[]



##
## function: FWInterpreter
## - takes a command and runs it
##
#tag::fwi-start[]
FWInterpreter() {
    case "$SCMD" in
        # ...
#end::fwi-start[]
#tag::fwi-es[]
        execute-scenario | es)
            printf "\n    execute-scenario/rs requires a scenario as argument\n\n"
            ;;
        "execute-scenario "*)
            SARG=${SCMD#*execute-scenario }
            ExecuteScenario $SARG
            ShellAddCmdHistory
            ;;
        "es "*)
            SARG=${SCMD#*es }
            ExecuteScenario $SARG
            ShellAddCmdHistory
            ;;
#end::fwi-es[]

#tag::fwi-cls[]
        clear-screen | "clear-screen "* | cls | "cls "*)
            printf "\033c"
            ShellAddCmdHistory
            ;;
#end::fwi-cls[]

#tag::fwi-time[]
        time | "time "* | T | "T "*)
            printf "\n    %s\n\n" "$STIME"
            ShellAddCmdHistory
            ;;
#end::fwi-time[]

#tag::fwi-cfg[]
        configuration | "configuration "* | c | "c "*)
            ${DMAP_TASK_EXEC["list-configuration"]}
            ShellAddCmdHistory
            ;;
#end::fwi-cfg[]

#tag::fwi-stats[]
        statistic | "statistic "* | s | "s "*)
            ${DMAP_TASK_EXEC["statistics"]}
            ShellAddCmdHistory
            ;;
#end::fwi-stats[]

#tag::fwi-tasks[]
        tasks | "tasks "* | t | "t "*)
            ${DMAP_TASK_EXEC["list-tasks"]}
            ShellAddCmdHistory
            ;;
#end::fwi-tasks[]

#tag::fwi-tasks-application[]
        tasks-application | "tasks-application "* | ta | "ta "*)
            ${DMAP_TASK_EXEC["list-tasks"]} --origin app
            ShellAddCmdHistory
            ;;
#end::fwi-tasks-application[]

#tag::fwi-comment[]
        "" | "#" | "#"* | "# "*)
            ;;
#end::fwi-comment[]

#tag::fwi-other[]
        *)
            SARG="$SCMD"
            ExecuteTask "$SARG"
            ShellAddCmdHistory

            case "$SCMD" in
                "set "* | "setting "*) RELOAD_CFG=true;;
            esac
            ;;
#end::fwi-other[]
#tag::fwi-end[]
    esac
}
#end::fwi-end[]



##
## function: FWShell
## - the main shell, takes input from STDIN and runs the commands
## - uses FWInterpreter for some commands
##
#tag::fws-start[]
FWShell() {
    while read -a args; do
        SCMD="${args[@]:-}" <&3
        STIME=$(date +"%T")
        case "$SCMD" in
            # ...
#end::fws-start[]
#tag::fws-help[]
            help | h | "?")
                cat ${CONFIG_MAP["FW_HOME"]}/etc/help/commands.${CONFIG_MAP["PRINT_MODE"]}
                ;;
#end::fws-help[]
#tag::fws-history[]
            !*)
                SARG=${SCMD#*!}
                ShellCmdHistory
                ;;
            history*)
                SARG=${SCMD#*history}
                ShellCmdHistory
                ;;
#end::fws-history[]
#tag::fws-exit[]
            exit | quit | q | bye)
                break
                ;;
#end::fws-exit[]
#tag::fws-other[]
            *)
                FWInterpreter
                ;;
#end::fws-other[]
#tag::fws-end[]
        esac

        if [[ $RELOAD_CFG == true ]]; then
            source $FW_L1_CONFIG
            CONFIG_MAP["RUNNING_IN"]="shell"
            RELOAD_CFG=false
        fi
        if ConsoleIsPrompt; then ConsoleMessage "${CONFIG_MAP["SHELL_PROMPT"]}"; fi
    done
}
#end::fws-end[]



##
## call the shell
## - redirect input to #3 while running the shell
##
#tag::run[]
exec 3</dev/tty || exec 3<&0
if ConsoleIsPrompt; then ConsoleMessage "${CONFIG_MAP["SHELL_PROMPT"]}"; fi
FWShell
exec 3<&-
#end::run[]
