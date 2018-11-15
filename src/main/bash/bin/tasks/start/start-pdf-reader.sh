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
## start-pdf-reader - starts a pdfreader with an optional FILE
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.1
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##

## put bugs into errors, safer
set -o errexit -o pipefail -o noclobber -o nounset


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
FILE=


##
## set CLI options and parse CLI
##
CLI_OPTIONS=hf:
CLI_LONG_OPTIONS=help,file:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name start-pdf-reader -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "start-pdf-reader: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "start-pdf-reader")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help    "<none>"    "print help screen and exit"        $PRINT_PADDING
                BuildTaskHelpLine f file    "FILE"      "PDF file to open in reader"        $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -f | --file)
            FILE="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "start-pdf-reader: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
##
## ready to go
##
############################################################################################
ERRNO=0
ConsoleInfo "  -->" "spr: starting task"

if [[ -z "${CONFIG_MAP["PDF_READER"]:-}" ]]; then
    ConsoleError "  ->" "spr: no setting for PDF_READER, cannot start any"
    ConsoleInfo "  -->" "spr: done"
    exit 60
fi
if [[ ! -n "$FILE" ]]; then
    ConsoleError "  ->" "spr: empty file? - '$FILE'"
    ConsoleInfo "  -->" "spr: done"
    exit 61
fi
FILE=$(PathToSystemPath $FILE)
if [[ ! -r "$FILE" ]]; then
    ConsoleError "  ->" "spr: cannot read file '$FILE'"
    ConsoleInfo "  -->" "spr: done"
    exit 62
fi

SCRIPT=${CONFIG_MAP["PDF_READER"]}
SCRIPT=${SCRIPT//%FILE%/$FILE}
$SCRIPT &
ERRNO=$?

ConsoleInfo "  -->" "spr: done"
exit $ERRNO
