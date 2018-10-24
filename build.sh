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

HAVE_GRADLE=false
HAVE_MAVEN=false
HAVE_ADOC=false
HAVE_ADOC_PDF=false

if [[ $(command -v gradle) && "$(gradle --version | grep "Gradle 4" | wc -l)" == "1" ]]; then
    printf "%s %s\n" "found gradle" "$(gradle --version | grep "Gradle 4")"
    HAVE_GRADLE=true
else
    printf "%s\n" "did not find gradle version >4, cannot build distribution"
fi

if [[ $(command -v mvn) ]]; then
    printf "%s %s\n" "found maven" "$(mvn -v | grep "Apache Maven")"
    HAVE_MAVEN=true
else
    printf "%s\n" "did not find maven (required for site), cannot build distribution"
fi
if [[ $(command -v asciidoctor) ]]; then
    printf "%s %s\n" "found maven" "$(asciidoctor -v | grep "Asciidoctor")"
    HAVE_ADOC=true
else
    printf "%s\n" "did not find asciidoctor (required for manual), cannot build distribution"
fi

if [[ $(command -v asciidoctor-pdf) ]]; then
    printf "%s %s\n" "found maven" "$(asciidoctor-pdf -v | grep "Asciidoctor")"
    HAVE_ADOC_PDF=true
else
    printf "%s\n" "did not find asciidoctor-pdf (required for manual), cannot build distribution"
fi

if [[ $HAVE_GADLE == false ]]; then
    printf "%s\n" "cannot build distro, no gradle"
elif [[ $HAVE_MAVEN == false ]]; then
    printf "%s\n" "cannot build distro, no maven"
elif [[ $HAVE_ADOC == false ]]; then
    printf "%s\n" "cannot build distro, no asciidoctor"
elif [[ $HAVE_ADOC_PDF == false ]]; then
    printf "%s\n" "cannot build distro, no asciidoctor-pdf"
else
    printf "%s\n" "everyting found for building distribution"
fi

printf "\n"

gradle_clean(){ 
    if [[ $HAVE_GRADLE == true ]]; then
        printf "%s\n\n" "gradle clean"
        gradle -c java.settings clean
        printf "\n\n"
    fi
}

gradle_java(){ 
    if [[ $HAVE_GRADLE == true ]]; then
        printf "%s\n\n" "building/copying SKB Tool (java)"
        gradle -c java.settings
        mkdir -p src/main/bash/bin/java
        cp build/libs/skb-framework-tool-0.0.0-all.jar src/main/bash/bin/java
        printf "\n\n"
    fi
}

skb_fw_help(){ 
    src/main/bash/bin/skb-framework -D -e bdh -S off -L off -T debug
    src/main/bash/bin/skb-framework -h
}

skb_fw_manual(){ 
    if [[ -f src/main/bash/bin/java/skb-framework-tool-0.0.0-all.jar ]]; then
        src/main/bash/bin/skb-framework -e bm -S off -L off -T debug -- -b --src
        printf "\n\n"
    else
        printf "%s\n\n" "no Tool jar, cannot build framework text sources"
    fi

    mkdir -p src/main/bash/doc/manual
    src/main/bash/bin/skb-framework -D -e bm -S off -L off -T debug -- -b --adoc --text
    printf "\n\n"

    if [[ $HAVE_ADOC == true ]]; then
        mkdir -p src/main/bash/man/man1
        src/main/bash/bin/skb-framework -D -e bm -S off -L off -T debug -- -b --manp --html
        printf "\n\n"
    else
        printf "%s\n\n" "no asciidoctor, cannot build manual: manp, html"
    fi

    if [[ $HAVE_ADOC_PDF == true ]]; then
        src/main/bash/bin/skb-framework -D -e bm -S off -L off -T debug -- -b --pdf
        printf "\n\n"
    else
        printf "%s\n\n" "no asciidoctor-pdf, cannot build manual: pdf"
    fi
}

skb_fw_site_sources(){
    printf "%s\n\n" "creating site sources"

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

    printf "%s\n\n" "done"
}

gradle_clean
gradle_java
skb_fw_help
skb_fw_manual
skb_fw_site_sources



exit 0


gradle -c distribution.settings




if [[ $(command -v mvn) ]]; then
    mvn site
else
    printf "\n%s\n\n" "did not find maven, could not build site"
fi
