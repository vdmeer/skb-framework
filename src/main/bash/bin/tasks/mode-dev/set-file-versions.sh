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
## set-file-versions - sets version information in source file comments
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##

## put bugs into errors, safer
set -o errexit -o pipefail -o noclobber -o nounset

## we want files recursivey
shopt -s globstar



##
## Test if we are run from parent with configuration
## - load configuration
##
if [[ -z ${FW_HOME:-} || -z ${FW_L1_CONFIG-} ]]; then
    printf " ==> please run from framework or application\n\n"
    exit 50
fi
source $FW_L1_CONFIG
CONFIG_MAP["RUNNING_IN"]="task"


##
## load main functions
## - reset errors and warnings
##
source $FW_HOME/bin/api/_include
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
BUILD_FILE=false
DIRECTORY=false
MACRO_FILE=false
NEW_VERSION=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=b:d:hm:v:
CLI_LONG_OPTIONS=build-file:,directory:,help,macro-file:,version:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name set-file-versions -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "set-file-versions: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "set-file-versions")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine b build-file      "FILE"      "ANT build file"                            $PRINT_PADDING
                BuildTaskHelpLine d directory       "DIR"       "start directory with source files"         $PRINT_PADDING
                BuildTaskHelpLine h help            "<none>"    "print help screen and exit"                $PRINT_PADDING
                BuildTaskHelpLine m macro-file      "FILE"      "ANT macro file"                            $PRINT_PADDING
                BuildTaskHelpLine v version         "VERSION"   "new version string"                        $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -b | --build-file)
            BUILD_FILE=$2
            shift 2
            ;;
        -d | --directory)
            DIRECTORY=$2
            shift 2
            ;;
        -m | --macro-file)
            MACRO_FILE=$2
            shift 2
            ;;
        -v | --version)
            NEW_VERSION=$2
            shift 2
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "set-file-versions: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI and settings
############################################################################################
if [[ "${RTMAP_DEP_STATUS["ant"]}" != "S" ]]; then
    ConsoleError "  ->" "sfv: dependency Ant not loaded, cannot proceed"
    exit 60
fi

if [[ ${BUILD_FILE} == false ]]; then
    BUILD_FILE=${CONFIG_MAP["VERSIONS_BUILD_FILE"]}
fi
if [[ ${MACRO_FILE} == false ]]; then
    MACRO_FILE=${CONFIG_MAP["VERSIONS_MACRO_FILE"]}
fi
if [[ ${NEW_VERSION} == false ]]; then
    NEW_VERSION=${CONFIG_MAP["APP_VERSION"]}
fi

if [[ ${DIRECTORY} == false ]]; then
    ConsoleError " ->" "sfv: a start directory is required, none set"
    exit 61
elif [[ ! -d ${DIRECTORY} ]]; then
    ConsoleError " ->" "sfv: did not find directory: '${DIRECTORY}'"
    exit 62
else
    ORIG_DIR=$DIRECTORY
    DIRECTORY=$(PathToSystemPath $DIRECTORY)
fi
if [[ ! -f ${BUILD_FILE} ]]; then
    ConsoleError " ->" "sfv: did not find build file: '${BUILD_FILE}'"
    exit 63
else
    BUILD_FILE=$(PathToSystemPath $BUILD_FILE)
fi
if [[ ! -f ${MACRO_FILE} ]]; then
    ConsoleError " ->" "sfv: did not find macro file: '${MACRO_FILE}'"
    exit 64
else
    MACRO_FILE=$(PathToSystemPath $MACRO_FILE)
fi



############################################################################################
##
## ready to go
##
############################################################################################
ConsoleInfo "  -->" "sfv: starting task"
ConsoleResetErrors

echo $BUILD_FILE
echo $DIRECTORY
echo $NEW_VERSION
echo $MACRO_FILE
(cd $ORIG_DIR; ant -f ${BUILD_FILE} -DmoduleVersion=${NEW_VERSION} -DmoduleDir=${DIRECTORY} -DmacroFile=${MACRO_FILE})

ConsoleInfo "  -->" "sfv: done"
exit $TASK_ERRORS
