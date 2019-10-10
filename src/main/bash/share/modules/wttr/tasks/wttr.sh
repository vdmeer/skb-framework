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
## wttr - task that uses CURL to get weather reports from wttr.in
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME:-}" ]]; then printf " $(basename $0): please run from skb-framework\n\n"; exit 10; fi
source ${SF_HOME}/lib/task-runtime.sh

Clioptions add general option  city         c   "CITY"      "city name, e.g. Paris"                             "Location+Type"
Clioptions add general option  country      C   "COUNTRY"   "country name, e.g. France"                         "Location+Type"
Clioptions add general option  place        p   "PLACE"     "a place or general location, e.g. Eiffel+tower"    "Location+Type"
Clioptions add general option  airport      a   "AIRPORT"   "airport, 3 letter IATA code, e.g. wat"             "Location+Type"
Clioptions add general option  domain       d   "DOMAIN"    "domain name, e.g. stackoverflow.com"               "Location+Type"
Clioptions add general option  gps          g   "GPS"       "GPS coordinates, e.g. -78.46,106.79"               "Location+Type"
Clioptions add general option  zip          z   "ZIP"       "US (zip) area codes"                               "Location+Type"

Clioptions add general option  metric       m   ""          "use SI units (metric)"                             "Units"
Clioptions add general option  uscs         u   ""          "use USCS units"                                    "Units"
Clioptions add general option  speed        s   ""          "windspeed in m/s"                                  "Units"


Clioptions add general option  now          n   ""          "show the current weather"                          "Period"
Clioptions add general option  today        t   ""          "current and today's weather"                       "Period"
Clioptions add general option  tomorrow     1   ""          "current, today plus 1 day forcast"                 "Period"
Clioptions add general option  two-days     2   ""          "current, today plus 2 day forecast"                "Period"


Clioptions add general option  force-ansi   A   ""          "force ANSI output"                                 "Format"
Clioptions add general option  no-colors    o   ""          "switch off ANSI codes, no colors"                  "Format"
Clioptions add general option  wide         w   ""          "defaultformat: morning, noon, evening, night"      "Format"
Clioptions add general option  narrow       r   ""          "narrow format: day & night"                        "Format"

Parse cli "Options Location+Type Units Period Format" $*


############################################################################################
##
## build CURL command
##
############################################################################################
curlCommand=""


if [[ "${FW_INSTANCE_CLI_SET["city"]}" == "yes" ]]; then
    curlCommand="${FW_INSTANCE_CLI_VAL["city"]}"
elif [[ "${FW_INSTANCE_CLI_SET["country"]}" == "yes" ]]; then
    curlCommand="${FW_INSTANCE_CLI_VAL["country"]}"
elif [[ "${FW_INSTANCE_CLI_SET["place"]}" == "yes" ]]; then
    curlCommand="~${FW_INSTANCE_CLI_VAL["place"]}"
elif [[ "${FW_INSTANCE_CLI_SET["airport"]}" == "yes" ]]; then
    curlCommand="${FW_INSTANCE_CLI_VAL["airport"]}"
elif [[ "${FW_INSTANCE_CLI_SET["domain"]}" == "yes" ]]; then
    curlCommand="@${FW_INSTANCE_CLI_VAL["domain"]}"
elif [[ "${FW_INSTANCE_CLI_SET["gps"]}" == "yes" ]]; then
    curlCommand="${FW_INSTANCE_CLI_VAL["gps"]}"
elif [[ "${FW_INSTANCE_CLI_SET["zip"]}" == "yes" ]]; then
    curlCommand="${FW_INSTANCE_CLI_VAL["zip"]}"
fi


curlCommand+="?F"


if [[ "${FW_INSTANCE_CLI_SET["metric"]}" == "yes" ]]; then
    curlCommand+="&m"
elif [[ "${FW_INSTANCE_CLI_SET["uscs"]}" == "yes" ]]; then
    curlCommand+="&u"
fi
if [[ "${FW_INSTANCE_CLI_SET["speed"]}" == "yes" ]]; then curlCommand+="&M"; fi


if [[ "${FW_INSTANCE_CLI_SET["now"]}" == "yes" ]]; then
    curlCommand+="&0"
elif [[ "${FW_INSTANCE_CLI_SET["today"]}" == "yes" ]]; then
    curlCommand+="&1"
elif [[ "${FW_INSTANCE_CLI_SET["tomorrow"]}" == "yes" ]]; then
    curlCommand+="&2"
elif [[ "${FW_INSTANCE_CLI_SET["two-days"]}" == "yes" ]]; then
    curlCommand+="&3"
fi


if [[ "${FW_INSTANCE_CLI_SET["wide"]}" == "yes" ]]; then
    curlCommand+="&w"
elif [[ "${FW_INSTANCE_CLI_SET["narrow"]}" == "yes" ]]; then
    curlCommand+="&n"
fi


if [[ "${FW_INSTANCE_CLI_SET["force-ansi"]}" == "yes" ]]; then curlCommand+="&A"; fi
if [[ "${FW_INSTANCE_CLI_SET["no-colors"]}" == "yes" ]]; then curlCommand+="&T"; fi



############################################################################################
##
## run curl to get the weather
##
############################################################################################
curl -s "wttr.in/${curlCommand}"
