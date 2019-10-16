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


Add object themeitem rptAppFatalTpl      with    "template for reporting application fatal errors"
Add object themeitem rptAppErrorTpl      with    "template for reporting application errors"
Add object themeitem rptAppTextTpl       with    "template for reporting application text"
Add object themeitem rptAppMessageTpl    with    "template for reporting application messages"
Add object themeitem rptAppWarningTpl    with    "template for reporting application warnings"
Add object themeitem rptAppInfoTpl       with    "template for reporting application info text"
Add object themeitem rptAppDebugTpl      with    "template for reporting application debug text"
Add object themeitem rptAppTraceTpl      with    "template for reporting application trace text"

Add object themeitem rptProcFatalTpl     with    "template for reporting process fatal errors"
Add object themeitem rptProcErrorTpl     with    "template for reporting process errors"
Add object themeitem rptProcTextTpl      with    "template for reporting process text"
Add object themeitem rptProcMessageTpl   with    "template for reporting process messages"
Add object themeitem rptProcWarningTpl   with    "template for reporting process warnings"
Add object themeitem rptProcInfoTpl      with    "template for reporting process info text"
Add object themeitem rptProcDebugTpl     with    "template for reporting process debug text"
Add object themeitem rptProcTraceTpl     with    "template for reporting process trace text"


Add object themeitem rptFatalLvlFmt      with    "format used for level string when printing fatal errors"
Add object themeitem rptErrorLvlFmt      with    "format used for level string when printing errors"
Add object themeitem rptTextLvlFmt       with    "format used for level string when printing text"
Add object themeitem rptMessageLvlFmt    with    "format used for level string when printing messages"
Add object themeitem rptWarningLvlFmt    with    "format used for level string when printing warnings"
Add object themeitem rptInfoLvlFmt       with    "format used for level string when printing info text"
Add object themeitem rptDebugLvlFmt      with    "format used for level string when printing debug text"
Add object themeitem rptTraceLvlFmt      with    "format used for level string when printing trace text"

Add object themeitem rptFatalTextFmt     with    "format used for text when printing fatal errors"
Add object themeitem rptErrorTextFmt     with    "format used for text when printing errors"
Add object themeitem rptTextTextFmt      with    "format used for text when printing text"
Add object themeitem rptMessageTextFmt   with    "format used for text when printing messages"
Add object themeitem rptWarningTextFmt   with    "format used for text when printing warnings"
Add object themeitem rptInfoTextFmt      with    "format used for text when printing info text"
Add object themeitem rptDebugTextFmt     with    "format used for text when printing debug text"
Add object themeitem rptTraceTextFmt     with    "format used for text when printing trace text"



Add object themeitem modeAllFmt     with    "format used for printing (current) mode 'all'"
Add object themeitem modeTestFmt    with    "format used for printing (current) mode 'test'"
Add object themeitem modeDevFmt     with    "format used for printing (current) mode 'dev'"
Add object themeitem modeBuildFmt   with    "format used for printing (current) mode 'build'"
Add object themeitem modeUseFmt     with    "format used for printing (current) mode 'use'"



Add object themeitem lvlFatalerrorFmt   with    "format used for print/log level 'fatalerror'"
Add object themeitem lvlErrorFmt        with    "format used for print/log level 'error'"
Add object themeitem lvlWarningFmt      with    "format used for print/log level 'warning'"
Add object themeitem lvlInfoFmt         with    "format used for print/log level 'info'"
Add object themeitem lvlDebugFmt        with    "format used for print/log level 'debug'"
Add object themeitem lvlTraceFmt        with    "format used for print/log level 'trace'"
Add object themeitem lvlTextFmt         with    "format used for print/log level 'text'"
Add object themeitem lvlMessageFmt      with    "format used for print/log level 'message'"


Add object themeitem listHeadFmt        with    "list: format used for the list heading"
Add object themeitem listNameFmt        with    "list: format used for the object/element name"
Add object themeitem listSeparator      with    "list: string separating name and description"
Add object themeitem listDescrFmt       with    "list: format used for the object/element description"
Add object themeitem listValueFmt       with    "list: format used for the object/element values"
Add object themeitem listArgFmt         with    "list: format used for the argument (option/clioption)"
Add object themeitem listCatFmt         with    "cli/option list: format used for categories, other than 'Options'"
Add object themeitem listBgrndFmt       with    "list: format for the background"



Add object themeitem tableTopruleChar       with    "character used for the top rule, empty means no rule printed"
Add object themeitem tableTopruleFmt        with    "format used for the top rule"
Add object themeitem tableMidruleChar       with    "character used for the mid rule, empty means no rule printed"
Add object themeitem tableMidruleFmt        with    "format used for the mid rule"
Add object themeitem tableBottomruleChar    with    "character used for the bottom rule, empty means no rule printed"
Add object themeitem tableBottomruleFmt     with    "format used for the bottom rule"
Add object themeitem tableLegendruleChar    with    "character used for the legend rule, empty means no rule printed"
Add object themeitem tableLegendruleFmt     with    "format used for the legend rule"
Add object themeitem tableStatusruleChar    with    "character used for the status rule, empty means no rule printed"
Add object themeitem tableStatusruleFmt     with    "format used for the status rule"

Add object themeitem tableHeadFmt           with    "table: format used for the table head row"
Add object themeitem tableNameFmt           with    "table: format used for the object/element name"
Add object themeitem tableSeparator         with    "table: string separating name and description"
Add object themeitem tableDescrFmt          with    "table: format used for the object/element description"
Add object themeitem tableValueFmt          with    "table: format used for the object/element values"
Add object themeitem tableOriginFmt         with    "table: format for origin string"
Add object themeitem tableSourceFmt         with    "table: format for source string"
Add object themeitem tableArgFmt            with    "table: format used for the argument (option/clioption)"
Add object themeitem tableBgrndFmt          with    "table: format for the background"


Add object themeitem describeNameFmt    with    "describe: format used for the object/element name"
Add object themeitem describeSeparator  with    "describe: string separating name and description"
Add object themeitem describeDescrFmt   with    "describe: format used for the object/element description"
Add object themeitem describeArgFmt     with    "describe: format used for the argument (option/clioption)"
Add object themeitem describeBgrndFmt   with    "describe: format for the background"



Add object themeitem phaLvlSetChar              with    "character for level being set"
Add object themeitem phaLvlNotsetChar           with    "character for level not being set"
Add object themeitem phaLvlNotsetFmt            with    "format for level not being set"
    Add object themeitem phaLvlFatalSetFmt      with    "format for level 'fatalerror' set"
    Add object themeitem phaLvlErrorSetFmt      with    "format for level 'error' set"
    Add object themeitem phaLvlWarningSetFmt    with    "format for level 'warning' set"
    Add object themeitem phaLvlInfoSetFmt       with    "format for level 'info' set"
    Add object themeitem phaLvlDebugSetFmt      with    "format for level 'debug' set"
    Add object themeitem phaLvlTraceSetFmt      with    "format for level 'trace' set"
    Add object themeitem phaLvlMessageSetFmt    with    "format for level 'message' set"
    Add object themeitem phaLvlTextSetFmt       with    "format for level 'text' set"



Add object themeitem phaseCLIChar       with    "character for phase CLI"
Add object themeitem phaseCLIFmt        with    "format for phase CLI"
Add object themeitem phaseDefaultChar   with    "character for phase Default (value)"
Add object themeitem phaseDefaultFmt    with    "format for phase Default (value)"
Add object themeitem phaseEnvChar       with    "character for phase Env"
Add object themeitem phaseEnvFmt        with    "format for phase Env"
Add object themeitem phaseFileChar      with    "character for phase File"
Add object themeitem phaseFileFmt       with    "format for phase File"
Add object themeitem phaseLoadChar      with    "character for phase Load"
Add object themeitem phaseLoadFmt       with    "format for phase Load"
Add object themeitem phaseProjectChar   with    "character for phase Project"
Add object themeitem phaseProjectFmt    with    "format for phase Project"
Add object themeitem phaseScenarioChar  with    "character for phase Scenario"
Add object themeitem phaseScenarioFmt   with    "format for phase Scenario"
Add object themeitem phaseScriptChar    with    "character for phase Script"
Add object themeitem phaseScriptFmt     with    "format for phase Script"
Add object themeitem phaseShellChar     with    "character for phase Shell"
Add object themeitem phaseShellFmt      with    "format for phase Shell"
Add object themeitem phaseSiteChar      with    "character for phase Site"
Add object themeitem phaseSiteFmt       with    "format for phase Site"
Add object themeitem phaseTaskChar      with    "character for phase Task"
Add object themeitem phaseTaskFmt       with    "format for phase Task"



Add object themeitem elementStatusNFmt      with    "format for element status not-tested"
Add object themeitem elementStatusNChar     with    "character for element status not-tested"
Add object themeitem elementStatusEFmt      with    "format for element status error"
Add object themeitem elementStatusEChar     with    "character for element status error"
Add object themeitem elementStatusWFmt      with    "format for element status warning"
Add object themeitem elementStatusWChar     with    "character for element status warning"
Add object themeitem elementStatusSFmt      with    "format for element status success"
Add object themeitem elementStatusSChar     with    "character for element status success"

Add object themeitem elementModeYesFmt      with    "format for element available in mode"
Add object themeitem elementModeYesChar     with    "character for element available in mode"
Add object themeitem elementModeNoFmt       with    "format for element not available in mode"
Add object themeitem elementModeNoChar      with    "character for element not available in mode"

Add object themeitem elementDefYesFmt       with    "format for parameter default value 'yes'"
Add object themeitem elementDefYesChar      with    "character for parameter default value 'yes'"
Add object themeitem elementDefNoFmt        with    "format for parameter default value 'no'"
Add object themeitem elementDefNoChar       with    "character for parameter default value 'no'"

Add object themeitem elementExexYesFmt      with    "format for execute show status value 'yes'"
Add object themeitem elementExexYesChar     with    "character for execute show status value 'yes'"
Add object themeitem elementExexNoFmt       with    "format for execute show status value 'no'"
Add object themeitem elementExexNoChar      with    "character for execute show status value 'no'"



Add object themeitem repeatLineChar         with    "repeat execution: line character"
Add object themeitem repeatLineFmt          with    "repeat execution: line format"
Add object themeitem repeatSepLeftChar      with    "repeat execution: left separator character"
Add object themeitem repeatSepLeftFmt       with    "repeat execution: left separator format"
Add object themeitem repeatSepRightChar     with    "repeat execution: right separator character"
Add object themeitem repeatSepRightFmt      with    "repeat execution: right separator format"
Add object themeitem repeatTextFmt          with    "repeat execution: text format"
Add object themeitem repeatTextSepStr       with    "repeat execution: text separator string"
Add object themeitem repeatCmdFmt           with    "repeat execution: command format"
Add object themeitem repeatScnBgrndFmt      with    "repeat execution: background format for scenario execution"
Add object themeitem repeatScrBgrndFmt      with    "repeat execution: background format for script execution"
Add object themeitem repeatTskBgrndFmt      with    "repeat execution: background format for task execution"



Add object themeitem execLineChar           with    "text line character, empty means no line printed"
Add object themeitem execLineFmt            with    "text line format"
Add object themeitem execStartNameFmt       with    "format for task name/id"
Add object themeitem execStartTimeFmt       with    "format for start time"
Add object themeitem execStartTextFmt       with    "format for text 'executing ...'"
Add object themeitem execEndDoneFmt         with    "format for 'done'"
Add object themeitem execEndTimeFmt         with    "format for end time"
Add object themeitem execEndRuntimeFmt      with    "format for runtime"
Add object themeitem execEndStatusFmt       with    "format for status text"
Add object themeitem execEndSuccessFmt      with    "format for success status"
Add object themeitem execEndErrorFmt        with    "format for error status"
Add object themeitem execEndWarningFmt      with    "format for warning status"
Add object themeitem execStartRuleChar      with    "start rule character, empty means no rule printed"
Add object themeitem execStartRuleFmt       with    "start rule format"
Add object themeitem execEndRuleChar        with    "end rule character, empty means no rule printed"
Add object themeitem execEndRuleFmt         with    "end rule format"

Add object themeitem execPrjBgrndFmt        with    "background format for project execution"
Add object themeitem execScnBgrndFmt        with    "background format for scenario execution"
Add object themeitem execScrBgrndFmt        with    "background format for script execution"
Add object themeitem execSitBgrndFmt        with    "background format for site execution"
Add object themeitem execTskBgrndFmt        with    "background format for task execution"



Add object themeitem explainTitleFmt        with    "explain: title format"
Add object themeitem explainTextFmt         with    "explain: text format"
Add object themeitem explainComponentFmt    with    "explain: format for component name"
Add object themeitem explainOperationFmt    with    "explain: format for operation names"
Add object themeitem explainArgFmt          with    "explain: format for operation arguments"

Add object themeitem explainIndent1         with    "explain: indentation for string 'Available ...'"
Add object themeitem explainIndent2         with    "explain: indentation for commands"
Add object themeitem explainIndent3         with    "explain: indentation for command descriptions"



Add object themeitem xIsSetFmt              with    "format for (x) is set"
Add object themeitem xIsSetChar             with    "character for (x) is set"
Add object themeitem xIsNotSetFmt           with    "format for (x) is not set"
Add object themeitem xIsNotSetChar          with    "character for (x) is not set"
Add object themeitem xHasValueFmt           with    "format for (x) has (a) value"
Add object themeitem xHasValueChar          with    "character for (x) has (a) value"
Add object themeitem xHasNoValueFmt         with    "format for (x) has no value"
Add object themeitem xHasNoValueChar        with    "character for (x) has no value"



Add object themeitem numError0Fmt           with    "format for errors, 0"
Add object themeitem numError1Fmt           with    "format for errors, 1 - 99"
Add object themeitem numError100Fmt         with    "format for errors, 100 - 9999"
Add object themeitem numError10000Fmt       with    "format for errors, > 9999"

Add object themeitem numWarning0Fmt         with    "format for warnings, 0"
Add object themeitem numWarning1Fmt         with    "format for warnings, 1 - 99"
Add object themeitem numWarning100Fmt       with    "format for warnings, 100 - 9999"
Add object themeitem numWarning10000Fmt     with    "format for warnings, > 9999"

Add object themeitem numMessage0Fmt         with    "format for message, 0"
Add object themeitem numMessage1Fmt         with    "format for message, 1 - 99"
Add object themeitem numMessage100Fmt       with    "format for messages, 100 - 9999"
Add object themeitem numMessage10000Fmt     with    "format for messages, > 9999"

Add object themeitem numReqin0Fmt           with    "format for 'required by', 0"
Add object themeitem numReqin1Fmt           with    "format for 'required by', 1 - 99"
Add object themeitem numReqin100Fmt         with    "format for 'required by', 100 - 9999"
Add object themeitem numReqin10000Fmt       with    "format for 'required by', > 9999"

Add object themeitem numReqout0Fmt          with    "format for 'requires', 0"
Add object themeitem numReqout1Fmt          with    "format for 'requires', 1 - 99"
Add object themeitem numReqout100Fmt        with    "format for 'requires', 100 - 9999"
Add object themeitem numReqout10000Fmt      with    "format for 'required by', > 9999"



Add object themeitem statsFullruleChar      with    "character for statistics full rule"
Add object themeitem statsFullruleFmt       with    "format for statistics full rule"
Add object themeitem statsHalfruleChar      with    "character for statistics half rule"
Add object themeitem statsHalfruleFmt       with    "format for statistics half rule"

