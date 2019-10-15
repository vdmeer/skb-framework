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
Add object message E801 with    2 "too few arguments, expected ##ARG1##, found ##ARG2##"                            "API"       "##description"
Add object message E802 with    2 "too few arguments, expected at least ##ARG1##, found ##ARG2##"                   "API"       "##description"
Add object message E803 with    1 "unknown command '##ARG1##'"                                                      "API"       "##description"
Add object message E804 with    2 "unknown ##ARG1## '##ARG2##'"                                                     ""          "##description"
Add object message E805 with    2 "unknown ##ARG1## identifier '##ARG2##'"                                          ""          "##description"
Add object message E807 with    2 "##ARG1## identifier '##ARG2##' already defined"                                  "API"       "##description"

Add object message E808 with    1 "long option '##ARG1##' has only 1 character, must be at least 2"                 "CLI"       "##description"
Add object message E809 with    2 "short option '##ARG1##' has ##ARG2## characters, must be 1 or empty"             "CLI"       "##description"
Add object message E813 with    0 "option must have a long identifier"                                              "CLI"       "##description"
Add object message E814 with    0 "found unknown options in command line"                                           "CLI"       "##description"

Add object message E815 with    2 "##ARG1## ##ARG2## should not be empty"                                           "Validate"  "##description"
Add object message E816 with    4 "##ARG1## ##ARG2## has too many characters, expected ##ARG3##, found ##ARG4##"    "Validate"  "##description"
Add object message E817 with    3 "##ARG1## ##ARG2## has no ##ARG3## defined"                                       "Validate"  "##description"

Add object message E820 with    2 "##ARG1## '##ARG2##' does not exist"                                              ""          "##description"
Add object message E821 with    2 "##ARG1## '##ARG2##' is not readable"                                             ""          "##description"
Add object message E822 with    2 "##ARG1## '##ARG2##' is not writeable"                                            ""          "##description"
Add object message E823 with    1 "file '##ARG1##' can not be executed"                                             ""          "##description"
Add object message E824 with    2 "##ARG1## '##ARG2##' can not be created"                                          ""          "##description"
Add object message E825 with    2 "##ARG1## '##ARG2##' can not be deleted"                                          ""          "##description"
Add object message E826 with    2 "found unexpected file ##ARG1## in directory ##ARG2##"                            ""          "##description"

Add object message E827 with    1 "error executing ##ARG1##"                                                        ""          "##description"

Add object message E828 with    2 "##ARG1## API cannot be ##ARG2##"                                                 ""          "##description"

Add object message E829 with    3 "##ARG1## requires a number for ##ARG2## got '##ARG3##'"                          ""          "##description"

Add object message E830 with    2 "cannot set ##ARG1## ##ARG2## count, use Increase, Decrease, or Reset"            ""          "##description"
Add object message E831 with    1 "cannot set ##ARG1## message codes, use Reset"                                    ""          "##description"
Add object message E832 with    2 "cannot set ##ARG1## auto ##ARG2##, use Activate or Deactivate"                   ""          "##description"


Add object message E837 with    1 "module '##ARG1##' is not known, ask Modules to search"                           ""          "##description"
Add object message E838 with    1 "print does not support format '##ARG1##'"                                        ""          "##description"
Add object message E839 with    2 "unknown ##ARG1## mode '##ARG2##', use 'rwxcd'"                                   ""          "##description"

Add object message E835 with    1 "unknown '##ARG1##' argument, use 'yes' or 'no'"                                  ""          "##description"
Add object message E836 with    1 "unknown status '##ARG1##'"                                                       ""          "##description"

Add object message E852 with    1 "'##ARG1##' is not a directory"                                                   ""          "##description"

Add object message E853 with    2 "##ARG1## '##ARG2##' is not tested"                                               ""          "##description"
Add object message E854 with    2 "##ARG1## '##ARG2##' has errors"                                                  ""          "##description"
Add object message E855 with    2 "##ARG1## '##ARG2##' has warnings"                                                ""          "##description"
Add object message E856 with    3 "##ARG1## '##ARG2##' not available in current mode '##ARG3##'"                    ""          "##description"


Add object message E879 with    2 "unknown ##ARG1## property '##ARG2##'"                                            ""          "##description"
Add object message E880 with    1 "0 or a positive integer required, found '##ARG1##'"                              ""          "##description"

Add object message E886 with    3 "did not find command '##ARG1##' for ##ARG2## ##ARG3##"                           ""          "##description"

Add object message E887 with    1 "unknown (CLI) option source '##ARG1##'"                                          ""          "##description"


Add object message E900 with    1 "unknown requirement type '##ARG1##'"                                             ""          "##description"
Add object message E901 with    2 "unknown requirement type for a ##ARG1##: '##ARG2##'"                             ""          "##description"
Add object message E902 with    1 "a ##ARG1## cannot depend on itself"                                              ""          "##description"
Add object message E903 with    2 "unknown ##ARG1## requirement type '##ARG2##'"                                    ""          "##description"
Add object message E904 with    2 "requirement ##ARG1## for ##ARG2## already set"                                    ""          "##description"

Add object message W807 with    3 "##ARG1## identifier '##ARG2##' should start with '##ARG3##'"                     "API"       "##description"

