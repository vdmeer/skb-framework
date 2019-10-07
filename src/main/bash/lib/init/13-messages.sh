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
## Messages - declare the famework messages
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


    ##
    ## NAME CATEGORY ARGUMENTS MESSAGE DESCRIPTION
    ##
    Add Object Message E801 2 "too few arguments, expected ##ARG1##, found ##ARG2##"                "API"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E802 2 "too few arguments, expected at least ##ARG1##, found ##ARG2##"       "API"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E803 1 "unknown command '##ARG1##'"                                          "API"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E804 2 "unknown ##ARG1## '##ARG2##'"                                         ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E805 2 "unknown ##ARG1## identifier '##ARG2##'"                              ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E807 2 "##ARG1## identifier '##ARG2##' already defined"                      "API"   "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E808 2 "##ARG1## long ID '##ARG2##' already defined as short ID"             "CLI"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E809 2 "##ARG1## short ID '##ARG2##' already defined as long ID"             "CLI"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E810 2 "##ARG1## option '##ARG2##' already defined"                          "CLI"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E811 1 "long option '##ARG1##' already defined as short option"              "CLI"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E812 1 "short option '##ARG1##' already defined as long option"              "CLI"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E813 0 "option must have a long identifier"                                  "CLI"   "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E814 0 "found unknown options in command line"                               "CLI"   "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E820 2 "##ARG1## '##ARG2##' does not exist"                                  ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E821 2 "##ARG1## '##ARG2##' is not readable"                                 ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E822 2 "##ARG1## '##ARG2##' is not writeable"                                ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E823 1 "file '##ARG1##' can not be executed"                                 ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E824 2 "##ARG1## '##ARG2##' can not be created"                              ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E825 2 "##ARG1## '##ARG2##' can not be deleted"                              ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E826 2 "found unexpected file ##ARG1## in directory ##ARG2##"                ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E827 2 "error executing ##ARG1## '##ARG2##'"                                 ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E828 2 "##ARG1## API cannot be ##ARG2##"                                     ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E829 3 "##ARG1## requires a number for ##ARG2## got '##ARG3##'"              ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E837 1 "module '##ARG1##' is not known, ask Modules to search"               ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E838 1 "print does not support format '##ARG1##'"                            ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E839 2 "unknown ##ARG1## mode '##ARG2##', use 'rwxcd'"                       ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E835 1 "unknown '##ARG1##' argument, use 'yes' or 'no'"                      ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E836 1 "unknown status '##ARG1##'"                                           ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E852 1 "'##ARG1##' is not a directory"                                       ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E853 2 "##ARG1## '##ARG2##' is not tested"                                   ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E854 2 "##ARG1## '##ARG2##' has errors"                                      ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E855 2 "##ARG1## '##ARG2##' has warnings"                                    ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E856 3 "##ARG1## '##ARG2##' not available in current mode '##ARG3##'"        ""      "${SF_HOME}/lib/text/messages" "##description"


    Add Object Message E879 2 "unknown ##ARG1## property '##ARG2##'"                                ""      "${SF_HOME}/lib/text/messages" "##description"


    Add Object Message E882 1 "error count needs to be 0 or a positive integer, found '##ARG1##'"   ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E883 1 "warning count needs to be 0 or a positive integer, found '##ARG1##'" ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E886 3 "did not find command '##ARG1##' for ##ARG2## ##ARG3##"               ""      "${SF_HOME}/lib/text/messages" "##description"

    Add Object Message E887 1 "unknown (CLI) option source '##ARG1##'"                              ""      "${SF_HOME}/lib/text/messages" "##description"


    Add Object Message E900 1 "unknown requirement type '##ARG1##'"                                 ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E901 2 "unknown requirement type for a ##ARG1##: '##ARG2##'"                 ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E902 1 "a ##ARG1## cannot depend on itself"                                  ""      "${SF_HOME}/lib/text/messages" "##description"
    Add Object Message E903 2 "unknown ##ARG1## requirement type '##ARG2##'"                        ""      "${SF_HOME}/lib/text/messages" "##description"






    ##Errorcodes add code    "002"  "bash"          "did not find 'bash' major version 4 or higher"
    ##Errorcodes add code    "003"  "bash"          "did not find 'bash' minor version 2 or higher"
    ##Errorcodes add code    "004"  "command"       "did not find command 'realpath'"
    ##Errorcodes add code    "005"  "directory"     "\$SF_HOME as #s# is not a directory"



    Add Object Message W807 3 "##ARG1## identifier '##ARG2##' should start with '##ARG3##'"         "API"   "${SF_HOME}/lib/text/messages" "##description"

