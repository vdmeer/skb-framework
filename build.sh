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
## Build script for the SKB Framework
## - builds all artifacts for distributions
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##

HAVE_GRADLE=1
HAVE_MAVEN=1
HAVE_ADOC=1
HAVE_ADOC_PDF=1

if [[ $(command -v gradle) && "$(gradle --version | grep "Gradle 4" | wc -l)" != "1" ]]; then
    HAVE_GRADLE=0
fi
if [[ $(command -v mvn) ]]; then
    HAVE_MAVEN=0
fi
if [[ $(command -v asciidoctor) ]]; then
    HAVE_ADOC=0
fi
if [[ $(command -v asciidoctor-pdf) ]]; then
    HAVE_ADOC=0
fi

if [[ ! $(command -v gradle) ]]; then
    printf "%s\n\n" "requires gradle"
    exit 1
fi
if [[ "$(gradle --version | grep "Gradle 4" | wc -l)" != "1" ]]; then
    printf "%s\n\n" "requires gradle version 4"
    exit 1
fi

gradle -c java.settings clean
gradle -c java.settings

mkdir -p src/main/bash/doc/manual
mkdir -p src/main/bash/man/man1
mkdir -p src/main/bash/cache

mkdir -p src/main/bash/bin/java
cp build/libs/skb-framework-tool-0.0.0-all.jar src/main/bash/bin/java

#TOOL_DIR=`(cd build/libs;pwd)`
export SF_SKB_FW_TOOL=$TOOL_DIR/skb-framework-tool-0.0.0-all.jar
src/main/bash/bin/skb-framework -c
src/main/bash/bin/skb-framework -D -e bdh -S off -L off
src/main/bash/bin/skb-framework -h

mkdir -p src/main/bash/doc/manual
mkdir -p src/main/bash/man/man1
src/main/bash/bin/skb-framework -D -e bm -S off -L off -- -b --adoc --text --manp

gradle -c distribution.settings


src/main/bash/bin/skb-framework -L off -S off -T info -e de -- --options --print-mode adoc > ./src/site/asciidoc/elements/options.adoc
printf "== List of exit options\n" > ./src/site/asciidoc/elements/option-exit-list.adoc
src/main/bash/bin/skb-framework -L off -S off -T info -e "do" -- --exit --print-mode adoc >> ./src/site/asciidoc/elements/option-exit-list.adoc
printf "== List of runtime options\n" > ./src/site/asciidoc/elements/option-run-list.adoc
src/main/bash/bin/skb-framework -L off -S off -T info -e "do" -- --run --print-mode adoc >> ./src/site/asciidoc/elements/option-run-list.adoc

src/main/bash/bin/skb-framework -L off -S off -T info -e de -- --commands --print-mode adoc > ./src/site/asciidoc/elements/commands.adoc
printf "== List of shell commands\n" > ./src/site/asciidoc/elements/command-list.adoc
src/main/bash/bin/skb-framework -L off -S off -T info -e dc -- --all --print-mode adoc >> ./src/site/asciidoc/elements/command-list.adoc

src/main/bash/bin/skb-framework -L off -S off -T info -e de -- --parameters --print-mode adoc > ./src/site/asciidoc/elements/parameters.adoc
printf "== List of parameters\n" > ./src/site/asciidoc/elements/parameter-list.adoc
src/main/bash/bin/skb-framework -L off -S off -T info -e dp -- --all --print-mode adoc >> ./src/site/asciidoc/elements/parameter-list.adoc

src/main/bash/bin/skb-framework -L off -S off -T info -e de -- --dependencies --print-mode adoc > ./src/site/asciidoc/elements/dependencies.adoc
printf "== List of dependencies\n" > ./src/site/asciidoc/elements/dependency-list.adoc
src/main/bash/bin/skb-framework -L off -S off -T info -e dd -- --all --print-mode adoc >> ./src/site/asciidoc/elements/dependency-list.adoc

src/main/bash/bin/skb-framework -L off -S off -T info -e de -- --tasks --print-mode adoc > ./src/site/asciidoc/elements/tasks.adoc
printf "== List of tasks\n" > ./src/site/asciidoc/elements/task-list.adoc
src/main/bash/bin/skb-framework -L off -S off -T info -e dt -- --all --print-mode adoc >> ./src/site/asciidoc/elements/task-list.adoc


if [[ $(command -v mvn) ]]; then
    mvn site
else
    printf "\n%s\n\n" "did not find maven, could not build site"
fi
