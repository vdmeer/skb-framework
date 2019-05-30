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
## Functions for printing ansi colors and effects
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##


##
## function: PrintColor()
## - prints message in color
## $1: color: black, red, green, brown, blue, purple, cyan, light-gray, dark-gray
##            light-red, light-green, yellow, light-blue, light-purple, light-cyan
## $2: message
## $3: print mode, opional
## - does not print a line feed
##
PrintColor() {
    local PRINT_MODE=${3:-}
    if [[ "$PRINT_MODE" == "" ]]; then
        PRINT_MODE=${CONFIG_MAP["PRINT_MODE"]}
    fi

    case $PRINT_MODE in
        ansi)
            case "$1" in
                black)          printf "${COLORS["BLACK"]}" ;;
                red)            printf "${COLORS["RED"]}" ;;
                green)          printf "${COLORS["GREEN"]}" ;;
                brown)          printf "${COLORS["BROWN"]}" ;;
                blue)           printf "${COLORS["BLUE"]}" ;;
                purple)         printf "${COLORS["PURPLE"]}" ;;
                cyan)           printf "${COLORS["CYAN"]}" ;;
                light-gray)     printf "${COLORS["LIGHT_GRAY"]}" ;;
                dark-gray)      printf "${COLORS["DARK_GRAY"]}" ;;
                light-red)      printf "${COLORS["LIGHT_RED"]}" ;;
                light-green)    printf "${COLORS["LIGHT_GREEN"]}" ;;
                yellow)         printf "${COLORS["YELLOW"]}" ;;
                light-blue)     printf "${COLORS["LIGHT_BLUE"]}" ;;
                light-purple)   printf "${COLORS["LIGHT_PURPLE"]}" ;;
                light-cyan)     printf "${COLORS["LIGHT_CYAN"]}" ;;
                *)              ConsoleError "  -->" "print-color: unknown color: $1"
            esac
            printf "%s${COLORS["WHITE"]}${COLORS["NORMAL"]}" "$2"
            ;;
        text | text-anon | adoc)
            printf "%s" "$2" ;;
    esac
}



##
## function: PrintEffect()
## - prints message using ANSI effects
## $1: effect: bold, italic, reverse
## $2: message
## $3: print mode, opional
## - does not print a line feed
##
PrintEffect() {
    local PRINT_MODE=${3:-}
    if [[ "$PRINT_MODE" == "" ]]; then
        PRINT_MODE=${CONFIG_MAP["PRINT_MODE"]}
    fi

    case $PRINT_MODE in
        ansi)
            case "$1" in
                bold)           printf "${EFFECTS["INT_BOLD"]}%s${EFFECTS["INT_FAINT"]}${COLORS["WHITE"]}${COLORS["NORMAL"]}" "$2" ;;
                italic)         printf "${EFFECTS["ITALIC_ON"]}%s${EFFECTS["ITALIC_OFF"]}${COLORS["WHITE"]}${COLORS["NORMAL"]}" "$2" ;;
                reverse)        printf "${EFFECTS["REVERSE_ON"]}%s${EFFECTS["REVERSE_OFF"]}" "$2" ;;
                *)              ConsoleError "  -->" "print-effect: unknown effect: $1"
            esac
            ;;
        text)                   printf "%s" "$2" ;;
        adoc | text-anon)
            case "$1" in
                bold)           printf "*%s*" "$2" ;;
                italic)         printf "_%s_" "$2" ;;
                reverse)        printf "%s" "$2" ;;
                *)              ConsoleError "  -->" "print-effect: unknown effect: $1"
            esac
            ;;
    esac
}



##
## function: PrintTestColors
## - prints lines to test terminal ANSI color capabilities and show alternatives for other print modes
##
PrintTestColors() {
    printf "\n  Tests for ANSI colors and alternative representations"

    printf "\n  - print mode: ansi: "
        printf "\n    - "; PrintColor black black ansi
            printf ", "; PrintColor red red ansi
            printf ", "; PrintColor green green ansi
            printf ", "; PrintColor brown brown ansi
            printf ", "; PrintColor blue blue ansi
            printf ", "; PrintColor purple purple ansi
            printf ", "; PrintColor cyan cyan ansi
            printf ", "; PrintColor dark-gray dark-gray ansi
        printf "\n    - "; PrintColor light-gray light-gray ansi
            printf ", "; PrintColor light-red light-red ansi
            printf ", "; PrintColor light-green light-green ansi
            printf ", "; PrintColor yellow yellow ansi
            printf ", "; PrintColor light-blue light-blue ansi
            printf ", "; PrintColor light-purple light-purple ansi
            printf ", "; PrintColor light-cyan light-cyan ansi
    printf "\n"

    printf "\n  - print modes: text, text-anon, adoc: "
        printf "\n    - "; PrintColor black black text
            printf ", "; PrintColor red red text
            printf ", "; PrintColor green green text
            printf ", "; PrintColor brown brown text
            printf ", "; PrintColor blue blue text
            printf ", "; PrintColor purple purple text
            printf ", "; PrintColor cyan cyan text
            printf ", "; PrintColor dark-gray dark-gray text
        printf "\n    - "; PrintColor light-gray light-gray text
            printf ", "; PrintColor light-red light-red text
            printf ", "; PrintColor light-green light-green text
            printf ", "; PrintColor yellow yellow text
            printf ", "; PrintColor light-blue light-blue text
            printf ", "; PrintColor light-purple light-purple text
            printf ", "; PrintColor light-cyan light-cyan text
    printf "\n"
}



##
## function: PrintTestEffects()
## - prints lines to test terminal ANSI effect capabilities and show alternatives for other print modes
##
PrintTestEffects() {
    printf "\n  Tests for ANSI effects and alternative representations"

    printf "\n  - print mode: ansi: "
        printf "\n    - "; PrintEffect bold bold ansi
            printf ", "; PrintEffect italic italic ansi
            printf ", "; PrintEffect reverse reverse ansi
    printf "\n"

    printf "\n  - print mode: text: "
        printf "\n    - "; PrintEffect bold bold text
            printf ", "; PrintEffect italic italic text
            printf ", "; PrintEffect reverse reverse text
    printf "\n"

    printf "\n  - print modes: adoc, text-anon: "
        printf "\n    - "; PrintEffect bold bold adoc
            printf ", "; PrintEffect italic italic adoc
            printf ", "; PrintEffect reverse reverse adoc
    printf "\n"

}
