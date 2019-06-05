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
## build-mvn-site - builds one or more Maven sites
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
## - reset errors and warnings
##
source $FW_HOME/bin/api/_include
ResetCounter errors
ResetCounter warnings


##
## set local variables
##
DO_BUILD=false
DO_CLEAN=false
DO_LIST=false
DO_TEST=false

ALL=
SITE_ID=
TARGETS=""
PROFILE=


##
## set CLI options and parse CLI
##
CLI_OPTIONS=Abchi:ltT
CLI_LONG_OPTIONS=all,build,clean,help,id:,list,test
CLI_LONG_OPTIONS+=,ad,site,stage,profile:,targets

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name build-mvn-site -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "build-mvn-site: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=24
while true; do
    case "$1" in
        -A | --all)
            ALL=yes
            shift
            ;;
        -b | --build)
            shift
            DO_BUILD=true
            ;;
        -c | --clean)
            DO_CLEAN=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "build-mvn-site")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine b build   "<none>"    "builds site(s), requires a target and site ID or all"      $PRINT_PADDING
                BuildTaskHelpLine c clean   "<none>"    "cleans all site(s)"                                        $PRINT_PADDING
                BuildTaskHelpLine h help    "<none>"    "print help screen and exit"                                $PRINT_PADDING
                BuildTaskHelpLine l list    "<none>"    "list sites"                                                $PRINT_PADDING
                BuildTaskHelpLine T test    "<none>"    "test sites, open in browser"                               $PRINT_PADDING

                printf "\n   targets\n"
                BuildTaskHelpLine t        targets  "<none>"    "mvn: all targets"                  $PRINT_PADDING
                BuildTaskHelpLine "<none>" ad       "<none>"    "mvn: site:attach-descriptor"       $PRINT_PADDING
                BuildTaskHelpLine "<none>" site     "<none>"    "mvn: site"                         $PRINT_PADDING
                BuildTaskHelpLine "<none>" stage    "<none>"    "mvn: site:stage"                   $PRINT_PADDING

                printf "\n   filters\n"
                BuildTaskHelpLine A all     "<none>"    "all sites"                                                 $PRINT_PADDING
                BuildTaskHelpLine i id      "ID"        "site identifier for building"                              $PRINT_PADDING

                printf "\n   Maven options\n"
                BuildTaskHelpLine "<none>" profile  PROFILE     "mvn: use profile PROFILE"          $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -i | --id)
            SITE_ID="$2"
            shift 2
            ;;
        -l | --list)
            DO_LIST=true
            shift
            ;;
        -T | --test)
            shift
            DO_TEST=true
            ;;


        -t | --targets)
            TARGETS="ad site stage"
            shift
            ;;
        --ad)
            TARGETS+=" ad"
            shift
            ;;
        --site)
            TARGETS+=" site"
            shift
            ;;
        --stage)
            TARGETS+=" stage"
            shift
            ;;
        --profile)
            PROFILE=$2
            shift 2
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "build-mvn-site: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI and settings
############################################################################################
if [[ "${RTMAP_DEP_STATUS["maven"]}" != "S" ]]; then
    ConsolePrint error "bdms: dependency Maven not loaded, cannot proceed"
    exit 60
fi
if [[ -z "${CONFIG_MAP["MVN_SITES"]:-}" ]]; then
    ConsolePrint error "bdms: no settings found for MVN_SITES, cannot proceed"
    exit 61
fi



############################################################################################
## load site functions
############################################################################################
LoadSite(){
    local ID
    local DESCRIPTION

    if [[ ! -d "$1" ]]; then
        ConsolePrint error "bdms: not a directory: '$1'"
        return
    fi
    if [[ ! -f "$1/skb-site.id" ]]; then
        ConsolePrint error "bdms: no ID file in directory: '$1', looking for 'skb-site'"
        return
    fi
    if [[ ! -f "$1/pom.xml" ]]; then
        ConsolePrint error "bdms: no POM file in directory: '$1'"
        return
    fi
    source $1/skb-site.id

    if [[ -z "${ID:-}" ]]; then
        ConsolePrint error "bdms: no ID in 'skb-ts' in directory '$1'"
        return
    fi
    if [[ -z "${DESCRIPTION:-}" ]]; then
        ConsolePrint error "bdms: no DESCRIPTION in 'skb-ts' in directory '$1'"
        return
    fi

    MVN_SITE_LIST[$ID]=$DESCRIPTION
    MVN_SITE_PATH[$ID]=$1

    ConsolePrint debug "found site '$ID' described as '$DESCRIPTION'"
}



############################################################################################
## build site function
############################################################################################
BuildSite(){
    local HAVE_SCRIPTS=false
    local FILE_NAME
    local CHANGE
    local ERRORS
    declare -A MVN_SITE_FIX_ADOC_ARRAY

    if [[ -r ${MVN_SITE_PATH[$1]}/skb-site-scripts.skb ]]; then
        source ${MVN_SITE_PATH[$1]}/skb-site-scripts.skb
        HAVE_SCRIPTS=true
    fi

    ConsolePrint debug "build site $1 :: $MVN_TARGET :: in ${MVN_SITE_PATH[$1]}\n\n"

    if [[ $HAVE_SCRIPTS == true ]]; then
        ConsolePrint debug "running MvnSitePreScript"
        (cd ${MVN_SITE_PATH[$1]}; MvnSitePreScript)
        ConsolePrint debug "done MvnSitePreScript\n"
        ExitOnTaskErrors
    fi

    ConsolePrint debug "running mvn $MVN_TARGET"
    (cd ${MVN_SITE_PATH[$1]}; mvn $MVN_TARGET)
    ConsolePrint debug "done mvn $MVN_TARGET\n"

    if [[ -v MVN_SITE_FIX_ADOC_ARRAY[@] ]]; then
        ConsolePrint debug "running ADOC fix for ${#MVN_SITE_FIX_ADOC_ARRAY[@]} files (MVN_SITE_FIX_ADOC_ARRAY)"
        for FILE_NAME in ${!MVN_SITE_FIX_ADOC_ARRAY[@]}; do
            ConsolePrint trace "MvnSiteFixAdocArray: fixing file $FILE_NAME"
            ERRORS=$TASK_ERRORS
            TestFS "$FILE_NAME.html" file exists,read,write "mvn-adoc-fix"
            if (( $ERRORS == $TASK_ERRORS )); then
                CHANGE="${MVN_SITE_FIX_ADOC_ARRAY[$FILE_NAME]}"
                ConsolePrint trace "MvnSiteFixAdoc: fixing title"
                sed -i.bak 's%x2013; </title>%'"x2013; $CHANGE</title>"'%g' $FILE_NAME.html
                rm $FILE_NAME.html.bak
                ConsolePrint trace "MvnSiteFixAdoc: fixing breadcrumbs"
                sed -i.bak 's%<li class="active "></li>%'"<li class=\"active \">${CHANGE}</li>"'%g' $FILE_NAME.html
                rm $FILE_NAME.html.bak
            fi
        done
        ConsolePrint debug "done ADOC fix\n"
        ExitOnTaskErrors
    else
        ConsolePrint debug "ADOC: fix not required, MVN_SITE_FIX_ADOC_ARRAY is empty\n"
    fi

    if [[ $HAVE_SCRIPTS == true ]]; then
        ConsolePrint debug "running MvnSitePostScript"
        (cd ${MVN_SITE_PATH[$1]}; MvnSitePostScript)
        ConsolePrint debug "done MvnSitePostScript\n"
        ExitOnTaskErrors
    fi

    case "$TARGETS" in
        *"stage"*)
            ConsolePrint debug "running mvn initialize site:stage"
            (cd ${MVN_SITE_PATH[$1]}; mvn initialize site:stage)
            ConsolePrint debug "done mvn initialize site:stage"
            ;;
    esac

    unset MVN_SITE_FIX_ADOC_ARRAY
}



############################################################################################
## test site function
############################################################################################
TestSite(){
    if [[ ! -z "${RTMAP_TASK_LOADED["start-browser"]}" ]]; then
        if [[ -f ${MVN_SITE_PATH[$1]}/target/site/index.html ]]; then
            set +e
            ${DMAP_TASK_EXEC["start-browser"]} --url file://$(PathToSystemPath ${MVN_SITE_PATH[$1]}/target/site/index.html)
            set -e
        else
            ConsolePrint error "bdms/test: no index file - ${MVN_SITE_PATH[$1]}/target/site/index.html"
        fi
    else
        ConsolePrint error "bdms/test: cannot test, task 'start-browser' not loaded"
    fi
}



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "bdms: starting task"
ResetCounter errors

declare -A MVN_SITE_LIST
declare -A MVN_SITE_PATH
for site in ${CONFIG_MAP["MVN_SITES"]}; do
    LoadSite $site
done

if [[ $DO_LIST == true ]]; then
    printf "\n  Sites\n"
    for ID in ${!MVN_SITE_LIST[@]}; do
        printf "   %s - %s - %s\n" "$ID" "${MVN_SITE_LIST[$ID]}" "${MVN_SITE_PATH[$ID]}"
    done
    printf "\n"
fi

if [[ $DO_CLEAN == true ]]; then
    for ID in ${!MVN_SITE_LIST[@]}; do
        ConsolePrint debug "clean site $ID\n\n"
        (cd ${MVN_SITE_PATH[$ID]}; mvn clean)
        ConsolePrint debug "\n\n"
    done
fi

if [[ $DO_BUILD == true ]]; then
    MVN_TARGET="initialize"
    case "$TARGETS" in
        *"ad"*)     MVN_TARGET+=" "site:attach-descriptor;;
    esac
    case "$TARGETS" in
        *"site"*)     MVN_TARGET+=" "site;;
    esac
    if [[ -n "$MVN_TARGET" ]]; then
        if [[ "$ALL" == "yes" ]]; then
            ConsolePrint info "building all sites"
            for ID in ${!MVN_SITE_LIST[@]}; do
                BuildSite $ID
            done
        elif [[ -n "$SITE_ID" ]]; then
            ConsolePrint info "building site '$SITE_ID'"
            if [[ -z "${MVN_SITE_LIST[$SITE_ID]:-}" ]]; then
                ConsolePrint error "bdms: unknown site '$SITE_ID'"
            else
                BuildSite $SITE_ID
            fi
        else
            ConsolePrint error "bdms: no site given for build, use --all or --id"
        fi
    else
        ConsolePrint error "bdms: no targets given for build"
    fi
fi

if [[ $DO_TEST == true ]]; then
    if [[ "$ALL" == "yes" ]]; then
        ConsolePrint info "testing all sites"
        for ID in ${!MVN_SITE_LIST[@]}; do
            TestSite $ID
        done
    elif [[ -n "$SITE_ID" ]]; then
        ConsolePrint info "test site '$SITE_ID'"
        if [[ -z "${MVN_SITE_LIST[$SITE_ID]:-}" ]]; then
            ConsolePrint error "bdms: unknown site '$SITE_ID'"
        else
            TestSite $SITE_ID
        fi
    else
        ConsolePrint error "bdms: no side given for build, use --all or --id"
    fi
fi

ConsolePrint info "bdms: done"
exit $TASK_ERRORS
