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
## manual - shows the manual in various versions
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
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
##
source $FW_HOME/bin/api/_include


##
## set local variables
##
FILTER=
ALL=false
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AcdefhiP:
CLI_LONG_OPTIONS=all,help,print-mode:
CLI_LONG_OPTIONS+=,adoc,ansi,html,manp,pdf,text,text-anon

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name manual -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "manual: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -A | --all)
            ALL=true
            CLI_SET=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "manual")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                            $PRINT_PADDING
                printf "\n   filters\n"
                BuildTaskHelpLine A        all       "<none>"    "all manual versions"                              $PRINT_PADDING
                BuildTaskHelpLine "<none>" adoc      "<none>"    "ADOC manual"                                      $PRINT_PADDING
                BuildTaskHelpLine "<none>" ansi      "<none>"    "text manual with ansi colors andeffects"          $PRINT_PADDING
                BuildTaskHelpLine "<none>" html      "<none>"    "HTML manual"                                      $PRINT_PADDING
                BuildTaskHelpLine "<none>" manp      "<none>"    "manual page ${CONFIG_MAP["APP_SCRIPT"]}(1)"       $PRINT_PADDING
                BuildTaskHelpLine "<none>" pdf       "<none>"    "PDF manual"                                       $PRINT_PADDING
                BuildTaskHelpLine "<none>" text      "<none>"    "plain text manual"                                $PRINT_PADDING
                BuildTaskHelpLine "<none>" text-anon "<none>"    "annotated text manual"                            $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        --adoc)
            FILTER=$FILTER" adoc"
            CLI_SET=true
            shift
            ;;
        --ansi)
            FILTER=$FILTER" ansi"
            CLI_SET=true
            shift
            ;;
        --html)
            FILTER=$FILTER" html"
            CLI_SET=true
            shift
            ;;
        --manp)
            FILTER=$FILTER" manp"
            CLI_SET=true
            shift
            ;;
        --pdf)
            FILTER=$FILTER" pdf"
            CLI_SET=true
            shift
            ;;
        --text)
            FILTER=$FILTER" text"
            CLI_SET=true
            shift
            ;;
        --text-anon)
            FILTER=$FILTER" text-anon"
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "manual: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI
############################################################################################
if [[ $ALL == true ]]; then
    FILTER="adoc anon ansi text manp html pdf"
fi
if [[ $CLI_SET == false ]]; then
    FILTER=${CONFIG_MAP["PRINT_MODE"]}
fi



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "man: starting task"

for fil in $FILTER; do
    case "$fil" in
        adoc | ansi | text | text-anon)
            if [[ -f ${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.$fil ]]; then
                set +e
                tput smcup
                clear
                less -r -C -f -M -d "${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.$fil"
                tput rmcup
                set -e
            else
                ConsolePrint error "man: did not find manual file: ${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.$fil"
            fi
            ;;
        html)
            if [[ -f ${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.html ]]; then
                if [[ ! -z "${RTMAP_TASK_LOADED["start-browser"]}" ]]; then
                    set +e
                    ${DMAP_TASK_EXEC["start-browser"]} --url file://$(PathToSystemPath ${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.html)
                    set -e
                else
                    ConsolePrint error "man/html: cannot test, task 'start-browser' not loaded"
                fi
            else
                ConsolePrint error "man: did not find manual file: ${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.html"
            fi
            ;;
        manp)
            if [[ -f ${CONFIG_MAP["APP_HOME"]}/man/man1/${CONFIG_MAP["APP_SCRIPT"]}.1 ]]; then
                set +e
                man -M ${CONFIG_MAP["APP_HOME"]}/man ${CONFIG_MAP["APP_SCRIPT"]}
                set -e
            else
                ConsolePrint error "man: did not find manual file: ${CONFIG_MAP["APP_HOME"]}/man/man1/${CONFIG_MAP["APP_SCRIPT"]}.1"
            fi
            ;;
        pdf)
            if [[ -f ${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.pdf ]]; then
                if [[ ! -z "${RTMAP_TASK_LOADED["start-pdf-viewer"]}" ]]; then
                    set +e
                    ${DMAP_TASK_EXEC["start-pdf-viewer"]} --file ${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.pdf
                    set -e
                else
                    ConsolePrint error "man/pdf: cannot show PDF manual, task 'start-pdf-viewer' not loaded"
                fi
            else
                ConsolePrint error "man: did not find manual file: ${CONFIG_MAP["APP_HOME"]}/doc/manual/${CONFIG_MAP["APP_SCRIPT"]}.pdf"
            fi
            ;;
    esac
done

ConsolePrint info "man: done"
exit $TASK_ERRORS
