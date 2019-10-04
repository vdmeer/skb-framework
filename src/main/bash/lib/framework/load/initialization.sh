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
## Init - main initialization script
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##

##
## Load only when framework is started, any behavior can happen if loaded afterwards!
## - any entry here MUST not produce errors, otherwise strange behavior will be experienced!
##


declare -r -x -g SF_VERSION="$(cat ${SF_HOME}/lib/framework/version.skb)"
SF_FILE_STRING="$(date +"%Y-%m-%d--%H-%M")--$$"

Add Object Configuration    RUNTIME_CONFIG_FAST     "/tmp/skb-${SF_FILE_STRING}-fast"           "runtime configuration file for fast changing settings"
Add Object Configuration    RUNTIME_CONFIG_MEDIUM   "/tmp/skb-${SF_FILE_STRING}-medium"         "runtime configuration file for medium changing settings"
Add Object Configuration    RUNTIME_CONFIG_SLOW     "/tmp/skb-${SF_FILE_STRING}-slow"           "runtime configuration file for slow chaning settings"
Add Object Configuration    RUNTIME_CONFIG_LOAD     "/tmp/skb-${SF_FILE_STRING}-load"           "runtime configuration file only written during load"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"
declare -r -x -g FW_RUNTIME_CONFIG_FAST="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}"

Add Object Configuration    HOME                    "${SF_HOME}"                                    "the framework's home directory"
Add Object Configuration    PID                     "$$"                                            "process ID of the load part, for log messages"
Add Object Configuration    FILE_STRING             "${SF_FILE_STRING}"                             "unique string for files, e.g. temporary and log files"
Add Object Configuration    VERSION                 "${SF_VERSION}"                                 "the framework's version, semantic string with major.minor.path"
Add Object Configuration    USER_CONFIG             "${HOME}/.skbrc"                                "file with user settings"
Add Object Configuration    PATTERN_REMOVE_ANSI     "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"   "SED pattern to remove ANSI escape codes from text"
Add Object Configuration    CACHE_DIR               "/var/cache/skb-framework/${SF_VERSION}"        "directory for cached data"
Add Object Configuration    DEFAULT_THEME           "Default"                                       "file with the default theme definitions"
Add Object Configuration    PAR_PARA                "j1s0f1"                                        "options for the 'par' command to format paragraphs"
Add Object Configuration    PAR_LIST                "P=*"                                           "options for the 'par' command to format lists"

system="$(uname -a)"
case ${system} in
    *CYGWIN*)       system=CYGWIN ;;
    *Microsoft*)    system=WSL ;;
    *Linux*)        system=Linux ;;
    *)              system="$(uname -s)" ;;
esac
Add Object Configuration    SYSTEM                  "${system}"                                     "identifier for the underlying operating system"


FW_INSTANCE_EXC_LONG["00"]="normal exit"
FW_INSTANCE_EXC_LONG["01"]="general error during initialization, load, or option processing" ## e.g. unknown print format set in CLI
FW_INSTANCE_EXC_LONG["02"]="wrong bash major version, requires minimum 4"
FW_INSTANCE_EXC_LONG["03"]="wrong bash minor version, requires minimum 2"
FW_INSTANCE_EXC_LONG["04"]="command 'realpath' not found"
FW_INSTANCE_EXC_LONG["05"]="\$SF_HOME does not exist or is not a directory"
FW_INSTANCE_EXC_LONG["06"]="did not find GNU (Extended) getopt"
FW_INSTANCE_EXC_LONG["07"]="missing core dependency core-utils"
FW_INSTANCE_EXC_LONG["08"]="missing important dependency"
#FW_INSTANCE_EXC_LONG["09"]="not used"
FW_INSTANCE_EXC_LONG["10"]="error while reading the set configuration file"
FW_INSTANCE_EXC_LONG["11"]="error while reading the default configuration file"
FW_INSTANCE_EXC_LONG["12"]="error loading settings from the environment"
FW_INSTANCE_EXC_LONG["13"]="error(s) executing task"
FW_INSTANCE_EXC_LONG["14"]="error(s) executing scenario"
FW_INSTANCE_EXC_LONG["15"]="requested command for execution not found"
FW_INSTANCE_EXC_LONG["16"]="error(s) executing command"


if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/formats.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/formats.cache"
else
    Add Object Format ansi          "${SF_HOME}/lib/text/formats" "text with ansi codes for colors and effects"
    Add Object Format plain         "${SF_HOME}/lib/text/formats" "plain text without any formatting"
    Add Object Format adoc          "${SF_HOME}/lib/text/formats" "ADCIIDOC formatted text"
    Add Object Format mdoc          "${SF_HOME}/lib/text/formats" "ADCIIDOC formatted text with special color encoding for the manual"
fi


if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/levels.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/levels.cache"
else
    Add Object Level fatalerror     "F"  "Fatal"    "${SF_HOME}/lib/text/levels" "a fatal problem that should lead to exit"
    Add Object Level error          "E"  "Error"    "${SF_HOME}/lib/text/levels" "a serious problem, recovery might be possible"
    Add Object Level text           "X"  "Text"     "${SF_HOME}/lib/text/levels" "simple text"
    Add Object Level message        "M"  "Message"  "${SF_HOME}/lib/text/levels" "a formatted messsage"
    Add Object Level warning        "W"  "Warning"  "${SF_HOME}/lib/text/levels" "a warning that should not impede further processing"
    Add Object Level info           "I"  "Info"     "${SF_HOME}/lib/text/levels" "information about a flow or process"
    Add Object Level debug          "D"  "Debug"    "${SF_HOME}/lib/text/levels" "detailed information about a flow of process"
    Add Object Level trace          "T"  "Trace"    "${SF_HOME}/lib/text/levels" "very detailed information about a flow or process"
fi


if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/messages.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/messages.cache"
else
    source ${SF_HOME}/lib/framework/load/messages.sh
fi


if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modes.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modes.cache"
else
    Add Object Mode all             "${SF_HOME}/lib/text/modes" "all modes are active"
    Add Object Mode test            "${SF_HOME}/lib/text/modes" "mode for testing framework and modules"
    Add Object Mode dev             "${SF_HOME}/lib/text/modes" "mode for development tasks"
    Add Object Mode build           "${SF_HOME}/lib/text/modes" "mode for build tasks"
    Add Object Mode use             "${SF_HOME}/lib/text/modes" "mode for use tasks"
fi


if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/phases.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/phases.cache"
else
    Add Object Phase Load           "${SF_HOME}/lib/text/phases" "load, from start to final settings"
    Add Object Phase CLI            "${SF_HOME}/lib/text/phases" "phase loading CLI options"
    Add Object Phase Default        "${SF_HOME}/lib/text/phases" "phase loading default values"
    Add Object Phase Env            "${SF_HOME}/lib/text/phases" "phase loading values from the environment"
    Add Object Phase File           "${SF_HOME}/lib/text/phases" "phase loading values from a file"
    Add Object Phase Project        "${SF_HOME}/lib/text/phases" "phase running targets on a project"
    Add Object Phase Scenario       "${SF_HOME}/lib/text/phases" "phase running tasks from a scenario"
    Add Object Phase Shell          "${SF_HOME}/lib/text/phases" "phase executing commands in the shell"
    Add Object Phase Task           "${SF_HOME}/lib/text/phases" "phase executing tasks"
    Add Object Phase Site           "${SF_HOME}/lib/text/phases" "phase running functions for a (Maven) site"
fi


if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themeitems.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themeitems.cache"
else
    source ${SF_HOME}/lib/framework/load/theme-items.sh
fi


if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes.cache"
else
    Add Object Theme Default "${SF_HOME}/share/themes" "the default theme"
    Add Object Theme API     "${SF_HOME}/share/themes" "empty theme for API themitem settings"
fi


FW_OBJECT_SET_LONG["CURRENT_PHASE"]="current execution phase"
FW_OBJECT_SET_PHA["CURRENT_PHASE"]=Load
FW_OBJECT_SET_VAL["CURRENT_PHASE"]=Load

Add Object Setting PRINT_FORMAT     ansi                    "standard format for text output"
Add Object Setting PRINT_FORMAT2    ""                      "secondary format, overwrites the standard format"
Add Object Setting LOG_FORMAT       ansi                    "standard format for log output"
Add Object Setting CURRENT_MODE     use                     "creates views on tasks and other elements"
Add Object Setting APP_NAME         sf                      "application name for messages"
Add Object Setting APP_NAME2        ""                      "secondary application name, overwrites the primary name"
Add Object Setting LOG_DATE_ARG     "--iso-8601=seconds"    "format for the date in logs, defaults to '--iso-8601=seconds'"
Add Object Setting STRICT_MODE      off                     "determines how strict-warnings are treated"
Add Object Setting ERROR_COUNT      0                       "number of errors found for current phase"
Add Object Setting WARNING_COUNT    0                       "number of warnings found for current phase"
Add Object Setting CURRENT_THEME    default                 "the current theme with settings for configurable output"

Add Object Setting PRINT_LEVEL      " fatalerror error warning "                "level for printing messages"
Add Object Setting LOG_LEVEL        " fatalerror error message text warning "   "level for printing lines to the log"

Add Object Setting CURRENT_TASK     ""                      "in execution, the task currently executed"
Add Object Setting LAST_TASK        ""                      "the last task that was executed"
Add Object Setting CURRENT_PROJECT  ""                      "in execution, the project currently executed"
Add Object Setting LAST_PROJECT     ""                      "the last project that was executed"
Add Object Setting CURRENT_SCENARIO ""                      "in execution, the scenario currently executed"
Add Object Setting LAST_SCENARIO    ""                      "the last scenario that was executed"
Add Object Setting CURRENT_SITE     ""                      "in execution, the site currently executed"
Add Object Setting LAST_SITE        ""                      "the last site that was executed"

Add Object Setting CONFIG_FILE      ""                      "configuration file read during initialization"
Add Object Setting MODULE_PATH      "${SF_HOME}/share/modules"  "list of directories to scan for loadable modules"
Add Object Setting AUTO_WRITE       false                       "settings write runtime file automatically (true) or manually (false)"
Add Object Setting AUTO_VERIFY      false                       "settings verify elements automatically (true) or manually (false)"

Add Object Setting LOG_DIR          /var/log/skb-framework/${SF_VERSION}    "directory for log files"
Add Object Setting LOG_FILE         ${SF_FILE_STRING}.log                   "file for log output"


Set current theme "${FW_OBJECT_CFG_VAL["DEFAULT_THEME"]}"
file="${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}"
if [[ ! -w ${file} ]]; then mkdir -p ${file%/*}; touch ${file}; fi

if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/options.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/options.cache"
else
    source ${SF_HOME}/lib/framework/load/options.sh
fi

Report process message "framework initialized"
