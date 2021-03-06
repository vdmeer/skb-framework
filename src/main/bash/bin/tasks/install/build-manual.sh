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
## build-manual - builds the manual for different targets
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



## put bugs into errors, safer and globbing for finding files
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
##
source $FW_HOME/bin/api/_include


##
## set local variables
##
DO_CLEAN=false
DO_BUILD=false
DO_TEST=false
DO_ALL=false
DO_PRIMARY=false
DO_SECONDARY=false
REQUESTED=false
LOADED=false
TARGET=
INSTALL=false

NO_AUTHORS=false
NO_BUGS=false
NO_COPYING=false
NO_RESOURCES=false
NO_SECURITY=false

NO_COMMANDS=false
NO_COMMAND_LIST=false
NO_DEPS=false
NO_DEP_LIST=false
NO_ERRORCODES=false
NO_ERRORCODE_LIST=false
NO_OPTIONS=false
NO_OPTION_LIST=false
NO_PARAMS=false
NO_PARAM_LIST=false
NO_SCENARIOS=false
NO_SCENARIO_LIST=false
NO_TASKS=false
NO_TASK_LIST=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=Abchilnprst
CLI_LONG_OPTIONS=build,clean,help,test,all,adoc,html,manp,pdf,text,src,requested
CLI_LONG_OPTIONS+=,no-authors,no-bugs,no-copying,no-resources,no-security
CLI_LONG_OPTIONS+=,no-commands,no-deps,no-errorcodes,no-options,no-params,no-scenarios,no-tasks
CLI_LONG_OPTIONS+=,no-command-list,no-dep-list,no-errorcode-list,no-option-list,no-param-list,no-scenario-list,no-task-list
CLI_LONG_OPTIONS+=,loaded,install

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name build-manual -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "build-manual: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
PRINT_PADDING_FILTERS=28
while true; do
    case "$1" in
        -b | --build)
            shift
            DO_BUILD=true
            ;;
        -c | --clean)
            shift
            DO_CLEAN=true
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "build-manual")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start options
                printf "   options\n"
                BuildTaskHelpLine A all         "<none>"    "set all targets, overwrites other options"             $PRINT_PADDING
                BuildTaskHelpLine b build       "<none>"    "builds a manual (manpage), requires a target"          $PRINT_PADDING
                BuildTaskHelpLine c clean       "<none>"    "removes all target artifacts"                          $PRINT_PADDING
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                            $PRINT_PADDING
                BuildTaskHelpLine p primary     "<none>"    "set all primary targets"                               $PRINT_PADDING
                BuildTaskHelpLine s secondary   "<none>"    "set all secondary targets"                             $PRINT_PADDING
                BuildTaskHelpLine t test        "<none>"    "test a manual (show results), requires a target"       $PRINT_PADDING
                BuildTaskHelpTag end options

                printf "\n"
                BuildTaskHelpTag start targets
                printf "   targets\n"
                BuildTaskHelpLine "<none>" adoc  "<none>" "primary target: aggregated ADOC file"                    $PRINT_PADDING
                BuildTaskHelpLine "<none>" html  "<none>" "secondary target: HTML file"                             $PRINT_PADDING
                BuildTaskHelpLine "<none>" manp  "<none>" "secondary target: man page file"                         $PRINT_PADDING
                BuildTaskHelpLine "<none>" pdf   "<none>" "secondary target: PDF file)"                             $PRINT_PADDING
                BuildTaskHelpLine "<none>" text  "<none>" "secondary target: text versions: ansi, text, text-anon"  $PRINT_PADDING
                BuildTaskHelpLine "<none>" src   "<none>" "primary target: text source files from ADOC"             $PRINT_PADDING
                BuildTaskHelpTag end targets

                printf "\n"
                BuildTaskHelpTag start element-list-filters
                printf "   element list filters\n"
                BuildTaskHelpLine i install     "<none>"    "only list 'install' app mode flavor tasks and scenarios"   $PRINT_PADDING
                BuildTaskHelpLine l loaded      "<none>"    "list only loaded tasks and scenarios"                      $PRINT_PADDING
                BuildTaskHelpLine r requested   "<none>"    "list only requested dependencies and parameters"           $PRINT_PADDING
                BuildTaskHelpTag end element-list-filters

                printf "\n"
                BuildTaskHelpTag start application-filters
                printf "   application filters\n"
                BuildTaskHelpLine "<none>" no-authors       "<none>" "do not include authors"                       $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-bugs          "<none>" "do not include bugs"                          $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-copying       "<none>" "do not include copying"                       $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-resources     "<none>" "do not include resources"                     $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-security      "<none>" "do not include security"                      $PRINT_PADDING_FILTERS
                BuildTaskHelpTag end application-filters

                printf "\n"
                BuildTaskHelpTag start element-filters
                printf "   element filters\n"
                BuildTaskHelpLine "<none>" no-commands          "<none>" "do not include commands"                  $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-command-list      "<none>" "include command text, but no list"        $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-deps              "<none>" "include dependency text, but no list"     $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-dep-list          "<none>" "do not include dependencies"              $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-errorcodes        "<none>" "do not include error codes"               $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-errorcode-list    "<none>" "include error code text, but no list"     $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-options           "<none>" "do not include options"                   $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-option-list       "<none>" "include option test, but no list"         $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-params            "<none>" "do not include parameters"                $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-param-list        "<none>" "include parameter text, but no list"      $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-scenarios         "<none>" "do not include scenarios"                 $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-scenario-list     "<none>" "include scenario text, but no list"       $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-tasks             "<none>" "do not include tasks"                     $PRINT_PADDING_FILTERS
                BuildTaskHelpLine "<none>" no-task-list         "<none>" "include task text, but no list"           $PRINT_PADDING_FILTERS
                BuildTaskHelpTag end element-filters
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -l | --loaded)
            shift
            LOADED=true
            ;;
        -i | --install)
            shift
            INSTALL=true
            ;;
        -r | --requested)
            shift
            REQUESTED=true
            ;;
        -t | --test)
            shift
            DO_TEST=true
            ;;

        -A | --all)
            shift
            DO_ALL=true
            ;;
        -p | --primary)
            shift
            DO_PRIMARY=true
            ;;
        -s | --secondary)
            shift
            DO_SECONDARY=true
            ;;
        --adoc)
            shift
            TARGET=$TARGET" adoc"
            ;;
        --html)
            shift
            TARGET=$TARGET" html"
            ;;
        --manp)
            shift
            TARGET=$TARGET" manp"
            ;;
        --pdf)
            shift
            TARGET=$TARGET" pdf"
            ;;
        --text)
            shift
            TARGET=$TARGET" text"
            ;;
        --src)
            shift
            TARGET=$TARGET" src"
            ;;

        --no-authors)
            shift
            NO_AUTHORS=true
            ;;
        --no-bugs)
            shift
            NO_BUGS=true
            ;;
        --no-copying)
            shift
            NO_COPYING=true
            ;;
        --no-resources)
            shift
            NO_RESOURCES=true
            ;;
        --no-security)
            shift
            NO_SECURITY=true
            ;;

        --no-commands)
            shift
            NO_COMMANDS=true
            ;;
        --no-command-list)
            shift
            NO_COMMAND_LIST=true
            ;;
        --no-deps)
            shift
            NO_DEPS=true
            ;;
        --no-dep-list)
            shift
            NO_DEP_LIST=true
            ;;
        --no-errorcodes)
            shift
            NO_ERRORCODES=true
            ;;
        --no-errorcode-list)
            shift
            NO_ERRORCODE_LIST=true
            ;;
        --no-options)
            shift
            NO_OPTIONS=true
            ;;
        --no-option-list)
            shift
            NO_OPTION_LIST=true
            ;;
        --no-params)
            shift
            NO_PARAMS=true
            ;;
        --no-param-list)
            shift
            NO_PARAM_LIST=true
            ;;
        --no-scenarios)
            shift
            NO_SCENARIOS=true
            ;;
        --no-scenario-list)
            shift
            NO_SCENARIO_LIST=true
            ;;
        --no-tasks)
            shift
            NO_TASKS=true
            ;;
        --no-task-list)
            shift
            NO_TASK_LIST=true
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "build-manual: internal error (task): CLI parsing bug"
            exit 52
    esac
done


if [[ $DO_PRIMARY == true ]]; then
    TARGET="src adoc"
fi
if [[ $DO_SECONDARY == true ]]; then
    TARGET="text manp html pdf"
fi
if [[ $DO_ALL == true ]]; then
    TARGET="src adoc text manp html pdf"
fi
if [[ $DO_BUILD == true || $DO_TEST == true ]]; then
    if [[ ! -n "$TARGET" ]]; then
        ConsolePrint error "bdm: build/test required, but no target set"
        exit 60
    fi
fi

if [[ "$REQUESTED" == false ]]; then
    REQUESTED="--all"
else
    REQUESTED="--requested"
fi
if [[ "$LOADED" == false ]]; then
    LOADED="--all"
else
    LOADED="--loaded"
fi
if [[ "$INSTALL" == false ]]; then
    INSTALL=" "
else
    INSTALL="--install"
fi


############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "bdm: starting task"



############################################################################################
## validate documentation source, exit on errors
############################################################################################
ValidateSrc(){
    STRICT=${CONFIG_MAP["STRICT"]}
    CONFIG_MAP["STRICT"]=on
    Counters reset errors

    set +e
    ${DMAP_TASK_EXEC["validate-installation"]} --strict --msrc
    __errno=$?
    set -e

    if (( $__errno > 0 )); then
        ConsolePrint error "bdm: found documentation errors, cannot continue"
        ConsolePrint info "bdm: done"
        exit 61
    fi
    CONFIG_MAP["STRICT"]=$STRICT
}



############################################################################################
## core build function
############################################################################################
##
## function: BuildManualCore()
## - builds the core of the manual for ADOC, ANSI-TEXT, and TEXT
## $1: target to build: adoc, ansi, text
##
BuildManualCore() {
    local TARGET=$1

    local i
    local keys
    local SOURCE
    local OPTION
    local PARAM
    local DEP
    local TASK

    case $TARGET in
        adoc)
            printf "= %s(1)\n" "${CONFIG_MAP["APP_SCRIPT"]}"
            printf "%s\n" "$(cat ${CONFIG_MAP["MANUAL_SRC"]}/tags/authors.txt)"
            printf ":doctype: manpage\n"
            printf ":man manual: %s Manual\n" "${CONFIG_MAP["APP_NAME"]}"
            printf ":man source: %s %s\n" "${CONFIG_MAP["APP_NAME"]}" "${CONFIG_MAP["APP_VERSION"]}"
            printf ":page-layout: base\n"
            printf ":toclevels: 4\n\n"
            printf "== NAME\n"
            ;;
        ansi)
            printf "\n  "
            PrintEffect bold "NAME" $TARGET
            printf "\n  "
            ;;
        text*)
            printf "\n  "
            PrintEffect bold "NAME" $TARGET
            printf "\n  "
            ;;
    esac
    printf "%s - " "${CONFIG_MAP["APP_SCRIPT"]}"
    cat ${CONFIG_MAP["MANUAL_SRC"]}/tags/name.txt
    printf "\n\n"

    case $TARGET in
        adoc)
            printf "== SYNOPSIS\n\n"
            PrintEffect bold "${CONFIG_MAP["APP_SCRIPT"]}" $TARGET
            printf " "
            PrintEffect italic "OPTIONS" $TARGET
            printf "\n\n"
            ;;
        ansi | text*)
            printf "  "
            PrintEffect bold "SYNOPSIS" $TARGET
            printf "\n\n    "
            PrintEffect bold "${CONFIG_MAP["APP_SCRIPT"]}" $TARGET
            printf " "
            PrintEffect italic "OPTIONS" $TARGET
            printf "\n"
            ;;
    esac
    printf "    - will process the options\n"

    case $TARGET in
        adoc)
            printf "\n"
            PrintEffect bold "${CONFIG_MAP["APP_SCRIPT"]}" $TARGET
            printf "\n\n"
            ;;
        ansi | text*)
            printf "\n    "
            PrintEffect bold "${CONFIG_MAP["APP_SCRIPT"]}" $TARGET
            printf "\n"
            ;;
    esac

    printf "    - will start the interactive shell\n"
    printf "    - type 'h' or 'help' in the shell for commands\n"
    printf "\n"


    DescribeApplication description $TARGET

    if [[ "$NO_OPTIONS" == false ]]; then
        OptionElementDescription option $TARGET

        OptionElementDescription runtime $TARGET
        if [[ "$NO_OPTION_LIST" == false ]]; then
            set +e
            ${DMAP_TASK_EXEC["describe-option"]} --run --print-mode $TARGET
            set -e
        fi

        OptionElementDescription exit $TARGET
        if [[ "$NO_OPTION_LIST" == false ]]; then
            set +e
            ${DMAP_TASK_EXEC["describe-option"]} --exit --print-mode $TARGET
            set -e
        fi
    fi

    if [[ "$NO_PARAMS" == false ]]; then
        ParameterElementDescription $TARGET
        if [[ "$NO_PARAM_LIST" == false ]]; then
            set +e
            ${DMAP_TASK_EXEC["describe-parameter"]} $REQUESTED $INSTALL --print-mode $TARGET
            set -e
        fi
    fi

    if [[ "$NO_TASKS" == false ]]; then
        TaskElementDescription $TARGET
        if [[ "$NO_TASK_LIST" == false ]]; then
            set +e
            ${DMAP_TASK_EXEC["describe-task"]} $LOADED $INSTALL --print-mode $TARGET
            set -e
        fi
    fi

    if [[ "$NO_DEPS" == false ]]; then
        DependencyElementDescription $TARGET
        if [[ "$NO_DEP_LIST" == false ]]; then
            set +e
            ${DMAP_TASK_EXEC["describe-dependency"]} $REQUESTED $INSTALL --print-mode $TARGET
            set -e
        fi
    fi

    if [[ "$NO_COMMANDS" == false ]]; then
        CommandElementDescription $TARGET
        if [[ "$NO_COMMAND_LIST" == false ]]; then
            set +e
            ${DMAP_TASK_EXEC["describe-command"]} --all --print-mode $TARGET
            set -e
        fi
    fi

    if [[ "$NO_ERRORCODES" == false ]]; then
        ErrorcodeElementDescription $TARGET
        if [[ "$NO_ERRORCODE_LIST" == false ]]; then
            set +e
            ${DMAP_TASK_EXEC["describe-errorcode"]} --all --print-mode $TARGET
            set -e
        fi
    fi

    if [[ "$NO_SCENARIOS" == false ]]; then
        ScenarioElementDescription $TARGET
        if [[ "$NO_SCENARIO_LIST" == false ]]; then
            set +e
            ${DMAP_TASK_EXEC["describe-scenario"]} $LOADED $INSTALL --print-mode $TARGET
            set -e
        fi
    fi


    if [[ "$NO_SECURITY" == false ]]; then
        DescribeApplication security $TARGET
    fi

    if [[ "$NO_BUGS" == false ]]; then
        DescribeApplication bugs $TARGET
    fi

    if [[ "$NO_AUTHORS" == false ]]; then
        DescribeApplication authors $TARGET
    fi

    if [[ "$NO_RESOURCES" == false ]]; then
        DescribeApplication resources $TARGET
    fi

    if [[ "$NO_COPYING" == false ]]; then
        DescribeApplication copying $TARGET
    fi

    printf "\n"
}



############################################################################################
##
## functions for SRC build (no test)
##
############################################################################################
BuildSrcPath() {
    local ADOC_PATH=$1
    local LEVEL=$2
    local JAR=${CONFIG_MAP["SKB_FW_TOOL"]}
    local FILE
    local TARGET

    for FILE in $ADOC_PATH/**/*.adoc; do
        TARGET=${FILE%.*}
        if [[ -f $TARGET.txt ]]; then
            rm $TARGET.txt
        fi
        java -jar $(PathToSystemPath $JAR) $(PathToSystemPath $FILE) $LEVEL > $TARGET.txt
        ConsolePrint trace "  wrote file $TARGET.txt"
    done
}

BuildSrc() {
    ConsolePrint info "bdm/src"
    if [[ -z ${CONFIG_MAP["SKB_FW_TOOL"]:-} ]]; then
        ConsolePrint error "bdm/src: no setting for SKB_FW_TOOL found, cannot build"
        return
    fi
    if [[ "${RTMAP_DEP_STATUS["jre"]:-}" == "S" ]]; then
        ConsolePrint debug "bdm/src - manual"
        BuildSrcPath ${CONFIG_MAP["MANUAL_SRC"]} l1

        ConsolePrint debug "bdm/src - commands"
        BuildSrcPath ${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["COMMANDS"]} l2
        ConsolePrint debug "bdm/src - error codes"
        BuildSrcPath ${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["ERRORCODES"]} l2
        ConsolePrint debug "bdm/src - options"
        BuildSrcPath ${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["OPTIONS"]} l2


        if [[ -d "${CONFIG_MAP["APP_HOME"]}/${APP_PATH_MAP["DEP_DECL"]}" ]]; then
            ConsolePrint debug "bdm/src - dependencies"
            BuildSrcPath ${CONFIG_MAP["APP_HOME"]}/${APP_PATH_MAP["DEP_DECL"]} l2
        else
            ConsolePrint debug "bdm/src - no dependency declarations found"
        fi

        if [[ -d "${CONFIG_MAP["APP_HOME"]}/${APP_PATH_MAP["PARAM_DECL"]}" ]]; then
            ConsolePrint debug "bdm/src - parameters"
            BuildSrcPath ${CONFIG_MAP["APP_HOME"]}/${APP_PATH_MAP["PARAM_DECL"]} l2
        else
            ConsolePrint debug "bdm/src - no parameter declarations found"
        fi

        if [[ -d "${CONFIG_MAP["APP_HOME"]}/${APP_PATH_MAP["TASK_DECL"]}" ]]; then
            ConsolePrint debug "bdm/src - tasks"
            BuildSrcPath ${CONFIG_MAP["APP_HOME"]}/${APP_PATH_MAP["TASK_DECL"]} l2
        else
            ConsolePrint debug "bdm/src - no task declarations found"
        fi

        if [[ -d "${CONFIG_MAP["APP_HOME"]}/${APP_PATH_MAP["SCENARIOS"]}" ]]; then
            ConsolePrint debug "bdm/src - scenarios"
            BuildSrcPath ${CONFIG_MAP["APP_HOME"]}/${APP_PATH_MAP["SCENARIOS"]} l2
        else
            ConsolePrint debug "bdm/src - no scenario declarations found"
        fi

    else
        ConsolePrint error "bdm/src: dependency 'jre' not loaded, could not build"
    fi
    ConsolePrint info "done"
}



############################################################################################
##
## set variables for files
##
############################################################################################
MAN_PAGE_DIR=${CONFIG_MAP["APP_HOME"]}/man/man1
MAN_PAGE_FILE=$MAN_PAGE_DIR/${CONFIG_MAP["APP_SCRIPT"]}.1

MAN_DOC_DIR=${CONFIG_MAP["APP_HOME"]}/doc/manual
MAN_ADOC_FILE=$MAN_DOC_DIR/${CONFIG_MAP["APP_SCRIPT"]}.adoc
MAN_HTML_FILE=$MAN_DOC_DIR/${CONFIG_MAP["APP_SCRIPT"]}.html
MAN_PDF_FILE=$MAN_DOC_DIR/${CONFIG_MAP["APP_SCRIPT"]}.pdf



############################################################################################
##
## functions for TEXT build/test
##
############################################################################################
BuildText() {
    local target
    local targets=${1:-}
    if [[ ! -n "$targets" ]]; then
        targets="adoc ansi text text-anon"
    fi
    local file

    ConsolePrint debug "bdm/text"
    for target in $targets; do
        ConsolePrint debug "building: $target"
        file=$MAN_DOC_DIR/${CONFIG_MAP["APP_SCRIPT"]}.$target
        if [[ -f $file ]]; then
            rm $file
        fi
        ConsolePrint trace "  for $target"
        BuildManualCore $target 1> $file
    done
    ConsolePrint debug "done/text"
}

TestText() {
    local targets=${1:-}
    if [[ ! -n "$targets" ]]; then
        targets="adoc ansi text text-anon"
    fi
    local found=true
    for target in $targets; do
        file=$MAN_DOC_DIR/${CONFIG_MAP["APP_SCRIPT"]}.$target
        if [[ ! -f $file ]]; then
            found=false
        fi
    done
    if ! $found; then BuildText; fi

    for target in $targets; do
        file=$MAN_DOC_DIR/${CONFIG_MAP["APP_SCRIPT"]}.$target
        tput smcup
        clear
        less -r -C -f -M -d $file
        tput rmcup
    done
}



############################################################################################
##
## functions for HTML build/test
##
############################################################################################
BuildHtml() {
    ConsolePrint debug "bdm/html"
    if [[ ! -f $MAN_ADOC_FILE ]]; then
        BuildText adoc
    fi
    if [[ "${RTMAP_DEP_STATUS["asciidoctor"]:-}" == "S" ]]; then
        if [[ -f $MAN_HTML_FILE ]]; then
            rm $MAN_HTML_FILE
        fi
        if [[ -f $MAN_ADOC_FILE ]]; then
            asciidoctor $MAN_ADOC_FILE --backend html -a toc=left
        else
            ConsolePrint error "bdm/html: problem building ADOC"
        fi
    else
        ConsolePrint error "bdm/html: dependency 'asciidoctor' not loaded, could not build"
    fi
    ConsolePrint debug "done: bdm/html"
}

TestHtml() {
    if [[ ! -f $MAN_HTML_FILE ]]; then
        BuildHtml
    fi
    if [[ -f $MAN_HTML_FILE ]]; then
        if [[ ! -z "${RTMAP_TASK_LOADED["start-browser"]}" ]]; then
            set +e
            ${DMAP_TASK_EXEC["start-browser"]} --url file://$(PathToSystemPath $MAN_HTML_FILE)
            set -e
        else
            ConsolePrint error "bdm/html: cannot test, task 'start-browser' not loaded"
        fi
    else
        ConsolePrint error "bdm/problem building HTML"
    fi
}



############################################################################################
##
## functions for MANP build/test
##
############################################################################################
BuildManp() {
    ConsolePrint debug "bdm/manp"
    if [[ ! -f $MAN_ADOC_FILE ]]; then
        BuildText adoc
    fi
    if [[ "${RTMAP_DEP_STATUS["asciidoctor"]:-}" == "S" ]]; then
        if [[ -f $MAN_PAGE_FILE ]]; then
            rm $MAN_PAGE_FILE
        fi
        if [[ -f $MAN_ADOC_FILE ]]; then
            asciidoctor $MAN_ADOC_FILE --backend manpage --destination-dir $MAN_PAGE_DIR
        else
            ConsolePrint error "bdm/manp: problem building ADOC"
        fi
    else
        ConsolePrint error "bdm/manp: dependency 'asciidoctor' not loaded, could not build"
    fi
    ConsolePrint debug "done: bdm/manp"
}

TestManp() {
    if [[ ! -f $MAN_PAGE_FILE ]]; then
        BuildManp
    fi
    if [[ -f $MAN_PAGE_FILE ]]; then
        man -M $MAN_PAGE_DIR/.. ${CONFIG_MAP["APP_SCRIPT"]}
    else
        ConsolePrint error "bdm/problem building MANP"
    fi
}



############################################################################################
##
## functions for PDF build/test
##
############################################################################################
BuildPdf() {
    ConsolePrint debug "bdm/pdf"
    if [[ ! -f $MAN_ADOC_FILE ]]; then
        BuildText adoc
    fi
    if [[ "${RTMAP_DEP_STATUS["asciidoctor-pdf"]:-}" == "S" ]]; then
        if [[ -f $MAN_PDF_FILE ]]; then
            rm $MAN_PDF_FILE
        fi
        if [[ -f $MAN_ADOC_FILE ]]; then
            asciidoctor-pdf $MAN_ADOC_FILE
        else
            ConsolePrint error "bdm/pdf: problem building ADOC"
        fi
    else
        ConsolePrint error "bdm/pdf: dependency 'asciidoctor' not loaded, could not build"
    fi
    ConsolePrint debug "done: bdm/pdf"
}

TestPdf() {
    if [[ ! -f $MAN_PDF_FILE ]]; then
        BuildPdf
    fi
    if [[ -f $MAN_PDF_FILE ]]; then
        if [[ ! -z "${RTMAP_TASK_LOADED["start-pdf"]}" ]]; then
            set +e
            ${DMAP_TASK_EXEC["start-pdf"]} --file $MAN_PDF_FILE
            set -e
        else
            ConsolePrint error "bdm/pdf: cannot test, task 'start-pdf' not loaded"
        fi
    else
        ConsolePrint error "bdm/problem building PDF"
    fi
}



############################################################################################
##
## Now the actual business logic of the task
##
############################################################################################
if [[ $DO_CLEAN == true ]]; then
    ConsolePrint info "bdm/clean: all targets"

    ConsolePrint debug "scanning $MAN_PAGE_DIR"
    for file in $MAN_PAGE_DIR/**; do
        if [[ -f $file ]]; then
            rm $file
            ConsolePrint trace "  removed file $file"
        fi
    done

    ConsolePrint debug "scanning $MAN_DOC_DIR"
    for file in $MAN_DOC_DIR/**; do
        if [[ -f $file ]]; then
            rm $file
            ConsolePrint trace "  removed file $file"
        fi
    done

    ConsolePrint info "done clean"
fi

if [[ $DO_BUILD == true ]]; then
    case "$TARGET" in
        *src*)  BuildSrc ;;
    esac

    ValidateSrc
    ConsolePrint info "build for target(s): $TARGET"
    for TODO in $TARGET; do
        case $TODO in
            adoc)   BuildText "adoc" ;;
            html)   BuildHtml ;;
            manp)   BuildManp ;;
            pdf)    BuildPdf ;;
            text)   BuildText "ansi text text-anon" ;;
            src)    ;;
            *)      ConsolePrint error "bdm/build, unknown target '$TODO'"
        esac
    done
    ConsolePrint info "done build"
fi

if [[ $DO_TEST == true ]]; then
    ConsolePrint info "test for target(s): $TARGET"
    for TODO in $TARGET; do
        case $TODO in
            adoc)   TestText "adoc" ;;
            html)   TestHtml ;;
            manp)   TestManp ;;
            pdf)    TestPdf ;;
            text)   TestText "ansi text text-anon" ;;
            src)    ;;
            *)      ConsolePrint error "bdm/test, unknown target '$TODO'"
        esac
    done
    ConsolePrint info "done test"
fi

ConsolePrint info "bdm: done"
exit $TASK_ERRORS
