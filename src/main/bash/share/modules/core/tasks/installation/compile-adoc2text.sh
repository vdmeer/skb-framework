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
## compile-adoc2text - task that compiles ADOC sources to plain text
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option target-all

Cli add general option  framework     f   ""  "compile framework ADOC files"        "Targets"
Cli add general option  modules       m   ""  "compile ADOC files for all modules"  "Targets"

Parse cli arguments "Options Targets" $*


############################################################################################
##
## test CLI
##
############################################################################################
targets="framework modules"

if [[ "${FW_PARSED_ARG_MAP[A]:-${FW_PARSED_ARG_MAP[all]:-no}}" == no ]]; then
    if [[ "${FW_PARSED_ARG_MAP[f]:-${FW_PARSED_ARG_MAP[framework]:-no}}" == no ]]; then targets=${targets/framework/}; fi
    if [[ "${FW_PARSED_ARG_MAP[m]:-${FW_PARSED_ARG_MAP[modules]:-no}}" == no ]]; then targets=${targets/modules/}; fi
fi



############################################################################################
##
## compile function
##
############################################################################################
function compile() {
    local jar="${1}" dir="${2}" printDir="${3}" name adocFile textFile

    for adocFile in ${dir}/**/*.adoc; do
        textFile="${adocFile/.adoc/.txt}"
        Test file exists ${adocFile} "${adocFile/$dir/$printDir}"
        Test file can read  ${adocFile} "${adocFile/$dir/$printDir}"
        if [[ -f "${textFile}" ]]; then
            Test file can write ${textFile} "${textFile/$dir/$printDir}"
            rm ${textFile}; touch ${textFile}
        fi
        java -jar ${jar} "$(Convert path "${adocFile}")" l1 >> "$(Convert path "${textFile}")"
    done
}



############################################################################################
##
## compile targets
##
############################################################################################
printf "\n"
read -a keys <<< "${targets}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS

jar="$(Convert path "$(Get element file skb-tool value)")"
for target in "${keys[@]}"; do
    case "${target}" in
        framework)
            compile "${jar}" "${SF_HOME}/lib/text"  "\$SF_HOME/lib/text"
            if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}; fi ;;
        modules)
            if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}; fi ;;
    esac
done
