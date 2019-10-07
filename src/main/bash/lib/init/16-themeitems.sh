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
## Init/Themeitems - declare the known theme items
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


    Add object themeitem rptAppFatalTpl      "template for reporting application fatal errors"
    Add object themeitem rptAppErrorTpl      "template for reporting application errors"
    Add object themeitem rptAppTextTpl       "template for reporting application text"
    Add object themeitem rptAppMessageTpl    "template for reporting application messages"
    Add object themeitem rptAppWarningTpl    "template for reporting application warnings"
    Add object themeitem rptAppInfoTpl       "template for reporting application info text"
    Add object themeitem rptAppDebugTpl      "template for reporting application debug text"
    Add object themeitem rptAppTraceTpl      "template for reporting application trace text"

    Add object themeitem rptProcFatalTpl     "template for reporting process fatal errors"
    Add object themeitem rptProcErrorTpl     "template for reporting process errors"
    Add object themeitem rptProcTextTpl      "template for reporting process text"
    Add object themeitem rptProcMessageTpl   "template for reporting process messages"
    Add object themeitem rptProcWarningTpl   "template for reporting process warnings"
    Add object themeitem rptProcInfoTpl      "template for reporting process info text"
    Add object themeitem rptProcDebugTpl     "template for reporting process debug text"
    Add object themeitem rptProcTraceTpl     "template for reporting process trace text"


    Add object themeitem rptFatalLvlFmt      "format used for level string when printing fatal errors"
    Add object themeitem rptErrorLvlFmt      "format used for level string when printing errors"
    Add object themeitem rptTextLvlFmt       "format used for level string when printing text"
    Add object themeitem rptMessageLvlFmt    "format used for level string when printing messages"
    Add object themeitem rptWarningLvlFmt    "format used for level string when printing warnings"
    Add object themeitem rptInfoLvlFmt       "format used for level string when printing info text"
    Add object themeitem rptDebugLvlFmt      "format used for level string when printing debug text"
    Add object themeitem rptTraceLvlFmt      "format used for level string when printing trace text"

    Add object themeitem rptFatalTextFmt     "format used for text when printing fatal errors"
    Add object themeitem rptErrorTextFmt     "format used for text when printing errors"
    Add object themeitem rptTextTextFmt      "format used for text when printing text"
    Add object themeitem rptMessageTextFmt   "format used for text when printing messages"
    Add object themeitem rptWarningTextFmt   "format used for text when printing warnings"
    Add object themeitem rptInfoTextFmt      "format used for text when printing info text"
    Add object themeitem rptDebugTextFmt     "format used for text when printing debug text"
    Add object themeitem rptTraceTextFmt     "format used for text when printing trace text"



    Add object themeitem modeAllFmt     "format used for printing (current) mode 'all'"
    Add object themeitem modeTestFmt    "format used for printing (current) mode 'test'"
    Add object themeitem modeDevFmt     "format used for printing (current) mode 'dev'"
    Add object themeitem modeBuildFmt   "format used for printing (current) mode 'build'"
    Add object themeitem modeUseFmt     "format used for printing (current) mode 'use'"



    Add object themeitem lvlFatalerrorFmt   "format used for print/log level 'fatalerror'"
    Add object themeitem lvlErrorFmt        "format used for print/log level 'error'"
    Add object themeitem lvlWarningFmt      "format used for print/log level 'warning'"
    Add object themeitem lvlInfoFmt         "format used for print/log level 'info'"
    Add object themeitem lvlDebugFmt        "format used for print/log level 'debug'"
    Add object themeitem lvlTraceFmt        "format used for print/log level 'trace'"
    Add object themeitem lvlTextFmt         "format used for print/log level 'text'"
    Add object themeitem lvlMessageFmt      "format used for print/log level 'message'"



    Add object themeitem tabTopruleChar     "character used for the top line"
    Add object themeitem tabTopruleFmt      "format used for the top line"
    Add object themeitem tabMidruleChar     "character used for the middle lines"
    Add object themeitem tabMidruleFmt      "format used for the middle lines"
    Add object themeitem tabBottomruleChar  "character used for the bottom line"
    Add object themeitem tabBottomruleFmt   "format used for the bottom line"



    Add object themeitem listHeadFmt        "list: format used for the list heading"
    Add object themeitem listNameFmt        "list: format used for the object/element name"
    Add object themeitem listSeparator      "list: string separating name and description"
    Add object themeitem listDescrFmt       "list: format used for the object/element description"
    Add object themeitem listValueFmt       "list: format used for the object/element values"
    Add object themeitem listArgFmt         "list: format used for the argument (option/clioption)"
    Add object themeitem listCatFmt         "cli/option list: format used for categories, other than 'Options'"

    Add object themeitem tableHeadFmt       "table: format used for the table head row"
    Add object themeitem tableNameFmt       "table: format used for the object/element name"
    Add object themeitem tableSeparator     "table: string separating name and description"
    Add object themeitem tableDescrFmt      "table: format used for the object/element description"
    Add object themeitem tableValueFmt      "table: format used for the object/element values"
    Add object themeitem tableOriginFmt     "table: format for origin string"
    Add object themeitem tableSourceFmt     "table: format for source string"
    Add object themeitem tableArgFmt        "table: format used for the argument (option/clioption)"

    Add object themeitem describeNameFmt    "describe: format used for the object/element name"
    Add object themeitem describeSeparator  "describe: string separating name and description"
    Add object themeitem describeDescrFmt   "describe: format used for the object/element description"
    Add object themeitem describeArgFmt     "describe: format used for the argument (option/clioption)"



    Add object themeitem phaLvlSetChar            "character for level being set"
    Add object themeitem phaLvlNotsetChar         "character for level not being set"
    Add object themeitem phaLvlNotsetFmt          "format for level not being set"
        Add object themeitem phaLvlFatalSetFmt    "format for level 'fatalerror' set"
        Add object themeitem phaLvlErrorSetFmt    "format for level 'error' set"
        Add object themeitem phaLvlWarningSetFmt  "format for level 'warning' set"
        Add object themeitem phaLvlInfoSetFmt     "format for level 'info' set"
        Add object themeitem phaLvlDebugSetFmt    "format for level 'debug' set"
        Add object themeitem phaLvlTraceSetFmt    "format for level 'trace' set"
        Add object themeitem phaLvlMessageSetFmt  "format for level 'message' set"
        Add object themeitem phaLvlTextSetFmt     "format for level 'text' set"
    Add object themeitem phaErrNumberFmt          "format for number of errors"
    Add object themeitem phaWarnNumberFmt         "format for number of warnings"


    Add object themeitem phaseCLIChar       "character for phase CLI"
    Add object themeitem phaseCLIFmt        "format for phase CLI"
    Add object themeitem phaseDefaultChar   "character for phase Default (value)"
    Add object themeitem phaseDefaultFmt    "format for phase Default (value)"
    Add object themeitem phaseEnvChar       "character for phase Env"
    Add object themeitem phaseEnvFmt        "format for phase Env"
    Add object themeitem phaseFileChar      "character for phase File"
    Add object themeitem phaseFileFmt       "format for phase File"
    Add object themeitem phaseLoadChar      "character for phase Load"
    Add object themeitem phaseLoadFmt       "format for phase Load"
    Add object themeitem phaseProjectChar   "character for phase Project"
    Add object themeitem phaseProjectFmt    "format for phase Project"
    Add object themeitem phaseScenarioChar  "character for phase Scenario"
    Add object themeitem phaseScenarioFmt   "format for phase Scenario"
    Add object themeitem phaseShellChar     "character for phase Shell"
    Add object themeitem phaseShellFmt      "format for phase Shell"
    Add object themeitem phaseSiteChar      "character for phase Site"
    Add object themeitem phaseSiteFmt       "format for phase Site"
    Add object themeitem phaseTaskChar      "character for phase Task"
    Add object themeitem phaseTaskFmt       "format for phase Task"



    Add object themeitem elementStatusNFmt      "format for element status not-tested"
    Add object themeitem elementStatusNChar     "character for element status not-tested"
    Add object themeitem elementStatusEFmt      "format for element status error"
    Add object themeitem elementStatusEChar     "character for element status error"
    Add object themeitem elementStatusWFmt      "format for element status warning"
    Add object themeitem elementStatusWChar     "character for element status warning"
    Add object themeitem elementStatusSFmt      "format for element status success"
    Add object themeitem elementStatusSChar     "character for element status success"

    Add object themeitem elementModeYesFmt      "format for element available in mode"
    Add object themeitem elementModeYesChar     "character for element available in mode"
    Add object themeitem elementModeNoFmt       "format for element not available in mode"
    Add object themeitem elementModeNoChar      "character for element not available in mode"

    Add object themeitem elementReqYesFmt       "format for element requested 'yes'"
    Add object themeitem elementReqYesChar      "character for element requested 'yes'"
    Add object themeitem elementReqNoFmt        "format for element requested 'no'"
    Add object themeitem elementReqNoChar       "character for element requested 'no'"

    Add object themeitem elementDefYesFmt       "format for parameter default value 'yes'"
    Add object themeitem elementDefYesChar      "character for parameter default value 'yes'"
    Add object themeitem elementDefNoFmt        "format for parameter default value 'no'"
    Add object themeitem elementDefNoChar       "character for parameter default value 'no'"



    Add object themeitem repeatLineChar         "repeat execution: line character"
    Add object themeitem repeatLineFmt          "repeat execution: line format"
    Add object themeitem repeatSepLeftChar      "repeat execution: left separator character"
    Add object themeitem repeatSepLeftFmt       "repeat execution: left separator format"
    Add object themeitem repeatSepRightChar     "repeat execution: right separator character"
    Add object themeitem repeatSepRightFmt      "repeat execution: right separator format"
    Add object themeitem repeatTextFmt          "repeat execution: text format"
    Add object themeitem repeatTextSepStr       "repeat execution: text separator string"
    Add object themeitem repeatCmdFmt           "repeat execution: command format"

    Add object themeitem execLineChar           "execute: line character"
    Add object themeitem execLineFmt            "execute: line format"
    Add object themeitem execStartNameFmt       "format for task name/id"
    Add object themeitem execStartTimeFmt       "format for start time"
    Add object themeitem execStartTextFmt       "format for text 'executing ...'"
    Add object themeitem execEndDoneFmt         "format for 'done'"
    Add object themeitem execEndTimeFmt         "format for end time"
    Add object themeitem execEndRuntimeFmt      "format for runtime"
    Add object themeitem execEndStatusFmt       "format for status text"
    Add object themeitem execEndSuccessFmt      "format for success status"
    Add object themeitem execEndErrorFmt        "format for error status"



    Add object themeitem explainTitleFmt        "explain: title format"
    Add object themeitem explainTextFmt         "explain: text format"
    Add object themeitem explainComponentFmt    "explain: format for component name"
    Add object themeitem explainOperationFmt    "explain: format for operation names"
    Add object themeitem explainArgFmt          "explain: format for operation arguments"

    Add object themeitem explainIndent1         "explain: indentation for string 'Available ...'"
    Add object themeitem explainIndent2         "explain: indentation for commands"
    Add object themeitem explainIndent3         "explain: indentation for command descriptions"
