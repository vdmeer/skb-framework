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
## Options - declare the framework's CLI options
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


    ##
    ##                      LONG                SHORT   ARG         DESCRIPTION                                         CATEGORY
    ##
    Add element option      help                h       ""          "print a help screen with CLI options"              "Exit+Options"
    Add element option      version             v       ""          "show program version"                              "Exit+Options"
    Add element option      format              F       "FORMAT"    "sets format for printed text"                      "Runtime+Options"

    Add element option      runtime-tests       R       ""          "test dependencies and installation"                "Exit+Options"
    Add element option      no-runtime-tests    N       ""          "do not test core dependencies on load"             "Runtime+Options"

    Add element option      execute-task        t       "ID"        "executes task ID, task arguments after '--'"       "Exit+Options"
    Add element option      execute-scenario    s       "ID"        "executes scenario ID"                              "Exit+Options"
    Add element option      execute-command     c       "ID"        "executes command ID, any arguments after '--'"     "Exit+Options"

    Add element option      test-colors         ""      ""          "prints some text with colors"                      "Exit+Options"
    Add element option      test-effects        ""      ""          "prints some text with effects"                     "Exit+Options"
    Add element option      test-characters     ""      ""          "prints some UTF-8 characters"                      "Exit+Options"
    Add element option      test-terminal       ""      ""          "runs color, effect, and character tests"           "Exit+Options"

    Add element option      all-mode            A       ""          "run framework in mode 'all'"                       "Runtime+Options"
    Add element option      dev-mode            D       ""          "run framework in mode 'dev'"                       "Runtime+Options"
    Add element option      build-mode          B       ""          "run framework in mode 'build'"                     "Runtime+Options"
    Add element option      use-mode            U       ""          "run framework in mode 'use'"                       "Runtime+Options"

    Add element option      option              o       "ID"        "print a help screen for the CLI option ID"         "Exit+Options"

    Add element option      config-file         C       "FILE"      "configuration file read during initialization"     "Runtime+Options"

    Add element option      strict-mode         S       ""          "strict mode: treat strict warnings as errors"      "Runtime+Options"


    #Add element option     C   clean-cache          ""          "cleans the application cache"                  "Exit+Options"
    #Add element option     m   manual               ""          "print a manual"                                "Exit+Options"
    #Add element option     V   validate             ""          "validate installation"                         "Exit+Options"
