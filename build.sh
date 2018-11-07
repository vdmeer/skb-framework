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

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar

help(){ 
    printf "\nusage: build [targets]\n"
    printf "\n  targets:"
    printf "\n    all       - build all target"
    printf "\n    clean     - remove all built artifacts"
    printf "\n    dist      - build distributions (gradle)"
    printf "\n    help      - build help files"
    printf "\n    manual    - build manual files"
    printf "\n    tool      - build SKB Tool (gradle)"
    printf "\n    site      - buildsite (maven)"
    printf "\n\n"

}

if [[ -z "${1:-}" ]]; then
    help
    exit 1
fi

HAVE_GRADLE=false
HAVE_MAVEN=false
HAVE_ADOC=false
HAVE_ADOC_PDF=false

if [[ -x gradlew ]]; then
    printf "%s\n" "found gradlew, should work"
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

if [[ $HAVE_GRADLE == false ]]; then
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

clean(){ 
    printf "%s\n\n" "clean"

    if [[ -d ./build ]]; then
        rm -fr ./build
    fi
    if [[ -d ./target ]]; then
        rm -fr ./target
    fi

    if [[ -d src/main/bash/bin/java ]]; then
        for file in src/main/bash/bin/java/**; do
            if [[ -f $file ]]; then
                rm $file
            fi
        done
        rmdir src/main/bash/bin/java
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
}

gradle_java(){ 
    if [[ $HAVE_GRADLE == true ]]; then
        printf "%s\n\n" "building/copying SKB Tool (java)"
        ./gradlew -c java.settings
        mkdir -p src/main/bash/bin/java
        cp build/libs/skb-framework-tool-0.0.0-all.jar src/main/bash/bin/java
        printf "\n\n"
    else
        printf "%s\n\n" "no gradle, cannot build SKB Tool"
    fi
}

skb_fw_help(){ 
    src/main/bash/bin/skb-framework -A -e build-help --sq --lq -T debug
#     src/main/bash/bin/skb-framework -h
}

skb_fw_manual(){ 
    if [[ -f src/main/bash/bin/java/skb-framework-tool-0.0.0-all.jar ]]; then
        src/main/bash/bin/skb-framework -e build-manual --sq --lq -T debug -- -b --src
        printf "\n\n"
    else
        printf "%s\n\n" "no Tool jar, cannot build framework text sources"
    fi

    src/main/bash/bin/skb-framework -A -e build-manual --sq --lq -T debug -- -b --adoc --text --requested
    printf "\n\n"

    if [[ $HAVE_ADOC == true ]]; then
        src/main/bash/bin/skb-framework -A -e build-manual --sq --lq -T debug -- -b --manp --html
        printf "\n\n"
    else
        printf "%s\n\n" "no asciidoctor, cannot build manual: manp, html"
    fi

    if [[ $HAVE_ADOC_PDF == true ]]; then
        src/main/bash/bin/skb-framework -A -e build-manual --sq --lq -T debug -- -b --pdf
        printf "\n\n"
    else
        printf "%s\n\n" "no asciidoctor-pdf, cannot build manual: pdf"
    fi
}

skb_fw_site(){ 
    if [[ $HAVE_MAVEN == true ]]; then
        src/main/bash/bin/skb-framework -A -e build-mvn-site --sq --lq -T debug -- -bt --id fw
    else
        printf "%s\n\n" "no maven found, cannot build site"
    fi
}

distro(){ 
    if [[ $HAVE_GRADLE == true ]]; then
        printf "%s\n\n" "building distributions"
        ./gradlew -c distribution.settings
        printf "\n\n"
        printf "%s\n" "distributions in ./build/distributions"
        ls -l ./build/distributions
        printf "\n\n"
    else
        printf "%s\n\n" "no gradle, cannot build distributions"
    fi
}

makeDirs(){ 
    mkdir -p src/main/bash/man/man1 2> /dev/null
    mkdir -p src/main/bash/doc/manual 2> /dev/null
}


while [[ $# -gt 0 ]]; do
    case "$1" in
        all)
            T_CLEAN=true
            T_DIST=true
            T_HELP=true
            T_MANUAL=true
            T_TOOL=true
            T_SITE=true
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
        help)
            T_HELP=true
            shift
            ;;
        manual)
            T_MANUAL=true
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

if [[ ${T_CLEAN:-} == true ]]; then
    clean
fi
if [[ ${T_TOOL:-} == true ]]; then
    gradle_java
fi
if [[ ${T_HELP:-} == true ]]; then
    makeDirs
    skb_fw_help
fi
if [[ ${T_MANUAL:-} == true ]]; then
    makeDirs
    skb_fw_manual
fi
if [[ ${T_SITE:-} == true ]]; then
    skb_fw_site
fi
if [[ ${T_DIST:-} == true ]]; then
    distro
fi

TE=$(date +%s.%N)

TIME=$(date +"%T")
RUNTIME=$(echo "($TE-$TS)/60" | bc -l)
printf "started:  $TIME_START\n"
printf "finished: $TIME, in $RUNTIME minutes\n\n"

