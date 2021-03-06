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
## Framework Loader
## - initializes all settings
## - tests for settings and runtime dependencies
## - creates settings array and exports to file
## - starts the shell for interactive use or runs the shell with a scenario
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##


##
## check fundamental dependencies
## - bash 4 required
## - advanced getop required
## - no point to continue if we cant get time stamps (date)
## - exit with codes 300-302 on errors
##
#tag::fundamental[]
if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then
    printf " ==> no bash version >4, required for associative arrays, see error code 300\n\n"
    exit 300
fi
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    printf " ==> getopt failed, required for command line parsing, see error code 301\n\n"
    exit 301
fi
if [[ ! $(command -v date) ]]; then
    printf " ==> did not find 'date', required by loader, see error code 302\n\n"
    exit 302
fi
#end::fundamental[]



##
## set safe bash environment
##
#tag::safe-bash[]
set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar
#end::safe-bash[]



##
## some early settings
## - get timestamp
## - get rid of this option and avoid the annoying "Picked Up..." message in Java
#tag::set-early[]
_ts=$(date +%s.%N)
unset JAVA_TOOL_OPTIONS
#end::set-early[]



##
## test core dependencies
## - exit with codes 303-399 if we did not find a core dependency
##
#tag::core-dep[]

if [[ ! $(command -v dirname) ]]; then
    printf " ==> did not find 'dirname', required by loader, see error code 303\n\n"
    exit 303
fi
if [[ ! $(command -v pwd) ]]; then
    printf " ==> did not find 'pwd', required by loader, see error code 304\n\n"
    exit 304
fi
if [[ ! $(command -v uname) ]]; then
    printf " ==> did not find 'uname', required by loader, see error code 305\n\n"
    exit 305
fi
if [[ ! $(command -v cut) ]]; then
    printf " ==> did not find 'cut', required by loader, see error code 306\n\n"
    exit 306
fi
if [[ ! $(command -v cat) ]]; then
    printf " ==> did not find 'cat', required by loader, see error code 307\n\n"
    exit 307
fi
if [[ ! $(command -v mkdir) ]]; then
    printf " ==> did not find 'mkdir', required by loader, see error code 308\n\n"
    exit 308
fi
if [[ ! $(command -v bc) ]]; then
    printf " ==> did not find 'bc', required by loader, see error code 309\n\n"
    exit 309
fi
if [[ ! $(command -v mktemp) ]]; then
    printf " ==> did not find 'mktemp', required by loader, see error code 310\nn\n"
    exit 310
fi
if [[ ! $(command -v ls) ]]; then
    printf " ==> did not find 'ls', required by loader, see error code 311\n\n"
    exit 311
fi
if [[ ! $(command -v wc) ]]; then
    printf " ==> did not find 'wc', required by loader, see error code 312\n\n"
    exit 312
fi
if [[ ! $(command -v tput) ]]; then
    printf " ==> did not find 'tput', required by loader, see error code 313\n\n"
    exit 313
fi
if [[ ! $(command -v less) ]]; then
    printf " ==> did not find 'less', required by loader, see error code 314\n\n"
    exit 314
fi
if [[ ! $(command -v rm) ]]; then
    printf " ==> did not find 'rm', required by loader, see error code 315\n\n"
    exit 315
fi
if [[ ! $(command -v sort) ]]; then
    printf " ==> did not find 'sort', required by shell, see error code 316\n\n"
    exit 316
fi
#end::core-dep[]



#sed - mvn-site



##
## core framework settings
##
#tag::core-settings[]
if [[ -z ${FW_HOME:-} ]]; then
    FW_HOME=$(dirname $0)
    FW_HOME=$(cd $FW_HOME/../.. && pwd)
fi
#end::core-settings[]



##
## CONFIG_MAP and CONFIG_SRC
##
#tag::config-map[]
declare -A CONFIG_MAP
declare -A CONFIG_SRC

CONFIG_MAP["FW_HOME"]=$FW_HOME
export FW_HOME
CONFIG_MAP["RUNNING_IN"]="loader"
CONFIG_MAP["SYSTEM"]=$(uname -s | cut -c1-6)
CONFIG_MAP["CONFIG_FILE"]="$HOME/.skb"
CONFIG_MAP["STRICT"]=off
CONFIG_MAP["APP_MODE"]=use
CONFIG_MAP["APP_MODE_FLAVOR"]=std
CONFIG_MAP["PRINT_MODE"]=ansi

CONFIG_MAP["LOADER_LEVEL"]="error"
CONFIG_MAP["SHELL_LEVEL"]="error"
CONFIG_MAP["TASK_LEVEL"]="error"

CONFIG_MAP["LOADER_QUIET"]="off"
CONFIG_MAP["SHELL_QUIET"]="off"
CONFIG_MAP["TASK_QUIET"]="off"

CONFIG_MAP["SCENARIO_PATH"]=""
CONFIG_MAP["SHELL_SNP"]="off"
#end::config-map[]



##
## core includes
##
#tag::core-includes[]
source $FW_HOME/bin/loader/declare/_include
source $FW_HOME/bin/api/_include
source $FW_HOME/bin/loader/init/parse-cli.sh
#end::core-includes[]



##
## set flavor and application settings from calling script
## - exit with code 20: if no flavor set, not setting found (internal error)
## - exit with code 21: if no FLAVOR_HOME set
## - exit with code 22: if FLAVOR_HOME not a directoy
## - exit with code 23: if application script name is missing
## - exit with code 24: if application name is missing
## - exit with code 25: if framework version file is missing
## - exit with code 26: if application version file is missing
##
#tag::flavor-app[]
if [[ -z ${__FW_LOADER_FLAVOR:-} ]]; then
    ConsolePrint fatal "internal error: no flavor set"
    printf "\n"
    exit 20
else
    CONFIG_MAP["FLAVOR"]=$__FW_LOADER_FLAVOR
    CONFIG_SRC["FLAVOR"]="E"
    if [[ -z ${CONFIG_MAP["FLAVOR"]} ]]; then
        ## did not find FLAVOR
        ConsolePrint fatal "internal error: did not find setting for flavor"
        printf "\n"
        exit 21
    fi

    FLAVOR_HOME="${CONFIG_MAP["FLAVOR"]}_HOME"
    CONFIG_MAP["APP_HOME"]=${!FLAVOR_HOME:-}
    CONFIG_SRC["APP_HOME"]="E"
    if [[ -z ${CONFIG_MAP["APP_HOME"]:-} ]]; then
        ConsolePrint fatal "did not find environment setting for application home, tried \$${CONFIG_MAP["FLAVOR"]}_HOME"
        printf "\n"
        exit 21
    elif [[ ! -d ${CONFIG_MAP["APP_HOME"]} ]]; then
        ## found home, but is no directory
        ConsolePrint fatal "\$${CONFIG_MAP["FLAVOR"]}_HOME set as ${CONFIG_MAP["APP_HOME"]} does not point to a directory"
        printf "\n"
        exit 22
    fi
fi

if [[ -z ${__FW_LOADER_SCRIPTNAME:-} ]]; then
    ConsolePrint fatal "internal error: no application script name set"
    printf "\n"
    exit 23
else
    CONFIG_MAP["APP_SCRIPT"]=${__FW_LOADER_SCRIPTNAME##*/}
fi
if [[ -z "${__FW_LOADER_APPNAME:-}" ]]; then
    ConsolePrint fatal "internal error: no application name set"
    printf "\n"
    exit 24
else
    CONFIG_MAP["APP_NAME"]=$__FW_LOADER_APPNAME
fi

if [[ -f ${CONFIG_MAP["FW_HOME"]}/etc/version.txt ]]; then
    CONFIG_MAP["FW_VERSION"]=$(cat ${CONFIG_MAP["FW_HOME"]}/etc/version.txt)
else
    ConsolePrint fatal "no framework version found, tried \$FW_HOME/etc/version.txt"
    printf "\n"
    exit 25
fi
if [[ -f ${CONFIG_MAP["APP_HOME"]}/etc/version.txt ]]; then
    CONFIG_MAP["APP_VERSION"]=$(cat ${CONFIG_MAP["APP_HOME"]}/etc/version.txt)
else
    ConsolePrint fatal "no application version found, tried \$APP_HOME/etc/version.txt"
    printf "\n"
    exit 26
fi
#end::flavor-app[]



##
## test and create temporary directory
## - exit with code 30: if directory could not created (and does not exist)
## - exit with code 31: if directory is not writeable
##
#tag::tmp-dir[]
if [[ ! -z ${TMP:-} ]]; then
    TMP_DIRECTORY=${TMP}/${CONFIG_MAP["APP_SCRIPT"]}
else
    TMP_DIRECTORY=${TMPDIR:-/tmp}/${CONFIG_MAP["APP_SCRIPT"]}
fi
if [[ ! -d $TMP_DIRECTORY ]]; then
    mkdir $TMP_DIRECTORY 2> /dev/null
    __errno=$?
    if [[ $__errno != 0 ]]; then
        ConsolePrint fatal "could not create temporary directory $TMP_DIRECTORY, please check owner and permissions"
        printf "\n"
        exit 30
    fi
fi
if [[ ! -w $TMP_DIRECTORY ]]; then
    ConsolePrint fatal "cannot write to temporary directory $TMP_DIRECTORY, please check owner and permissions"
    printf "\n"
    exit 31
fi
#end::tmp-dir[]



##
## sneak in CLI for application mode
##
#tag::sneak-cli[]
case "$@" in
    *"-D"* | *"--dev-mode"*)
        CONFIG_MAP["APP_MODE"]="dev"
        CONFIG_SRC["APP_MODE"]="O"
        ;;
    *"-B"* | *"--build-mode"*)
        CONFIG_MAP["APP_MODE"]="build"
        CONFIG_SRC["APP_MODE"]="O"
        ;;
    *"-A"* | *"--all-mode"*)
        CONFIG_MAP["APP_MODE"]="all"
        CONFIG_SRC["APP_MODE"]="O"
        ;;
esac
#end::sneak-cli[]



##
## declare and set parameters, from here on we have settings loaded
## - exit with code 32 on errors
##
#tag::param-decl[]
DeclareParameters
if $(ConsoleHas errors); then printf "\n"; exit 32; fi
source $FW_HOME/bin/loader/init/process-settings.sh
ProcessSettings
#end::param-decl[]



##
## declare options, then build and parse CLI
## - set some runtime values but don't call any options)
## - test mode
##
## - exit with code 33 if option declaration failed
## - exit with code 34 if parseCLI failed
##
#tag::opt-decl[]
if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/opt-decl.map ]]; then
    ConsolePrint info "declaring options from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/opt-decl.map
else
    DeclareOptions
    if $(ConsoleHas errors); then printf "\n"; exit 33; fi
fi
declare -A OPT_CLI_MAP
for ID in ${!DMAP_OPT_ORIGIN[@]}; do
    OPT_CLI_MAP[$ID]=false
done
#end::opt-decl[]

#tag::parse-cli[]
ParseCli $@
if $(ConsoleHas errors); then printf "\n"; exit 34; fi
case "${CONFIG_MAP["PRINT_MODE"]:-}" in
    adoc | ansi | man-adoc | text | text-anon)
        ConsolePrint info "found print mode '${CONFIG_MAP["PRINT_MODE"]}'"
        ;;
    *)
        CONFIG_MAP["PRINT_MODE"]=ansi
        CONFIG_SRC["PRINT_MODE"]=
        ConsolePrint warn "unknown print mode '${CONFIG_MAP["PRINT_MODE"]}', assuming 'ansi'"
        ;;
esac
#end::parse-cli[]



##
## check some immediate exit options first, process and exit
##
#tag::exit-options[]
if [[ ${OPT_CLI_MAP["clean-cache"]} != false ]]; then
    ConsolePrint info "cleaning cache and exit"
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
#end::exit-options[]



##
## declare elements: commands, error codes
## - exit with code 35 if command declaration failed
## - exit with code 36 if error code declaration failed
##
#tag::cmdec-decl[]
if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/cmd-decl.map ]]; then
    ConsolePrint info "declaring commands from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/cmd-decl.map
else
    DeclareCommands
    if $(ConsoleHas errors); then printf "\n"; exit 35; fi
fi
if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/ec-decl.map ]]; then
    ConsolePrint info "declaring error code from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/ec-decl.map
else
    DeclareErrorCode
    if $(ConsoleHas errors); then printf "\n"; exit 36; fi
fi
#end::cmdec-decl[]



##
## Declare elements: dependencies, tasks; check tasks
## - exit with code 40: if dependencies failed
## - exit with code 41: if tasks failed
## - exit with code 42: if task tests failed
##
#tag::dep-decl[]
if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/dep-decl.map ]]; then
    ConsolePrint info "declaring dependencies from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/dep-decl.map
else
    ConsolePrint info "declaring dependencies from source"
    DeclareDependencies
    if $(ConsoleHas errors); then printf "\n"; exit 40; fi
fi
#end::dep-decl[]

#tag::task-decl[]
if [[ -f ${CONFIG_MAP["CACHE_DIR"]}/task-decl.map ]]; then
    ConsolePrint info "declaring tasks from cache"
    source ${CONFIG_MAP["CACHE_DIR"]}/task-decl.map
else
    ConsolePrint info "declaring tasks from source"
    DeclareTasks
    if $(ConsoleHas errors); then printf "\n"; exit 41; fi
fi
source $FW_HOME/bin/loader/init/process-tasks.sh
ProcessTasks
if $(ConsoleHas errors); then printf "\n"; exit 42; fi
#end::task-decl[]



##
## Declare scenarios
## - exit with code 43: if declaration(s) failed
## - exit with code 44: if scenario tests failed
##
#tag::scn-decl[]
ConsolePrint info "declaring scenarios from source"
DeclareScenarios
if $(ConsoleHas errors); then printf "\n"; exit 43; fi
source $FW_HOME/bin/loader/init/process-scenarios.sh
ProcessScenarios
if $(ConsoleHas errors); then printf "\n"; exit 44; fi
#end::scn-decl[]



##
## test if all -LEVELS are set to correct values
## - exit with code 45: if loader level unknown
## - exit with code 46: if shell level unknown
## - exit with code 47: if task level unknown
##
#tag::set-levels[]
case "${CONFIG_MAP["LOADER_LEVEL"]}" in
    off | all | fatal | error | warn-strict | warn | info | debug | trace)
        ;;
    *)
        ConsolePrint error "unknown loader-level: ${CONFIG_MAP["LOADER_LEVEL"]}"
        printf "    use: off, all, fatal, error, warn-strict, warn, info, debug, trace\n\n"
        exit 45
        ;;
esac
case "${CONFIG_MAP["SHELL_LEVEL"]}" in
    off | all | fatal | error | warn-strict | warn | info | debug | trace)
        ;;
    *)
        ConsolePrint error "unknown shell-level: ${CONFIG_MAP["SHELL_LEVEL"]}"
        printf "    use: off, all, fatal, error, warn-strict, warn, info, debug, trace\n\n"
        exit 46
        ;;
esac
case "${CONFIG_MAP["TASK_LEVEL"]}" in
    off | all | fatal | error | warn-strict | warn | info | debug | trace)
        ;;
    *)
        ConsolePrint error "unknown task-level: ${CONFIG_MAP["TASK_LEVEL"]}"
        printf "    use: off, all, fatal, error, warn-strict, warn, info, debug, trace\n\n"
        exit 47
        ;;
esac
#end::set-levels[]



##
## do cli options
## - exit with code 48: on option errors
##
##
#tag::do-options[]
source $FW_HOME/bin/loader/init/do-options.sh
DoOptions
if $(ConsoleHas errors); then printf "\n"; exit 48; fi

if [[ $DO_EXIT == true ]]; then
    _te=$(date +%s.%N)
    _exec_time=$_te-$_ts
    ConsolePrint info "execution time: $(echo $_exec_time | bc -l) sec"
    ConsolePrint info "done"
    exit 0
fi
#end::do-options[]



##
## set temporary configuration file (used by shell and tasks)
## - write runtime configurations to temporary configuration file
##
#tag::tmp-file[]
CONFIG_MAP["FW_L1_CONFIG"]=$(mktemp "$TMP_DIRECTORY/$(date +"%H-%M-%S")-${CONFIG_MAP["APP_MODE"]}-XXX")
export FW_L1_CONFIG=${CONFIG_MAP["FW_L1_CONFIG"]}
WriteRuntimeConfig
#end::tmp-file[]



##
## test if we execute a task or run a scenario
##
#tag::tsk-scn[]
__errno=0
if [[ "${OPT_CLI_MAP["execute-task"]}" != false ]]; then
    echo ${OPT_CLI_MAP["execute-task"]} | $FW_HOME/bin/shell/shell.sh
    __et=$?
    __errno=$((__errno + __et))
fi
if [[ "${OPT_CLI_MAP["run-scenario"]}" != false ]]; then
    echo "execute-scenario ${OPT_CLI_MAP["run-scenario"]}" | $FW_HOME/bin/shell/shell.sh
    __et=$?
    __errno=$((__errno + __et))
    DO_EXIT_2=true
fi
#end::tsk-scn[]



##
## test if we can and should start the interactive shell
##
#tag::shell[]
if [[ ${DO_EXIT_2} == false ]]; then
    $FW_HOME/bin/shell/shell.sh
    __errno=$?
fi
#end::shell[]



##
## Remove artifacts (the shell-events just in case)
##
#tag::cleanup[]
if [[ -f $FW_L1_CONFIG ]]; then
    rm $FW_L1_CONFIG >& /dev/null
fi
if [[ -d $TMP_DIRECTORY && $(ls $TMP_DIRECTORY | wc -l) == 0 ]]; then
    rmdir $TMP_DIRECTORY
fi
#end::cleanup[]



##
## done
##
#tag::done[]
#ConsolePrint message "\n\n    have a nice day\n\n"
exit $__errno
#end::done[]
