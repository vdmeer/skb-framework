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
## FW Loader
## - initializes all settings
## - tests for settings and runtime dependencies
## - creates settings array and exports to file
## - starts the shell for interactive use or runs the shell with a scenario
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##

## put bugs into errors, safer
set -o errexit -o pipefail -o noclobber -o nounset

## we want files recursivey
shopt -s globstar


## take start time
_ts=$(date +%s.%N)


##
## test for core requirements
## - test for BASH 4, if not found we cannot continue (we are using associative arrays)
## - test for getopt, we use it for command line argument parsing
## - test for bc, for time calculations
## - test for mktemp, required to create temporary files and directories
##
## - exit with code 12-15 if we did not find a core requirements
##
if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then
    printf " ==> no bash version >4, required for associative arrays\n\n"
    exit 12
fi
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    printf " ==> getopt failed, require for command line parsing\n\n"
    exit 13
fi
if [[ ! $(command -v bc) ]]; then
    printf " ==> did not find bc, require for calculations\n\n"
    exit 14
fi
if [[ ! $(command -v mktemp) ]]; then
    printf " ==> did not find mktemp, require to create temporary files and directories\n\n"
    exit 15
fi



##
## get rid of this option and avoid the annoying "Picked Up..." message
##
unset JAVA_TOOL_OPTIONS



##
## load framework, core declarations
##
FW_HOME=$(dirname $0)
FW_HOME=$(cd $FW_HOME/../.. && pwd)

source $FW_HOME/bin/loader/declare/_include
CONFIG_MAP["FW_HOME"]=$FW_HOME                      # home of the framework
export FW_HOME
CONFIG_MAP["RUNNING_IN"]="loader"                   # we are in the loader, shell/tasks will change this to "shell" or "task"
CONFIG_MAP["SYSTEM"]=$(uname -s | cut -c1-6)        # set system, e.g. for Cygwin path conversions
CONFIG_MAP["CONFIG_FILE"]="$HOME/.skb"              # config file, in user's home directory
CONFIG_MAP["STRICT"]=off                            # not strict, yet (change with --strict)
CONFIG_MAP["LOADER-LEVEL"]="error"                  # output level for loader, change with --loader-level, set to "debug" for early code debugging
CONFIG_MAP["SHELL-LEVEL"]="error"                   # output level for shell, change with --shell-level
CONFIG_MAP["TASK-LEVEL"]="error"                    # output level for tasks, change with --task-level
CONFIG_MAP["APP_MODE"]=use                          # default application mode is use, change with --app-mode
CONFIG_MAP["PRINT_MODE"]=ansi                       # default print mode is ansi, change with --print-mode

source $FW_HOME/bin/functions/_include
ConsoleResetErrors
ConsoleResetWarnings



##
## do includes, source required script files
##
source $FW_HOME/bin/functions/describe/_include
source $FW_HOME/bin/loader/init/parse-cli.sh



##
## set flavor and application settings from calling script
## - exit with code 16: if no flavor set, not setting found (internal error)
## - exit with code 17: if no FLAOVOR_HOME set
## - exit with code 18: if FLAOVOR_HOME not a directoy
## - exit with code 20: if application script name is missing
## - exit with code 21: if application name is missing
## - exit with code 22: if version file is missing
##
if [[ -z ${__FW_LOADER_FLAVOR:-} ]]; then
    ConsoleFatal " ->" "interal error: no flavor set"
    printf "\n"
    exit 16
else
    CONFIG_MAP["FLAVOR"]=$__FW_LOADER_FLAVOR
    CONFIG_SRC["FLAVOR"]="E"
    if [[ -z ${CONFIG_MAP["FLAVOR"]} ]]; then
        ## did not find FLAVOR
        ConsoleFatal " ->" "internal error: did not find setting for flavor"
        printf "\n"
        exit 16
    fi

    FLAVOR_HOME="${CONFIG_MAP["FLAVOR"]}_HOME"
    CONFIG_MAP["HOME"]=${!FLAVOR_HOME:-}
    CONFIG_SRC["HOME"]="E"
    if [[ -z ${CONFIG_MAP["HOME"]:-} ]]; then
        ConsoleFatal " ->" "did not find environment setting for application home, tried \$${CONFIG_MAP["FLAVOR"]}_HOME"
        printf "\n"
        exit 17
    elif [[ ! -d ${CONFIG_MAP["HOME"]} ]]; then
        ## found home, but is no directory
        ConsoleFatal " ->" "\$${CONFIG_MAP["FLAVOR"]}_HOME set as ${CONFIG_MAP["HOME"]} does not point to a directory"
        printf "\n"
        exit 18
    fi
fi
export FLAVOR_HOME=${CONFIG_MAP["HOME"]}

if [[ -z ${__FW_LOADER_SCRIPTNAME:-} ]]; then
    ConsoleFatal " ->" "interal error: no application script name set"
    printf "\n"
    exit 20
else
    CONFIG_MAP["APP_SCRIPT"]=${__FW_LOADER_SCRIPTNAME##*/}
fi
if [[ -z "${__FW_LOADER_APPNAME:-}" ]]; then
    ConsoleFatal " ->" "interal error: no application name set"
    printf "\n"
    exit 21
else
    CONFIG_MAP["APP_NAME"]=$__FW_LOADER_APPNAME
fi
source $FW_HOME/bin/loader/declare/app-maps.sh
if [[ -f ${CONFIG_MAP["HOME"]}/etc/version.txt ]]; then
    CONFIG_MAP["VERSION"]=$(cat ${CONFIG_MAP["HOME"]}/etc/version.txt)
else
    ConsoleFatal " ->" "no application version found, tried \$HOME/etc/version.txt"
    printf "\n"
    exit 22
fi



##
## test and create temporary directory
## - exit with code 23: if directory could not created (and does not exist)
## - exit with code 24: if directory is not writeable
##
if [[ ! -z ${TMP:-} ]]; then
    TMP_DIRECTORY=${TMP}/${CONFIG_MAP["APP_SCRIPT"]}
else
    TMP_DIRECTORY=${TMPDIR:-/tmp}/${CONFIG_MAP["APP_SCRIPT"]}
fi
if [[ ! -d $TMP_DIRECTORY ]]; then
    mkdir $TMP_DIRECTORY 2> /dev/null
    __errno=$?
    if [[ $__errno != 0 ]]; then
        ConsoleFatal " ->" "could not create temporary directory $TMP_DIRECTORY, please check owner and permissions"
        printf "\n"
        exit 23
    fi
fi
if [[ ! -w $TMP_DIRECTORY ]]; then
    ConsoleFatal " ->" "cannot write to temporary directory $TMP_DIRECTORY, please check owner and permissions"
    printf "\n"
    exit 24
fi



##
## sneak in CLI for application mode
##
case "$@" in
    *"-D"*)
        CONFIG_MAP["APP_MODE"]="dev"
        CONFIG_SRC["APP_MODE"]="O"
        ;;
    *"-B"*)
        CONFIG_MAP["APP_MODE"]="build"
        CONFIG_SRC["APP_MODE"]="O"
        ;;
    *"-A"*)
        CONFIG_MAP["APP_MODE"]="all"
        CONFIG_SRC["APP_MODE"]="O"
        ;;
esac



##
## declare and set parameters, from here on we have setting stuff loaded
## - exit with code 25 on errors
##
DeclareParameters
if ConsoleHasErrors; then printf "\n"; exit 25; fi
source $FW_HOME/bin/loader/init/process-settings.sh
ProcessSettings



##
## declare options, then build and parse CLI
## - set some runtime values but don't call any options)
## - test mode
##
## - exit with code 26 if option declaration failed
## - exit with code 27 if parseCLI failed
##
if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/opt-decl.map ]]; then
    ConsoleInfo "-->" "declaring options from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/opt-decl.map
else
    DeclareOptions
    if ConsoleHasErrors; then printf "\n"; exit 26; fi
fi
declare -A OPT_CLI_MAP
for ID in ${!DMAP_OPT_ORIGIN[@]}; do
    OPT_CLI_MAP[$ID]=false
done

ParseCli $@
if ConsoleHasErrors; then printf "\n"; exit 27; fi
case "${CONFIG_MAP["PRINT_MODE"]:-}" in
    ansi | text | adoc)
        ConsoleInfo "-->" "found print mode '${CONFIG_MAP["PRINT_MODE"]}'"
        ;;
    *)
        CONFIG_MAP["PRINT_MODE"]=ansi
        CONFIG_SRC["PRINT_MODE"]=
        ConsoleWarn "-->" "unknown print mode '${CONFIG_MAP["PRINT_MODE"]}', assuming 'ansi'"
        ;;
esac
## sneak on clean-cache to prevent errors here starting the clean
if [[ ${OPT_CLI_MAP["clean-cache"]} != false ]]; then
    ConsoleInfo "-->" "cleaning cache and exit"
    source ${CONFIG_MAP["FW_HOME"]}/bin/loader/options/clean-cache.sh
    exit 0
fi
if [[ ${OPT_CLI_MAP["help"]} != false ]]; then
    source ${CONFIG_MAP["FW_HOME"]}/bin/loader/options/help.sh
    exit 0
fi
if [[ ${OPT_CLI_MAP["version"]} != false ]]; then
    source ${CONFIG_MAP["FW_HOME"]}/bin/loader/options/version.sh
    exit 0
fi



##
## declare shell artifacts: commands, error codes
## - exit with code 28 if command declaration failed
## - exit with code 29 if error-code declaration failed
##
if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/cmd-decl.map ]]; then
    ConsoleInfo "-->" "declaring commands from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/cmd-decl.map
else
    DeclareCommands
    if ConsoleHasErrors; then printf "\n"; exit 28; fi
fi
# if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/ec-decl.map ]]; then
#     ConsoleInfo "-->" "declaring error-codes from cache"
#     source ${CONFIG_MAP["CACHE_DIR"]}/ec-decl.map
# else
#     DeclareErrorCodes
#     if ConsoleHasErrors; then printf "\n"; exit 29; fi
# fi



##
## Declare core artifacts: dependencies, tasks; check tasks
## - exit with code 30: if dependencies failed
## - exit with code 31: if tasks failed
## - exit with code 32: if task tests failed
##
if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/dep-decl.map ]]; then
    ConsoleInfo "-->" "declaring dependencies from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/dep-decl.map
else
    ConsoleInfo "-->" "declaring dependencies from source"
    DeclareDependencies
    if ConsoleHasErrors; then printf "\n"; exit 30; fi
fi

if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/task-decl.map ]]; then
    ConsoleInfo "-->" "declaring tasks from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/task-decl.map
else
    ConsoleInfo "-->" "declaring tasks from source"
    DeclareTasks
    if ConsoleHasErrors; then printf "\n"; exit 31; fi
fi
source $FW_HOME/bin/loader/init/process-tasks.sh
ProcessTasks
if ConsoleHasErrors; then printf "\n"; exit 32; fi



##
## Declare scenarios
## - exit with code 33: if declaration(s) failed
##
# if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/scn-decl.map ]]; then
#     ConsoleInfo "-->" "declaring scenarios from cache"
#     source ${CONFIG_MAP["CACHE_DIR"]}/scn-decl.map
# else
#     ConsoleInfo "-->" "declaring scenarios from source"
#     DeclareScenarios
#     if ConsoleHasErrors; then printf "\n"; exit 33; fi
# fi



##
## test if all -LEVELS are set to correct values
## - exit with code 34: if loader level unknown
## - exit with code 35: if shell level unknown
## - exit with code 36: if task level unknown
##
case "${CONFIG_MAP["LOADER-LEVEL"]}" in
    off | all | fatal | error | warn-strict | warn | info | debug | trace)
        ;;
    *)
        ConsoleError "-->" "unknown loader-level: ${CONFIG_MAP["LOADER-LEVEL"]}"
        printf "    use: off, all, fatal, error, warn-strict, warn, info, debug, trace\n\n"
        exit 34
        ;;
esac
case "${CONFIG_MAP["SHELL-LEVEL"]}" in
    off | all | fatal | error | warn-strict | warn | info | debug | trace)
        ;;
    *)
        ConsoleError "-->" "unknown shell-level: ${CONFIG_MAP["SHELL-LEVEL"]}"
        printf "    use: off, all, fatal, error, warn-strict, warn, info, debug, trace\n\n"
        exit 35
        ;;
esac
case "${CONFIG_MAP["TASK-LEVEL"]}" in
    off | all | fatal | error | warn-strict | warn | info | debug | trace)
        ;;
    *)
        ConsoleError "-->" "unknown task-level: ${CONFIG_MAP["TASK-LEVEL"]}"
        printf "    use: off, all, fatal, error, warn-strict, warn, info, debug, trace\n\n"
        exit 36
        ;;
esac



##
## do cli options
## - exit with code 37: on option errors
##
##
source $FW_HOME/bin/loader/init/do-options.sh
DoOptions
if ConsoleHasErrors; then printf "\n"; exit 37; fi

if [[ $DO_EXIT == true ]]; then
    _te=$(date +%s.%N)
    _exec_time=$_te-$_ts
    ConsoleInfo "-->" "execution time: $(echo $_exec_time | bc -l) sec"
    ConsoleInfo "-->" "done"
    exit 0
fi



##
## set temporary configuration file (used by shell and tasks)
## - write runtime configurations to temporary configuration file
##
CONFIG_MAP["FW_L1_CONFIG"]=$(mktemp "$TMP_DIRECTORY/$(date +"%H-%M-%S")-${CONFIG_MAP["APP_MODE"]}-XXX")
export FW_L1_CONFIG=${CONFIG_MAP["FW_L1_CONFIG"]}
WriteL1Config



##
## test if we execute a task or run a scenario
##
__errno=0
if [[ "${OPT_CLI_MAP["execute-task"]}" != false ]]; then
    echo ${OPT_CLI_MAP["execute-task"]} | $FW_HOME/bin/shell/shell.sh
    __et=$?
    __errno=$((__errno + __et))
fi
if [[ "${OPT_CLI_MAP["run-scenario"]}" != false ]]; then
    echo "es ${OPT_CLI_MAP["run-scenario"]}" | $FW_HOME/bin/shell/shell.sh
   __et=$?
    __errno=$((__errno + __et))
fi

if [[ ${DO_EXIT_2} == false ]]; then
    $FW_HOME/bin/shell/shell.sh
    __errno=$?
fi


##
## Remove artifacts (the shell-events just in case)
##
if [[ -f $FW_L1_CONFIG ]]; then
    rm $FW_L1_CONFIG >& /dev/null
fi
if [[ -d $TMP_DIRECTORY && $(ls $TMP_DIRECTORY | wc -l) == 0 ]]; then
    rmdir $TMP_DIRECTORY
fi

ConsoleMessage "\n\nhave a nice day\n\n\n"
exit $__errno

