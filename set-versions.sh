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
## make script for the SKB-Framework
## - runs the SKB-Framework with task make-target-sets
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar

if [[ -f tool/src/main/resources/tool-version.txt ]]; then
    rm tool/src/main/resources/tool-version.txt
fi

RELEASE_VERSION="$(cat src/main/bash/etc/version.txt)"
cp src/main/bash/etc/version.txt tool/src/main/resources/tool-version.txt
ant -f ant/build.xml -DmoduleVersion=${RELEASE_VERSION} -DmoduleDir=../

chmod 644 src/main/bash/**/*.id src/main/bash/**/*.scn tool/src/**/*.java src/**/*.adoc src/**/*.xml
(cd src/package; chmod 644 `find -type f`)
(cd src/site; chmod 644 `find -type f`)
(cd src/doc; chmod 644 `find -type f`)
(cd src/main/images; chmod 644 `find -type f`)
chmod 644 *.skb *.id *.adoc

printf "\n\n"
printf "- make sure that src/main/bash/etc/version.txt has only 1 line\n"
printf "- make sure tool/src/main/resources/tool-version.txt has only 1 line\n"
printf " - README.adoc version is rebuild automatically\n"
printf " - manual version changes required for\n"
printf "   -> pom.xml, tool.pom.xml\n"
printf "   -> src/site/site.xml\n"
printf "   -> set-version.sh\n"
printf "\n\n"
