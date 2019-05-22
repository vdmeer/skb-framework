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
##

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar

RELEASE_VERSION="$(cat src/main/bash/etc/version.txt)"
TOOL_VERSION="${RELEASE_VERSION}"


help(){ 
    printf "\nusage: build [targets]\n"
    printf "\n  targets:"
    printf "\n    all       - build all target in the right order"
    printf "\n    clean     - remove all built artifacts (gradle, maven)"
    printf "\n    dist      - build framework artifacts and then distributions (gradle)"
    printf "\n    mkdirs    - create required directories to run the framework"
    printf "\n    tool      - build SKB Framework Tool (gradle)"
    printf "\n    site      - build the Maven site (maven)"
    printf "\n    versions  - set file versions in comments"
    printf "\n"
    printf "\n Requirements:"
    printf "\n - gradle          - to build the Java tool and the distributions"
    printf "\n - JDK8            - to build the tool"
    printf "\n - Apache Ant      - to set file versions"
    printf "\n - Apache Maven    - to build the site"
    printf "\n - asciidoctor     - to build some targets for the manual"
    printf "\n - asciidoctor-pdf - to build the PDF manual"
    printf "\n - coderay         - for syntax highlighting in ADOC files"
    printf "\n Requirements are not tested, build will simply fail"
    printf "\n\n"
}


if [[ -z "${1:-}" ]]; then
    help
    exit 1
fi



while [[ $# -gt 0 ]]; do
    case "$1" in
        all)
            T_CLEAN=true
            T_DIST=true
            T_TOOL=true
            T_SITE=true
            T_MKDIRS=true
            T_VERSIONS=true
            shift
            ;;
        clean)
            T_CLEAN=true
            shift
            ;;
        dist)
            T_DIST=true
            shift
            ;;
        mkdirs)
            T_MKDIRS=true
            shift
            ;;
        tool)
            T_TOOL=true
            shift
            ;;
        site)
            T_SITE=true
            shift
            ;;
        versions)
            T_VERSIONS=true
            shift
            ;;
        -h | --help)
            help
            exit 0
            ;;
        *)
            printf "\nunknown target '$1'\n\n"
            help
            exit 2
            ;;
    esac
done

TS=$(date +%s.%N)
TIME_START=$(date +"%T")
export SF_MVN_SITES=$PWD


if [[ ${T_VERSIONS:-} == true ]]; then
    printf "%s\n\n" "set file versions"
    if [[ -f tool/src/main/resources/tool-version.txt ]]; then
        rm tool/src/main/resources/tool-version.txt
    fi
    cp src/main/bash/etc/version.txt tool/src/main/resources/tool-version.txt
    ant -f ant/build.xml -DmoduleVersion=${RELEASE_VERSION} -DmoduleDir=../
    chmod 644 src/main/bash/**/*.id src/main/bash/**/*.scn tool/src/**/*.java
fi

if [[ ${T_CLEAN:-} == true ]]; then
    printf "%s\n\n" "clean"

    ./gradlew clean
    mvn clean

    (cd tool; ./gradlew clean)
    (cd tool; mvn clean)

    if [[ -d src/main/bash/lib/java ]]; then
        for file in src/main/bash/lib/java/**; do
            if [[ -f $file ]]; then
                rm $file
            fi
        done
        rmdir src/main/bash/lib/java
    fi

    if [[ -d src/main/bash/doc/manual ]]; then
        for file in src/main/bash/doc/manual/**; do
            if [[ -f $file ]]; then
                rm $file
            fi
        done
        rmdir src/main/bash/doc/manual
        rmdir src/main/bash/doc
    fi

    if [[ -d src/main/bash/man/man1 ]]; then
        for file in src/main/bash/man/man1/**; do
            if [[ -f $file ]]; then
                rm $file
            fi
        done
        rmdir src/main/bash/man/man1
        rmdir src/main/bash/man
    fi

    printf "\n\n"
fi

if [[ ${T_TOOL:-} == true ]]; then
    printf "%s\n\n" "building/copying SKB Tool (java)"
    (cd tool; ./gradlew)
    mkdir -p src/main/bash/lib/java
    cp tool/build/libs/skb-framework-tool-${TOOL_VERSION}-all.jar src/main/bash/lib/java
    printf "\n\n"
fi

if [[ ${T_MKDIRS:-} == true ]]; then
    mkdir -p src/main/bash/man/man1 2> /dev/null
    mkdir -p src/main/bash/doc/manual 2> /dev/null
fi

if [[ ${T_DIST:-} == true ]]; then
    printf "%s\n\n" "building framework distribution artifacts"
    src/main/bash/bin/skb-framework --all-mode --sq --lq --task-level debug --install --run-scenario build-fw-distro

    printf "%s\n\n" "building distributions"
    ./gradlew
    printf "\n\n"
    printf "%s\n" "distributions in ./build/distributions"
    ls -l ./build/distributions
    printf "\n\n"
fi

if [[ ${T_SITE:-} == true ]]; then
    src/main/bash/bin/skb-framework --all-mode --install --execute-task build-mvn-site --sq --lq --task-level debug -- --build --targets --id fw
fi


TE=$(date +%s.%N)

TIME=$(date +"%T")
RUNTIME=$(echo "($TE-$TS)/60" | bc -l)
printf "started:  $TIME_START\n"
printf "finished: $TIME, in $RUNTIME minutes\n\n"

