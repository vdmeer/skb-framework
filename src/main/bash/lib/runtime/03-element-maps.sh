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
## Runtime / Elements - fill runtime information for elements
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_COMPONENTS_SINGULAR["Applications"]="application"
FW_COMPONENTS_PLURAL["Applications"]="applications"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Applications"]="Application"
FW_COMPONENTS_TITLE_LONG_PLURAL["Applications"]="Applications"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Applications"]="Application"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Applications"]="Applications"
FW_COMPONENTS_TABLE_DESCR["Applications"]="Description"
FW_COMPONENTS_TABLE_VALUE["Applications"]="Command"
FW_COMPONENTS_TABLE_EXTRA["Applications"]="MD/P A R S P"
FW_COMPONENTS_TAGLINE["Applications"]="element representing (external) applications"



FW_COMPONENTS_SINGULAR["Dependencies"]="dependency"
FW_COMPONENTS_PLURAL["Dependencies"]="dependencies"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Dependencies"]="Dependency"
FW_COMPONENTS_TITLE_LONG_PLURAL["Dependencies"]="Dependencies"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Dependencies"]="Dependency"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Dependencies"]="Dependencies"
FW_COMPONENTS_TABLE_DESCR["Dependencies"]="Description"
FW_COMPONENTS_TABLE_VALUE["Dependencies"]="Command"
FW_COMPONENTS_TABLE_EXTRA["Dependencies"]="MD/P REQ R S"
FW_COMPONENTS_TAGLINE["Dependencies"]="element representing dependencies"



FW_COMPONENTS_SINGULAR["Dirlists"]="dirlist"
FW_COMPONENTS_PLURAL["Dirlists"]="dirlists"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Dirlists"]="Directory List"
FW_COMPONENTS_TITLE_LONG_PLURAL["Dirlists"]="Directory Lists"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Dirlists"]="Dir List"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Dirlists"]="Dir Lists"
FW_COMPONENTS_TABLE_DESCR["Dirlists"]="Description"
FW_COMPONENTS_TABLE_VALUE["Dirlists"]="Directories"
FW_COMPONENTS_TABLE_EXTRA["Dirlists"]="MD/P R S P Modes"
FW_COMPONENTS_TAGLINE["Dirlists"]="element representing directory lists"



FW_COMPONENTS_SINGULAR["Dirs"]="dir"
FW_COMPONENTS_PLURAL["Dirs"]="dirs"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Dirs"]="Directory"
FW_COMPONENTS_TITLE_LONG_PLURAL["Dirs"]="Directories"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Dirs"]="Directory"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Dirs"]="Directories"
FW_COMPONENTS_TABLE_DESCR["Dirs"]="Description"
FW_COMPONENTS_TABLE_VALUE["Dirs"]="Directory"
FW_COMPONENTS_TABLE_EXTRA["Dirs"]="MD/P R S P Modes"
FW_COMPONENTS_TAGLINE["Dirs"]="element representing directories"



FW_COMPONENTS_SINGULAR["Filelists"]="filelist"
FW_COMPONENTS_PLURAL["Filelists"]="filelists"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Filelists"]="File List"
FW_COMPONENTS_TITLE_LONG_PLURAL["Filelists"]="File Lists"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Filelists"]="File List"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Filelists"]="File Lists"
FW_COMPONENTS_TABLE_DESCR["Filelists"]="Description"
FW_COMPONENTS_TABLE_VALUE["Filelists"]="Files"
FW_COMPONENTS_TABLE_EXTRA["Filelists"]="MD/P R S P Modes"
FW_COMPONENTS_TAGLINE["Filelists"]="element representing file lists"



FW_COMPONENTS_SINGULAR["Files"]="file"
FW_COMPONENTS_PLURAL["Files"]="files"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Files"]="File"
FW_COMPONENTS_TITLE_LONG_PLURAL["Files"]="Files"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Files"]="File"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Files"]="Files"
FW_COMPONENTS_TABLE_DESCR["Files"]="Description"
FW_COMPONENTS_TABLE_VALUE["Files"]="File"
FW_COMPONENTS_TABLE_EXTRA["Files"]="MD/P R S P Modes"
FW_COMPONENTS_TAGLINE["Files"]="element representing files"



FW_COMPONENTS_SINGULAR["Modules"]="module"
FW_COMPONENTS_PLURAL["Modules"]="modules"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Modules"]="Module"
FW_COMPONENTS_TITLE_LONG_PLURAL["Modules"]="Modules"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Modules"]="Module"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Modules"]="Modules"
FW_COMPONENTS_TABLE_DESCR["Modules"]="Description"
FW_COMPONENTS_TABLE_VALUE["Modules"]="Path to Module"
FW_COMPONENTS_TABLE_EXTRA["Modules"]="SH REQ P"
FW_COMPONENTS_TAGLINE["Modules"]="element representing modules"



FW_COMPONENTS_SINGULAR["Options"]="option"
FW_COMPONENTS_PLURAL["Options"]="options"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Options"]="Option"
FW_COMPONENTS_TITLE_LONG_PLURAL["Options"]="Options"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Options"]="Option"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Options"]="Options"
FW_COMPONENTS_TABLE_DESCR["Options"]="Description"
FW_COMPONENTS_TABLE_VALUE["Options"]="Value from Command Line"
FW_COMPONENTS_TABLE_EXTRA["Options"]="Type"
FW_COMPONENTS_TAGLINE["Options"]="element representing options"



FW_COMPONENTS_SINGULAR["Parameters"]="parameter"
FW_COMPONENTS_PLURAL["Parameters"]="parameters"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Parameters"]="Parameter"
FW_COMPONENTS_TITLE_LONG_PLURAL["Parameters"]="Parameters"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Parameters"]="Parameter"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Parameters"]="Parameters"
FW_COMPONENTS_TABLE_DESCR["Parameters"]="Description"
FW_COMPONENTS_TABLE_VALUE["Parameters"]="Value"
FW_COMPONENTS_TABLE_DEFVAL["Parameters"]="Default Value"
FW_COMPONENTS_TABLE_EXTRA["Parameters"]="MD/P D R S P"
FW_COMPONENTS_TAGLINE["Parameters"]="element representing parameters"



FW_COMPONENTS_SINGULAR["Projects"]="project"
FW_COMPONENTS_PLURAL["Projects"]="projects"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Projects"]="Project"
FW_COMPONENTS_TITLE_LONG_PLURAL["Projects"]="Projects"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Projects"]="Project"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Projects"]="Projects"
FW_COMPONENTS_TABLE_DESCR["Projects"]="Description"
FW_COMPONENTS_TABLE_VALUE["Projects"]="Path to Project"
FW_COMPONENTS_TABLE_EXTRA["Projects"]="MD/P REQ X S T D B U"
FW_COMPONENTS_TAGLINE["Projects"]="element representing projects"



FW_COMPONENTS_SINGULAR["Scenarios"]="scenario"
FW_COMPONENTS_PLURAL["Scenarios"]="scenarios"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Scenarios"]="Scenario"
FW_COMPONENTS_TITLE_LONG_PLURAL["Scenarios"]="Scenarios"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Scenarios"]="Scenario"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Scenarios"]="Scenarios"
FW_COMPONENTS_TABLE_DESCR["Scenarios"]="Description"
FW_COMPONENTS_TABLE_VALUE["Scenarios"]="Path to Scenario"
FW_COMPONENTS_TABLE_EXTRA["Scenarios"]="MD/P REQ X S T D B U"
FW_COMPONENTS_TAGLINE["Scenarios"]="element representing scenarios"



FW_COMPONENTS_SINGULAR["Scripts"]="script"
FW_COMPONENTS_PLURAL["Scripts"]="scripts"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Scripts"]="Script"
FW_COMPONENTS_TITLE_LONG_PLURAL["Scripts"]="Scripts"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Scripts"]="Script"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Scripts"]="Scripts"
FW_COMPONENTS_TABLE_DESCR["Scripts"]="Description"
FW_COMPONENTS_TABLE_VALUE["Scripts"]="Path to Script"
FW_COMPONENTS_TABLE_EXTRA["Scripts"]="MD/P REQ X"
FW_COMPONENTS_TAGLINE["Scripts"]="element representing sites"



FW_COMPONENTS_SINGULAR["Sites"]="site"
FW_COMPONENTS_PLURAL["Sites"]="sites"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Sites"]="Site"
FW_COMPONENTS_TITLE_LONG_PLURAL["Sites"]="Sites"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Sites"]="Site"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Sites"]="Sites"
FW_COMPONENTS_TABLE_DESCR["Sites"]="Description"
FW_COMPONENTS_TABLE_VALUE["Sites"]="Description"
FW_COMPONENTS_TABLE_EXTRA["Sites"]="MD/P REQ X"
FW_COMPONENTS_TAGLINE["Sites"]="element representing sites"



FW_COMPONENTS_SINGULAR["Tasks"]="task"
FW_COMPONENTS_PLURAL["Tasks"]="tasks"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Tasks"]="Task"
FW_COMPONENTS_TITLE_LONG_PLURAL["Tasks"]="Tasks"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Tasks"]="Task"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Tasks"]="Tasks"
FW_COMPONENTS_TABLE_DESCR["Tasks"]="Description"
FW_COMPONENTS_TABLE_VALUE["Tasks"]="Path to Task"
FW_COMPONENTS_TABLE_EXTRA["Tasks"]="MD/P REQ X R S T D B U"
FW_COMPONENTS_TAGLINE["Tasks"]="element representing tasks"


