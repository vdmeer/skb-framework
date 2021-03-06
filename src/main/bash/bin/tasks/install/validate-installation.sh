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
## validate-installation - validates an installation
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
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
##
source $FW_HOME/bin/api/_include


##
## set local variables
##
DO_ALL=false
DO_STRICT=false
TARGET=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=Ahs
CLI_LONG_OPTIONS=all,help,strict,msrc,cmd,dep,ec,opt,param,scn,task

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name validate-installation -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "validate-installation: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "validate-installation")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start options
                printf "   options\n"
                BuildTaskHelpLine h help    "<none>"    "print help screen and exit"    $PRINT_PADDING
                BuildTaskHelpLine s strict  "<none>"    "run in strict mode"            $PRINT_PADDING
                BuildTaskHelpTag end options

                printf "\n"
                BuildTaskHelpTag start targets
                printf "   targets\n"
                BuildTaskHelpLine A         all     "<none>" "set all targets"          $PRINT_PADDING
                BuildTaskHelpLine "<none>"  msrc    "<none>" "target: manual source"    $PRINT_PADDING
                BuildTaskHelpLine "<none>"  cmd     "<none>" "target: commands"         $PRINT_PADDING
                BuildTaskHelpLine "<none>"  dep     "<none>" "target: dependencies"     $PRINT_PADDING
                BuildTaskHelpLine "<none>"  ec      "<none>" "target: error codes"      $PRINT_PADDING
                BuildTaskHelpLine "<none>"  opt     "<none>" "target: options"          $PRINT_PADDING
                BuildTaskHelpLine "<none>"  param   "<none>" "target: parameters"       $PRINT_PADDING
                BuildTaskHelpLine "<none>"  scn     "<none>" "target: scenarios"        $PRINT_PADDING
                BuildTaskHelpLine "<none>"  task    "<none>" "target: tasks"            $PRINT_PADDING
                BuildTaskHelpTag end targets
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -s | --strict)
            shift
            DO_STRICT=true
            ;;

        -A | --all)
            shift
            DO_ALL=true
            CLI_SET=true
            ;;
        --msrc)
            shift
            TARGET=$TARGET" msrc"
            CLI_SET=true
            ;;

        --cmd)
            shift
            TARGET=$TARGET" cmd"
            CLI_SET=true
            ;;
        --dep)
            shift
            TARGET=$TARGET" dep"
            CLI_SET=true
            ;;
        --ec)
            shift
            TARGET=$TARGET" ec"
            CLI_SET=true
            ;;
        --opt)
            shift
            TARGET=$TARGET" opt"
            CLI_SET=true
            ;;
        --param)
            shift
            TARGET=$TARGET" param"
            CLI_SET=true
            ;;
        --scn)
            shift
            TARGET=$TARGET" scn"
            CLI_SET=true
            ;;
        --task)
            shift
            TARGET=$TARGET" task"
            CLI_SET=true
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "validate-installation: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI
############################################################################################
if [[ $DO_ALL == true || $CLI_SET == false ]]; then
    TARGET="msrc cmd dep ec opt param scn task"
fi



############################################################################################
##
## function: Validate MANUAL SOURCE
##
############################################################################################
ValidateManualSource() {
    ConsolePrint debug "validating manual source"

    local found
    local EXPECTED
    local EXP
    local FILE
    local SOURCE
    local DIR=${CONFIG_MAP["MANUAL_SRC"]}

    if [[ ! -d $DIR/tags ]]; then
        ConsolePrint error "vi: did not find tag directory"
    else
        EXPECTED="tags/name tags/authors"
        for FILE in $EXPECTED; do
            if [[ ! -f $DIR/$FILE.txt ]]; then
                ConsolePrint warn-strict "vi: manual missing file $FILE.txt"
            elif [[ ! -r $DIR/$FILE.txt ]]; then
                ConsolePrint warn-strict "vi: cannot read manual file $FILE.txt"
            fi
        done

        for FILE in $DIR/tags/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            found=false
            for EXP in $EXPECTED; do
                tmp=$EXP".txt"
                if [[ "$FILE" == *$tmp ]]; then
                    found=true
                fi
            done
            if [[ $found == false ]]; then
                ConsolePrint warn-strict "vi: found extra file tags/${FILE##*/}"
            fi
        done
    fi

    if [[ ! -d $DIR/elements ]]; then
        ConsolePrint error "did not find elements directory"
    else
        EXPECTED="elements/commands elements/dependencies elements/exit-options elements/errorcodes elements/options elements/parameters elements/run-options elements/tasks elements/scenarios"
        for FILE in $EXPECTED; do
            if [[ ! -f $DIR/$FILE.adoc ]]; then
                ConsolePrint warn-strict "vi: missing manual file $FILE.adoc"
            elif [[ ! -r $DIR/$FILE.adoc ]]; then
                ConsolePrint warn-strict "vi: cannot read manual file $FILE.adoc"
            fi
            if [[ ! -f $DIR/$FILE.txt ]]; then
                ConsolePrint warn-strict "vi: missing manual file $FILE.txt"
            elif [[ ! -r $DIR/$FILE.txt ]]; then
                ConsolePrint warn-strict "vi: cannot read manual file $FILE.txt"
            fi
        done

        for FILE in $DIR/elements/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            found=false
            for EXP in $EXPECTED; do
                tmp=$EXP".adoc"
                if [[ "$FILE" == *$tmp ]]; then
                    found=true
                fi
                tmp=$EXP".txt"
                if [[ "$FILE" == *$tmp ]]; then
                    found=true
                fi
            done
            if [[ $found == false ]]; then
                ConsolePrint warn-strict "vi: found extra file elements/${FILE##*/}"
            fi
        done
    fi

    if [[ ! -d $DIR/application ]]; then
        ConsolePrint error "did not find application directory"
    else
        EXPECTED="application/description application/authors application/bugs application/copying application/resources application/security"
        for FILE in $EXPECTED; do
            if [[ ! -f $DIR/$FILE.adoc ]]; then
                ConsolePrint warn-strict "vi: missing manual file $FILE.adoc"
            elif [[ ! -r $DIR/$FILE.adoc ]]; then
                ConsolePrint warn-strict "vi: cannot read manual file $FILE.adoc"
            fi
            if [[ ! -f $DIR/$FILE.txt ]]; then
                ConsolePrint warn-strict "vi: missing manual file $FILE.txt"
            elif [[ ! -r $DIR/$FILE.txt ]]; then
                ConsolePrint warn-strict "vi: cannot read manual file $FILE.txt"
            fi
        done

        for FILE in $DIR/application/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            found=false
            for EXP in $EXPECTED; do
                tmp=$EXP".adoc"
                if [[ "$FILE" == *$tmp ]]; then
                    found=true
                fi
                tmp=$EXP".txt"
                if [[ "$FILE" == *$tmp ]]; then
                    found=true
                fi
            done
            if [[ $found == false ]]; then
                ConsolePrint warn-strict "vi: found extra file application/${FILE##*/}"
            fi
        done
    fi

    ConsolePrint debug "done"
}



############################################################################################
##
## function: Validate COMMAND
##
############################################################################################
ValidateCommandDocs() {
    ConsolePrint debug "validating command docs"

    local ID
    local SOURCE
    for ID in ${!DMAP_CMD[@]}; do
        SOURCE=${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["COMMANDS"]}/$ID
        if [[ ! -f $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: commands '$ID' without ADOC file"
        elif [[ ! -r $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: commands '$ID' ADOC file not readable"
        fi
        if [[ ! -f $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: commands '$ID' without TXT file"
        elif [[ ! -r $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: commands '$ID' TXT file not readable"
        fi
    done

    ConsolePrint debug "done"
}

ValidateCommand() {
    ConsolePrint debug "validating command"

    ValidateCommandDocs

    local ID
    local ORIGIN_PATH=${CONFIG_MAP["FW_HOME"]}
    local FILE

    ## check that files in the command folder have a corresponding command declaration
    if [[ -d $ORIGIN_PATH/${FW_PATH_MAP["COMMANDS"]} ]]; then
        for FILE in $ORIGIN_PATH/${FW_PATH_MAP["COMMANDS"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_CMD[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/cmd - found extra file FW_HOME/${FW_PATH_MAP["COMMANDS"]}, command '$ID' not declared"
            fi
        done
    fi

    ConsolePrint debug "done"
}



############################################################################################
##
## function: Validate DEPENDENCY
##
############################################################################################
ValidateDependencyDocs() {
    ConsolePrint debug "validating command docs"

    local ID
    local SOURCE
    for ID in ${!DMAP_DEP_DECL[@]}; do
        SOURCE=${DMAP_DEP_DECL[$ID]}
        if [[ ! -f $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: dependency '$ID' without ADOC file"
        elif [[ ! -r $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: dependency '$ID' ADOC file not readable"
        fi
        if [[ ! -f $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: dependency '$ID' without TXT file"
        elif [[ ! -r $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: dependency '$ID' TXT file not readable"
        fi
    done

    ConsolePrint debug "done"
}

ValidateDependencyOrigin() {
    local ORIGIN=$1
    ConsolePrint debug "validating command docs $ORIGIN"

    local ID
    local ORIGIN_PATH=${CONFIG_MAP[$ORIGIN]}
    local FILE

    ## check that files in the dependency folder have a corresponding dependency declaration
    if [[ -d $ORIGIN_PATH/${APP_PATH_MAP["DEP_DECL"]} ]]; then
        for FILE in $ORIGIN_PATH/${APP_PATH_MAP["DEP_DECL"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_DEP_ORIGIN[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/dep - found extra file $ORIGIN/${APP_PATH_MAP["DEP_DECL"]}, dependency '$ID' not declared"
            fi
        done
    fi

    ConsolePrint debug "done"
}

ValidateDependency() {
    ConsolePrint debug "validating dependency"

    ValidateDependencyDocs
    ValidateDependencyOrigin FW_HOME
    if [[ "${CONFIG_MAP["FW_HOME"]}" != "${CONFIG_MAP["APP_HOME"]}" ]]; then
        ValidateDependencyOrigin APP_HOME
    fi

    ConsolePrint debug "done"
}



############################################################################################
##
## function: Validate ERRORCODES
##
############################################################################################
ValidateErrorCodeDocs() {
    ConsolePrint debug "validating error code docs"

    local ID
    local SOURCE
    for ID in ${!DMAP_EC[@]}; do
        SOURCE=${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["ERRORCODES"]}/$ID
        if [[ ! -f $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: error code '$ID' without ADOC file"
        elif [[ ! -r $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: error code '$ID' ADOC file not readable"
        fi
        if [[ ! -f $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: error code '$ID' without TXT file"
        elif [[ ! -r $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: error code '$ID' TXT file not readable"
        fi
    done

    ConsolePrint debug "done"
}

ValidateErrorCode() {
    ConsolePrint debug "validating error code"

    ValidateCommandDocs

    local ID
    local ORIGIN_PATH=${CONFIG_MAP["FW_HOME"]}
    local FILE

    ## check that files in the error code folder have a corresponding error code declaration
    if [[ -d $ORIGIN_PATH/${FW_PATH_MAP["ERRORCODES"]} ]]; then
        for FILE in $ORIGIN_PATH/${FW_PATH_MAP["ERRORCODES"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_EC[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/ec - found extra file FW_HOME/${FW_PATH_MAP["ERRORCODES"]}, error code '$ID' not declared"
            fi
        done
    fi

    ConsolePrint debug "done"
}



############################################################################################
##
## function: Validate OPTION
##
############################################################################################
ValidateOptionDocs() {
    ConsolePrint debug "validating option docs"

    local ID
    local SOURCE
    local OPT_PATH
    for ID in ${!DMAP_OPT_ORIGIN[@]}; do
        OPT_PATH=${DMAP_OPT_ORIGIN[$ID]:-}
        if [[ "$OPT_PATH" != "" ]]; then
            SOURCE=${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["OPTIONS"]}/$OPT_PATH/$ID
            if [[ ! -f $SOURCE.adoc ]]; then
                ConsolePrint warn-strict "vi: option '$ID' without ADOC file"
            elif [[ ! -r $SOURCE.adoc ]]; then
                ConsolePrint warn-strict "vi: option '$ID' ADOC file not readable"
            fi
            if [[ ! -f $SOURCE.txt ]]; then
                ConsolePrint warn-strict "vi: option '$ID' without TXT file"
            elif [[ ! -r $SOURCE.txt ]]; then
                ConsolePrint warn-strict "vi: option '$ID' TXT file not readable"
            fi
        fi
    done

    ConsolePrint debug "done"
}

ValidateOption() {
    ConsolePrint debug "validating option"

    ValidateOptionDocs

    local ID
    local ORIGIN_PATH=${CONFIG_MAP["FW_HOME"]}
    local FILE

    ## check that files in the option folder have a corresponding option declaration
    if [[ -d $ORIGIN_PATH/${FW_PATH_MAP["OPTIONS"]} ]]; then
        for FILE in $ORIGIN_PATH/${FW_PATH_MAP["OPTIONS"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_OPT_ORIGIN[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/opt - found extra file FW_HOME/${FW_PATH_MAP["OPTIONS"]}, option '$ID' not declared"
            fi
        done
    fi

    ConsolePrint debug "done"
}



############################################################################################
##
## function: Validate PARAMETER
##
############################################################################################
ValidateParameterDocs() {
    ConsolePrint debug "validating parameter docs"

    local ID
    local SOURCE
    for ID in ${!DMAP_PARAM_DECL[@]}; do
        SOURCE=${DMAP_PARAM_DECL[$ID]}
        if [[ ! -f $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: parameter '$ID' without ADOC file"
        elif [[ ! -r $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: parameter '$ID' ADOC file not readable"
        fi
        if [[ ! -f $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: parameter '$ID' without TXT file"
        elif [[ ! -r $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: parameter '$ID' TXT file not readable"
        fi
    done

    ConsolePrint debug "done"
}

ValidateParameterOrigin() {
    local ORIGIN=$1
    ConsolePrint debug "validating parameter $ORIGIN"

    local ID
    local ORIGIN_PATH=${CONFIG_MAP[$ORIGIN]}
    local FILE

    ## check that files in the parameter folder have a corresponding parameter declaration
    if [[ -d $ORIGIN_PATH/${APP_PATH_MAP["PARAM_DECL"]} ]]; then
        for FILE in $ORIGIN_PATH/${APP_PATH_MAP["PARAM_DECL"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_PARAM_ORIGIN[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/param - found extra file $ORIGIN/${APP_PATH_MAP["PARAM_DECL"]}, parameter '$ID' not declared"
            fi
        done
    fi

    ConsolePrint debug "done"
}

ValidateParameter() {
    ConsolePrint debug "validating parameter"

    ValidateParameterDocs
    ValidateParameterOrigin FW_HOME
    if [[ "${CONFIG_MAP["FW_HOME"]}" != "${CONFIG_MAP["APP_HOME"]}" ]]; then
        ValidateParameterOrigin APP_HOME
    fi

    ConsolePrint debug "done"
}



############################################################################################
##
## function: Validate SCENARIO
##
############################################################################################
ValidateScenarioDocs() {
    ConsolePrint debug "validating scenario docs"

    local ID
    local SOURCE
    for ID in ${!DMAP_SCN_DECL[@]}; do
        SOURCE=${DMAP_SCN_DECL[$ID]}
        if [[ ! -f $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: scenario '$ID' without ADOC file"
        elif [[ ! -r $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: scenario '$ID' ADOC file not readable"
        fi
        if [[ ! -f $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: scenario '$ID' without TXT file"
        elif [[ ! -r $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: scenario '$ID' TXT file not readable"
        fi
    done

    ConsolePrint debug "done"
}

ValidateScenarioOrigin() {
    local ORIGIN_PATH=$1
    local ORIGIN=$2
    ConsolePrint debug "validating scenario $ORIGIN"

    local ID
    local SCN_PATH=$ORIGIN_PATH/${APP_PATH_MAP["SCENARIOS"]}
    local FILE

    ## check that files in the scenario folder have a corresponding scenario declaration
    if [[ -d $SCN_PATH/${APP_PATH_MAP["SCENARIOS"]} ]]; then
        for FILE in $SCN_PATH/${APP_PATH_MAP["SCENARIOS"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_SCN_DECL[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/scn - found extra file $ORIGIN/${APP_PATH_MAP["SCENARIOS"]}, scenario '$ID' not declared"
            fi
        done
    fi

    ## check for extra files in scenario executables directory
    if [[ -d $SCN_PATH/${APP_PATH_MAP["SCENARIOS"]} ]]; then
        for FILE in $SCN_PATH/${APP_PATH_MAP["SCENARIOS"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_SCN_EXEC[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/scn - found extra file $ORIGIN/${APP_PATH_MAP["SCN_SCRIPT"]}, scenario '$ID' not declared"
            fi
        done
    fi

    ConsolePrint debug "done"
}

ValidateScenario() {
    ConsolePrint debug "validating scenario"

    ValidateScenarioDocs

    local ORIG_PATH
    local COUNT=1
    ValidateScenarioOrigin ${CONFIG_MAP["FW_HOME"]} FW_HOME
    if [[ "${CONFIG_MAP["FW_HOME"]}" != "${CONFIG_MAP["APP_HOME"]}" ]]; then
        ValidateScenarioOrigin ${CONFIG_MAP["APP_HOME"]} APP_HOME
    fi
    if [[ -n "${CONFIG_MAP["SCENARIO_PATH"]:-}" ]]; then
        for ORIG_PATH in ${CONFIG_MAP["SCENARIO_PATH"]}; do
            ValidateScenarioOrigin $ORIG_PATH $COUNT
            COUNT=$(($COUNT + 1))
        done
    fi


    ConsolePrint debug "done"
}



############################################################################################
##
## function: Validate TASK
##
############################################################################################
ValidateTaskDocs() {
    ConsolePrint debug "validating task docs"

    local ID
    local SOURCE
    for ID in ${!DMAP_TASK_DECL[@]}; do
        SOURCE=${DMAP_TASK_DECL[$ID]}
        if [[ ! -f $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: task '$ID' without ADOC file"
        elif [[ ! -r $SOURCE.adoc ]]; then
            ConsolePrint warn-strict "vi: task '$ID' ADOC file not readable"
        fi
        if [[ ! -f $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: task '$ID' without TXT file"
        elif [[ ! -r $SOURCE.txt ]]; then
            ConsolePrint warn-strict "vi: task '$ID' TXT file not readable"
        fi
    done

    ConsolePrint debug "done"
}

ValidateTaskOrigin() {
    local ORIGIN=$1
    ConsolePrint debug "validating task $ORIGIN"

    local ID
    local ORIGIN_PATH=${CONFIG_MAP[$ORIGIN]}
    local FILE

    ## check that files in the task folder have a corresponding task declaration
    if [[ -d $ORIGIN_PATH/${APP_PATH_MAP["TASK_DECL"]} ]]; then
        for FILE in $ORIGIN_PATH/${APP_PATH_MAP["TASK_DECL"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_TASK_DECL[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/task - found extra file $ORIGIN/${APP_PATH_MAP["TASK_DECL"]}, task '$ID' not declared"
            fi
        done
    fi

    ## check for extra files in task executables directory
    if [[ -d $ORIGIN_PATH/${APP_PATH_MAP["TASK_SCRIPT"]} ]]; then
        for FILE in $ORIGIN_PATH/${APP_PATH_MAP["TASK_SCRIPT"]}/**; do
            if [[ -d "$FILE" ]]; then
                continue
            fi
            ID=${FILE##*/}
            ID=${ID%.*}
            if [[ -z ${DMAP_TASK_EXEC[$ID]:-} ]]; then
                ConsolePrint error "vi: validate/task - found extra file $ORIGIN/${APP_PATH_MAP["TASK_SCRIPT"]}, task '$ID' not declared"
            fi
        done
    fi

    ConsolePrint debug "done"
}

ValidateTask() {
    ConsolePrint debug "validating task"

    ValidateTaskDocs
    ValidateTaskOrigin FW_HOME
    if [[ "${CONFIG_MAP["FW_HOME"]}" != "${CONFIG_MAP["APP_HOME"]}" ]]; then
        ValidateTaskOrigin APP_HOME
    fi

    ConsolePrint debug "done"
}



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "vi: starting task"
Counters reset errors

ConsolePrint info "validate target(s): $TARGET"

OLD_STRICT=${CONFIG_MAP["STRICT"]}
if [[ "$DO_STRICT" == true ]]; then
    CONFIG_MAP["STRICT"]=on
fi
for TODO in $TARGET; do
    ConsolePrint debug "target: $TODO"
    case $TODO in
        msrc)
            ConsolePrint info "validating manual source"
            ValidateManualSource
            ValidateCommandDocs
            ValidateErrorCodeDocs
            ValidateOptionDocs
            ValidateDependencyDocs
            ValidateParameterDocs
            ValidateTaskDocs
            ConsolePrint info "done"
            ;;
        cmd)
            ConsolePrint info "validating command"
            ValidateCommand
            ConsolePrint info "done"
            ;;
        dep)
            ConsolePrint info "validating dependency"
            ValidateDependency
            ConsolePrint info "done"
            ;;
        ec)
            ConsolePrint info "validating error code"
            ValidateErrorCode
            ConsolePrint info "done"
            ;;
        opt)
            ConsolePrint info "validating option"
            ValidateOption
            ConsolePrint info "done"
            ;;
        param)
            ConsolePrint info "validating parameter"
            ValidateParameter
            ConsolePrint info "done"
            ;;
        scn)
            ConsolePrint info "validating scenario"
            ValidateScenario
            ConsolePrint info "done"
            ;;
        task)
            ConsolePrint info "validating task"
            ValidateTask
            ConsolePrint info "done"
            ;;
        *)
            ConsolePrint error "vi: unknown target $TODO"
    esac
    ConsolePrint debug "done target - $TODO"
done
CONFIG_MAP["STRICT"]=OLD_STRICT

ConsolePrint info "vi: done"
exit $TASK_ERRORS
