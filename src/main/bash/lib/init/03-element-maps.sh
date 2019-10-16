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
## Element Maps - declare the framework's element maps
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


##
## APPLICATION Maps - APP
##
declare -A FW_ELEMENT_APP_LONG              ## [long]="description"
declare -A FW_ELEMENT_APP_DECMDS            ## [long]="declared in module"
declare -A FW_ELEMENT_APP_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_APP_PHA               ## [long]="phase that did set the value"
declare -A FW_ELEMENT_APP_COMMAND           ## [long]="command"
declare -A FW_ELEMENT_APP_ARGNUM            ## [long]="number of arguments"
declare -A FW_ELEMENT_APP_ARGS              ## [long]="arguments"

declare -A FW_ELEMENT_APP_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_APP_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_APP_REQUESTED         ## [long]="is requested, empty or list of element:id"

FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_APP_LONG FW_ELEMENT_APP_DECMDS FW_ELEMENT_APP_DECPHA FW_ELEMENT_APP_PHA FW_ELEMENT_APP_COMMAND FW_ELEMENT_APP_ARGNUM FW_ELEMENT_APP_ARGS"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_APP_STATUS FW_ELEMENT_APP_STATUS_COMMENTS FW_ELEMENT_APP_REQUESTED"



##
## DEPENDENCY Maps - DEP
##
declare -A FW_ELEMENT_DEP_LONG              ## [long]="description"
declare -A FW_ELEMENT_DEP_DECMDS            ## [long]="declared in module"
declare -A FW_ELEMENT_DEP_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_DEP_CMD               ## [long]="test-command"
declare -A FW_ELEMENT_DEP_REQOUT_NUM        ## [long]="outgoing requirement number"

declare -A FW_ELEMENT_DEP_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_DEP_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_DEP_REQUESTED         ## [long]="is requested, empty or list of element:id"

declare -A FW_ELEMENT_DEP_REQUIRED_DEP      ## [long]="depends on other dependencies, normal list"

FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_DEP_LONG FW_ELEMENT_DEP_DECMDS FW_ELEMENT_DEP_DECPHA FW_ELEMENT_DEP_CMD FW_ELEMENT_DEP_REQOUT_NUM FW_ELEMENT_DEP_REQUIRED_DEP"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_DEP_STATUS FW_ELEMENT_DEP_STATUS_COMMENTS FW_ELEMENT_DEP_REQUESTED"



##
## DIRLIST Maps - DLS
##
declare -A FW_ELEMENT_DLS_LONG              ## [long]="description"
declare -A FW_ELEMENT_DLS_DECMDS            ## [long]="declared in module"
declare -A FW_ELEMENT_DLS_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_DLS_PHA               ## [long]="phase that did set the value"
declare -A FW_ELEMENT_DLS_VAL               ## [long]="the list of directories"
declare -A FW_ELEMENT_DLS_MOD               ## [long]="dir mode: rwxcd"

declare -A FW_ELEMENT_DLS_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_DLS_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_DLS_REQUESTED         ## [long]="is requested, empty or list of element:id"

FW_RUNTIME_MAPS_FAST+=" FW_ELEMENT_DLS_PHA FW_ELEMENT_DLS_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_DLS_LONG FW_ELEMENT_DLS_DECMDS FW_ELEMENT_DLS_DECPHA FW_ELEMENT_DLS_MOD"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_DLS_STATUS FW_ELEMENT_DLS_STATUS_COMMENTS FW_ELEMENT_DLS_REQUESTED"



##
## DIR Maps - DIR
##
declare -A FW_ELEMENT_DIR_LONG              ## [long]="description"
declare -A FW_ELEMENT_DIR_DECMDS            ## [long]="declared in module"
declare -A FW_ELEMENT_DIR_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_DIR_PHA               ## [long]="phase that did set the value"
declare -A FW_ELEMENT_DIR_VAL               ## [long]="the directory"
declare -A FW_ELEMENT_DIR_MOD               ## [long]="dir mode: rwxcd"

declare -A FW_ELEMENT_DIR_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_DIR_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_DIR_REQUESTED         ## [long]="is requested, empty or list of element:id"

FW_RUNTIME_MAPS_FAST+=" FW_ELEMENT_DIR_PHA FW_ELEMENT_DIR_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_DIR_LONG FW_ELEMENT_DIR_DECMDS FW_ELEMENT_DIR_DECPHA FW_ELEMENT_DIR_MOD"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_DIR_STATUS FW_ELEMENT_DIR_STATUS_COMMENTS FW_ELEMENT_DIR_REQUESTED"



##
## FILELIST Maps - FLS
##
declare -A FW_ELEMENT_FLS_LONG              ## [long]="description"
declare -A FW_ELEMENT_FLS_DECMDS            ## [long]="declared in module"
declare -A FW_ELEMENT_FLS_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_FLS_PHA               ## [long]="phase that did set the value"
declare -A FW_ELEMENT_FLS_VAL               ## [long]="list of files"
declare -A FW_ELEMENT_FLS_MOD               ## [long]="file mode: rwxcd"

declare -A FW_ELEMENT_FLS_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_FLS_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_FLS_REQUESTED         ## [long]="is requested, empty or list of element:id"

FW_RUNTIME_MAPS_FAST+=" FW_ELEMENT_FLS_PHA FW_ELEMENT_FLS_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_FLS_LONG FW_ELEMENT_FLS_DECMDS FW_ELEMENT_FLS_DECPHA FW_ELEMENT_FLS_MOD"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_FLS_STATUS FW_ELEMENT_FLS_STATUS_COMMENTS FW_ELEMENT_FLS_REQUESTED"



##
## FILE Maps - FIL
##
declare -A FW_ELEMENT_FIL_LONG              ## [long]="description"
declare -A FW_ELEMENT_FIL_DECMDS            ## [long]="declared in module"
declare -A FW_ELEMENT_FIL_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_FIL_PHA               ## [long]="phase that did set the value"
declare -A FW_ELEMENT_FIL_VAL               ## [long]="the file"
declare -A FW_ELEMENT_FIL_MOD               ## [long]="file mode: rwxcd"

declare -A FW_ELEMENT_FIL_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_FIL_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_FIL_REQUESTED         ## [long]="is requested, empty or list of element:id"

FW_RUNTIME_MAPS_FAST+=" FW_ELEMENT_FIL_PHA FW_ELEMENT_FIL_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_FIL_LONG FW_ELEMENT_FIL_DECMDS FW_ELEMENT_FIL_DECPHA FW_ELEMENT_FIL_MOD"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_FIL_STATUS FW_ELEMENT_FIL_STATUS_COMMENTS FW_ELEMENT_FIL_REQUESTED"



##
## MODULE Maps - MDS
##
declare -A FW_ELEMENT_MDS_LONG              ## [long]="description"
declare -A FW_ELEMENT_MDS_ACR               ## [long]=acronym
declare -A FW_ELEMENT_MDS_PATH              ## [long]=path
declare -A FW_ELEMENT_MDS_DECPHA            ## [long]="phase that did set the value"
declare -A FW_ELEMENT_MDS_REQOUT_NUM        ## [long]="outgoing requirement number"

declare -A FW_ELEMENT_MDS_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_MDS_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_MDS_REQUESTED         ## [long]="is requested, empty or list of element:id"

declare -A FW_ELEMENT_MDS_REQUIRED_MDS      ## [long]="depends on other modules, normal list"

declare -A FW_ELEMENT_MDS_KNOWN             ## [ID]="map of known/found modules"

FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_MDS_LONG FW_ELEMENT_MDS_ACR FW_ELEMENT_MDS_DECPHA FW_ELEMENT_MDS_PATH FW_ELEMENT_MDS_REQOUT_NUM FW_ELEMENT_MDS_REQUIRED_MDS"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_MDS_STATUS FW_ELEMENT_MDS_STATUS_COMMENTS FW_ELEMENT_MDS_REQUESTED"



##
## OPTION Maps - OPT
##
declare -A FW_ELEMENT_OPT_LONG              ## [long]="description"
declare -A FW_ELEMENT_OPT_SHORT             ## [short]=long
declare -A FW_ELEMENT_OPT_LS                ## [long]=short
declare -A FW_ELEMENT_OPT_SORT              ## [long]=sort-string : "#{short|l:1}{long}
declare -A FW_ELEMENT_OPT_ARG               ## [long]="argument"
declare -A FW_ELEMENT_OPT_CAT               ## [long]="category+name"
declare -A FW_ELEMENT_OPT_LEN               ## [long]="length: long + arg" + 5 for short/long dashes and short and blank, plus 1 if arg is set
declare -A FW_ELEMENT_OPT_SET               ## [long]="yes if option was set, no otherwise"
declare -A FW_ELEMENT_OPT_VAL               ## [long]="parsed value"
           FW_ELEMENT_OPT_EXTRA=""          ## string with extra arguments parsed

FW_RUNTIME_MAPS_LOAD+=" FW_ELEMENT_OPT_LONG FW_ELEMENT_OPT_SHORT FW_ELEMENT_OPT_LS FW_ELEMENT_OPT_SORT FW_ELEMENT_OPT_ARG FW_ELEMENT_OPT_CAT FW_ELEMENT_OPT_LEN FW_ELEMENT_OPT_SET FW_ELEMENT_OPT_VAL FW_ELEMENT_OPT_EXTRA"



##
## PARAMETER Maps - PAR
##
declare -A FW_ELEMENT_PAR_LONG              ## [long]="description"
declare -A FW_ELEMENT_PAR_DECMDS            ## [long]="declared in module"
declare -A FW_ELEMENT_PAR_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_PAR_DEFVAL            ## [long]="some-value or empty"
declare -A FW_ELEMENT_PAR_PHA               ## [long]="phase that did set the value"
declare -A FW_ELEMENT_PAR_VAL               ## [long]="the value"

declare -A FW_ELEMENT_PAR_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_PAR_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_PAR_REQUESTED         ## [long]="is requested, empty or list of element:id"

FW_RUNTIME_MAPS_FAST+=" FW_ELEMENT_PAR_PHA FW_ELEMENT_PAR_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_PAR_LONG FW_ELEMENT_PAR_DECMDS FW_ELEMENT_PAR_DECPHA FW_ELEMENT_PAR_DEFVAL"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_PAR_STATUS FW_ELEMENT_PAR_STATUS_COMMENTS FW_ELEMENT_PAR_REQUESTED"



##
## PROJECT Maps - PRJ
##
declare -A FW_ELEMENT_PRJ_LONG              ## [long]=description
declare -A FW_ELEMENT_PRJ_DECMDS            ## [long]=declared in module
declare -A FW_ELEMENT_PRJ_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_PRJ_MODES             ## [long]=app-mode
declare -A FW_ELEMENT_PRJ_PATH              ## [long]=path
declare -A FW_ELEMENT_PRJ_PATH_TEXT         ## [long]=module::path
declare -A FW_ELEMENT_PRJ_RDIR              ## [long]=project root directory, empty if not required
declare -A FW_ELEMENT_PRJ_TGTS              ## [long]=target list
declare -A FW_ELEMENT_PRJ_SHOW_EXEC         ## [long]=yes|no
declare -A FW_ELEMENT_PRJ_REQOUT_NUM        ## [long]="outgoing requirement number"

declare -A FW_ELEMENT_PRJ_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_PRJ_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_PRJ_REQUESTED         ## [long]="is requested, empty or list of element:id"

declare -A FW_ELEMENT_PRJ_REQUIRED_APP      ## [long]="required requirement applications, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_DEP      ## [long]="required dependencies, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_PAR      ## [long]="required parameters, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_PRJ      ## [long]="required projects, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_SCN      ## [long]="required scenarios, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_SIT      ## [long]="required sites, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_TSK      ## [long]="required tasks, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_FIL      ## [long]="required files, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_FLS      ## [long]="required file lists, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_DIR      ## [long]="required directories, normal list"
declare -A FW_ELEMENT_PRJ_REQUIRED_DLS      ## [long]="required directory lists, normal list"

FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_PRJ_LONG FW_ELEMENT_PRJ_DECMDS FW_ELEMENT_PRJ_DECPHA FW_ELEMENT_PRJ_MODES FW_ELEMENT_PRJ_PATH FW_ELEMENT_PRJ_PATH_TEXT FW_ELEMENT_PRJ_RDIR FW_ELEMENT_PRJ_TGTS FW_ELEMENT_PRJ_SHOW_EXEC FW_ELEMENT_PRJ_REQUIRED_APP FW_ELEMENT_PRJ_REQUIRED_DEP FW_ELEMENT_PRJ_REQUIRED_PAR FW_ELEMENT_PRJ_REQUIRED_PRJ FW_ELEMENT_PRJ_REQUIRED_SCN FW_ELEMENT_PRJ_REQUIRED_SIT FW_ELEMENT_PRJ_REQUIRED_TSK FW_ELEMENT_PRJ_REQUIRED_FIL FW_ELEMENT_PRJ_REQUIRED_FLS FW_ELEMENT_PRJ_REQUIRED_DIR FW_ELEMENT_PRJ_REQUIRED_DLS FW_ELEMENT_PRJ_REQOUT_NUM"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_PRJ_STATUS FW_ELEMENT_PRJ_STATUS_COMMENTS FW_ELEMENT_PRJ_REQUESTED"



##
## SCENARIO Maps - SCN
##
declare -A FW_ELEMENT_SCN_LONG              ## [long]=description
declare -A FW_ELEMENT_SCN_DECMDS            ## [long]=declared in module
declare -A FW_ELEMENT_SCN_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_SCN_MODES             ## [long]=app-mode
declare -A FW_ELEMENT_SCN_PATH              ## [long]=path
declare -A FW_ELEMENT_SCN_PATH_TEXT         ## [long]=module::path
declare -A FW_ELEMENT_SCN_SHOW_EXEC         ## [long]=yes|no
declare -A FW_ELEMENT_SCN_REQOUT_NUM        ## [long]="outgoing requirement number"

declare -A FW_ELEMENT_SCN_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_SCN_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_SCN_REQUESTED         ## [long]="is requested, empty or list of element:id"

declare -A FW_ELEMENT_SCN_REQUIRED_APP      ## [long]="required applications, normal list"
declare -A FW_ELEMENT_SCN_REQUIRED_SCN      ## [long]="required scenarios, normal list"
declare -A FW_ELEMENT_SCN_REQUIRED_TSK      ## [long]="required tasks, normal list"

FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_SCN_LONG FW_ELEMENT_SCN_DECMDS FW_ELEMENT_SCN_DECPHA FW_ELEMENT_SCN_MODES FW_ELEMENT_SCN_PATH FW_ELEMENT_SCN_PATH_TEXT FW_ELEMENT_SCN_SHOW_EXEC FW_ELEMENT_SCN_REQUIRED_APP FW_ELEMENT_SCN_REQUIRED_SCN FW_ELEMENT_SCN_REQUIRED_TSK FW_ELEMENT_SCN_REQOUT_NUM"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_SCN_STATUS FW_ELEMENT_SIT_STATUS_COMMENTS FW_ELEMENT_SCN_REQUESTED"



##
## SCRIPTS Maps - SCR
##
declare -A FW_ELEMENT_SCR_LONG              ## [long]=description
declare -A FW_ELEMENT_SCR_DECMDS            ## [long]=declared in module
declare -A FW_ELEMENT_SCR_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_SCR_MODES             ## [long]=app-mode
declare -A FW_ELEMENT_SCR_PATH              ## [long]=path
declare -A FW_ELEMENT_SCR_PATH_TEXT         ## [long]=module::path
declare -A FW_ELEMENT_SCR_RDIR              ## [long]=project root directory, empty if not required
declare -A FW_ELEMENT_SCR_SHOW_EXEC         ## [long]=yes|no
declare -A FW_ELEMENT_SCR_REQOUT_NUM        ## [long]="outgoing requirement number"

declare -A FW_ELEMENT_SCR_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_SCR_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_SCR_REQUESTED         ## [long]="is requested, empty or list of element:id"

declare -A FW_ELEMENT_SCR_REQUIRED_APP      ## [long]="required requirement applications, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_DEP      ## [long]="required dependencies, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_PAR      ## [long]="required parameters, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_PRJ      ## [long]="required projects, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_SCN      ## [long]="required scenarios, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_SCR      ## [long]="required scripts, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_SIT      ## [long]="required sites, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_TSK      ## [long]="required tasks, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_FIL      ## [long]="required files, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_FLS      ## [long]="required file lists, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_DIR      ## [long]="required directories, normal list"
declare -A FW_ELEMENT_SCR_REQUIRED_DLS      ## [long]="required directory lists, normal list"

FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_SCR_LONG FW_ELEMENT_SCR_DECMDS FW_ELEMENT_SCR_DECPHA FW_ELEMENT_SCR_MODES FW_ELEMENT_SCR_PATH FW_ELEMENT_SCR_PATH_TEXT FW_ELEMENT_SCR_RDIR FW_ELEMENT_SCR_SHOW_EXEC FW_ELEMENT_SCR_REQUIRED_APP FW_ELEMENT_SCR_REQUIRED_DEP FW_ELEMENT_SCR_REQUIRED_PAR FW_ELEMENT_SCR_REQUIRED_PRJ FW_ELEMENT_SCR_REQUIRED_SCN FW_ELEMENT_SCR_REQUIRED_SCR FW_ELEMENT_SCR_REQUIRED_SIT FW_ELEMENT_SCR_REQUIRED_TSK FW_ELEMENT_SCR_REQUIRED_FIL FW_ELEMENT_SCR_REQUIRED_FLS FW_ELEMENT_SCR_REQUIRED_DIR FW_ELEMENT_SCR_REQUIRED_DLS FW_ELEMENT_SCR_REQOUT_NUM"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_SCR_STATUS FW_ELEMENT_SCR_STATUS_COMMENTS FW_ELEMENT_SCR_REQUESTED"



##
## SITE Maps - SIT
##
declare -A FW_ELEMENT_SIT_LONG              ## [long]=description
declare -A FW_ELEMENT_SIT_DECMDS            ## [long]=declated in module
declare -A FW_ELEMENT_SIT_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_SIT_MODES             ## [long]=app-mode
declare -A FW_ELEMENT_SIT_PATH              ## [long]=path
declare -A FW_ELEMENT_SIT_PATH_TEXT         ## [long]=module::path
declare -A FW_ELEMENT_SIT_RDIR              ## [long]=root directory, empty if not required
declare -A FW_ELEMENT_SIT_SHOW_EXEC         ## [long]=yes|no
declare -A FW_ELEMENT_SIT_REQOUT_NUM        ## [long]="outgoing requirement number"

declare -A FW_ELEMENT_SIT_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_SIT_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_SIT_REQUESTED         ## [long]="is requested, empty or list of element:id"

declare -A FW_ELEMENT_SIT_REQUIRED_APP      ## [long]="required applications, normal list"
declare -A FW_ELEMENT_SIT_REQUIRED_DEP      ## [long]="required dependencies, normal list"
declare -A FW_ELEMENT_SIT_REQUIRED_PAR      ## [long]="required parameters, normal list"
declare -A FW_ELEMENT_SIT_REQUIRED_SCN      ## [long]="required scenarios, normal list"
declare -A FW_ELEMENT_SIT_REQUIRED_TSK      ## [long]="required tasks, normal list"
declare -A FW_ELEMENT_SIT_REQUIRED_FIL      ## [long]="required files, normal list"
declare -A FW_ELEMENT_SIT_REQUIRED_FLS      ## [long]="required file lists, normal list"
declare -A FW_ELEMENT_SIT_REQUIRED_DIR      ## [long]="required directories, normal list"
declare -A FW_ELEMENT_SIT_REQUIRED_DLS      ## [long]="required directory lists, normal list"

FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_SIT_LONG FW_ELEMENT_SIT_DECMDS FW_ELEMENT_SIT_DECPHA FW_ELEMENT_SIT_MODES FW_ELEMENT_SIT_PATH FW_ELEMENT_SIT_PATH_TEXT FW_ELEMENT_SIT_RDIR FW_ELEMENT_SIT_SHOW_EXEC FW_ELEMENT_SIT_REQUIRED_APP FW_ELEMENT_SIT_REQUIRED_DEP FW_ELEMENT_SIT_REQUIRED_PAR FW_ELEMENT_SIT_REQUIRED_SCN FW_ELEMENT_SIT_REQUIRED_TSK FW_ELEMENT_SIT_REQUIRED_FIL FW_ELEMENT_SIT_REQUIRED_FLS FW_ELEMENT_SIT_REQUIRED_DIR FW_ELEMENT_SIT_REQUIRED_DLS FW_ELEMENT_SIT_REQOUT_NUM"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_SIT_STATUS FW_ELEMENT_SIT_STATUS_COMMENTS FW_ELEMENT_SIT_REQUESTED"



##
## TASK Maps - TSK
##
declare -A FW_ELEMENT_TSK_LONG              ## [long]=description
declare -A FW_ELEMENT_TSK_DECMDS            ## [long]=declared in module
declare -A FW_ELEMENT_TSK_DECPHA            ## [long]="declared in phase"
declare -A FW_ELEMENT_TSK_MODES             ## [long]=app-mode
declare -A FW_ELEMENT_TSK_PATH              ## [long]=path
declare -A FW_ELEMENT_TSK_PATH_TEXT         ## [long]=module::path
declare -A FW_ELEMENT_TSK_SHOW_EXEC         ## [long]=yes|no
declare -A FW_ELEMENT_TSK_REQOUT_NUM        ## [long]="outgoing requirement number"

declare -A FW_ELEMENT_TSK_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
declare -A FW_ELEMENT_TSK_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
declare -A FW_ELEMENT_TSK_REQUESTED         ## [long]="is requested, empty or list of element:id"

declare -A FW_ELEMENT_TSK_REQUIRED_APP      ## [long]="required applications, normal list"
declare -A FW_ELEMENT_TSK_REQUIRED_DEP      ## [long]="required dependencies, normal list"
declare -A FW_ELEMENT_TSK_REQUIRED_PAR      ## [long]="required parameters, normal list"
declare -A FW_ELEMENT_TSK_REQUIRED_TSK      ## [long]="required tasks, normal list"
declare -A FW_ELEMENT_TSK_REQUIRED_FIL      ## [long]="required files, normal list"
declare -A FW_ELEMENT_TSK_REQUIRED_FLS      ## [long]="required file lists, normal list"
declare -A FW_ELEMENT_TSK_REQUIRED_DIR      ## [long]="required directories, normal list"
declare -A FW_ELEMENT_TSK_REQUIRED_DLS      ## [long]="required directory lists, normal list"

FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_TSK_LONG FW_ELEMENT_TSK_DECMDS FW_ELEMENT_TSK_DECPHA FW_ELEMENT_TSK_MODES FW_ELEMENT_TSK_PATH FW_ELEMENT_TSK_PATH_TEXT FW_ELEMENT_TSK_SHOW_EXEC FW_ELEMENT_TSK_REQUIRED_APP FW_ELEMENT_TSK_REQUIRED_DEP FW_ELEMENT_TSK_REQUIRED_PAR FW_ELEMENT_TSK_REQUIRED_TSK FW_ELEMENT_TSK_REQUIRED_FIL FW_ELEMENT_TSK_REQUIRED_FLS FW_ELEMENT_TSK_REQUIRED_DIR FW_ELEMENT_TSK_REQUIRED_DLS FW_ELEMENT_TSK_REQOUT_NUM"
FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_TSK_STATUS FW_ELEMENT_TSK_STATUS_COMMENTS FW_ELEMENT_TSK_REQUESTED"

