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
## Runtime / Instances - fill runtime information for instances
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


## redo CLI to have an empty set
unset FW_INSTANCE_CLI_LONG FW_INSTANCE_CLI_SHORT FW_INSTANCE_CLI_LS FW_INSTANCE_CLI_SORT FW_INSTANCE_CLI_ARG FW_INSTANCE_CLI_CAT FW_INSTANCE_CLI_LEN FW_INSTANCE_CLI_SET FW_INSTANCE_CLI_VAL FW_INSTANCE_CLI_EXTRA

declare -A FW_INSTANCE_CLI_LONG     ## [long]="description"
declare -A FW_INSTANCE_CLI_SHORT    ## [short]=long
declare -A FW_INSTANCE_CLI_LS       ## [long]=short
declare -A FW_INSTANCE_CLI_SORT     ## [long]=sort-string : "#{short|l:1}{long}
declare -A FW_INSTANCE_CLI_ARG      ## [long]="argument"
declare -A FW_INSTANCE_CLI_CAT      ## [long]="category+name"
declare -A FW_INSTANCE_CLI_LEN      ## [long]="length: long + arg" + 5 for short/long dashes and short and blank, plus 1 if arg is set
declare -A FW_INSTANCE_CLI_SET      ## [long]="yes if option was set, no otherwise"
declare -A FW_INSTANCE_CLI_VAL      ## [long]="parsed value"
           FW_INSTANCE_CLI_EXTRA="" ## string with extra arguments parsed

FW_COMPONENTS_SINGULAR["Clioptions"]="clioption"
FW_COMPONENTS_PLURAL["Clioptions"]="clioptions"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Clioptions"]="Command Line Option"
FW_COMPONENTS_TITLE_LONG_PLURAL["Clioptions"]="CLI Options"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Clioptions"]="Command Line Option"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Clioptions"]="CLI Options"
FW_COMPONENTS_TABLE_DESCR["Clioptions"]="Description"
FW_COMPONENTS_TABLE_VALUE["Clioptions"]="Value from Command Line"
FW_COMPONENTS_TABLE_EXTRA["Clioptions"]=""
FW_COMPONENTS_TAGLINE["Clioptions"]="instance representing CLI options for tasks"



FW_COMPONENTS_SINGULAR["Exitcodes"]="exitcode"
FW_COMPONENTS_PLURAL["Exitcodes"]="exitcodes"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Exitcodes"]="Exit Code"
FW_COMPONENTS_TITLE_LONG_PLURAL["Exitcodes"]="Exit Codes"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Exitcodes"]="Exit Code"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Exitcodes"]="Exit Codes"
FW_COMPONENTS_TABLE_DESCR["Exitcodes"]="Description"
FW_COMPONENTS_TABLE_VALUE["Exitcodes"]="Description"
FW_COMPONENTS_TABLE_EXTRA["Exitcodes"]=""
FW_COMPONENTS_TAGLINE["Exitcodes"]="instance representing the framework's exit codes"



declare -A FW_INSTANCE_TABLE_CHARS      ## [id-format]="formatted char"
declare -A FW_INSTANCE_TABLE_STRINGS    ## [legend-type-format]="formatted legend strings"
FW_INSTANCE_TABLE_CHARS_BUILT=" "       ## string with characters for built formats, with leading and trailing space

FW_COMPONENTS_TAGLINE["Tablechars"]="instance that maintains cached table characters"


FW_COMPONENTS_TAGLINE["Module"]="instance to manage module requirements"
FW_COMPONENTS_TAGLINE["Dependency"]="instance to manage dependency requirements"
FW_COMPONENTS_TAGLINE["Project"]="instance to manage project requirements"
FW_COMPONENTS_TAGLINE["Scenario"]="instance to manage scenario requirements"
FW_COMPONENTS_TAGLINE["Script"]="instance to manage script requirements"
FW_COMPONENTS_TAGLINE["Site"]="instance to manage site requirements"
FW_COMPONENTS_TAGLINE["Task"]="instance to manage task requirements"

