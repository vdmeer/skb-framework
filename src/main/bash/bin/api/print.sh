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
## Functions for printing  ansi colors and effects, settings, values, etc
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## function: PrintColor()
## - prints message in color
## $1: color: black, red, green, brown, blue, purple, cyan, light-gray (or light-grey), dark-gray (or dark-grey),
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
                black)                      printf "${COLORS["BLACK"]}" ;;
                red)                        printf "${COLORS["RED"]}" ;;
                green)                      printf "${COLORS["GREEN"]}" ;;
                brown)                      printf "${COLORS["BROWN"]}" ;;
                blue)                       printf "${COLORS["BLUE"]}" ;;
                purple)                     printf "${COLORS["PURPLE"]}" ;;
                cyan)                       printf "${COLORS["CYAN"]}" ;;
                light-gray | light-grey)    printf "${COLORS["LIGHT_GRAY"]}" ;;
                dark-gray | dark-grey)      printf "${COLORS["DARK_GRAY"]}" ;;
                light-red)                  printf "${COLORS["LIGHT_RED"]}" ;;
                light-green)                printf "${COLORS["LIGHT_GREEN"]}" ;;
                yellow)                     printf "${COLORS["YELLOW"]}" ;;
                light-blue)                 printf "${COLORS["LIGHT_BLUE"]}" ;;
                light-purple)               printf "${COLORS["LIGHT_PURPLE"]}" ;;
                light-cyan)                 printf "${COLORS["LIGHT_CYAN"]}" ;;
                *)                          ConsolePrint error "print-color: unknown color: $1"
            esac
            printf "%s${COLORS["WHITE"]}${COLORS["NORMAL"]}" "$2"
            ;;
        text | text-anon | adoc)
            printf "%s" "$2" ;;
        *)
            ConsolePrint error "print-color: unknown print mode: $PRINT_MODE";;
    esac
}



##
## function: PrintEffect()
## - print text using text effects.
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
                *)              ConsolePrint error "print-effect: unknown effect: $1"
            esac
            ;;
        text)                   printf "%s" "$2" ;;
        adoc | text-anon)
            case "$1" in
                bold)           printf "*%s*" "$2" ;;
                italic)         printf "_%s_" "$2" ;;
                reverse)        printf "%s" "$2" ;;
                *)              ConsolePrint error "print-effect: unknown effect: $1"
            esac
            ;;
        *)
            ConsolePrint error "print-effect: unknown print mode: $PRINT_MODE";;
    esac
}



##
## function: PrintPrompt()
## - prints the application flavor plus the mode in round brackets.
## $1: the requested prompt
##  -- flavor-mode - prints the application flavor plus the mode in round brackets
##
PrintPrompt() {
    case $1 in
        flavor-mode)
            printf "%s(" ${CONFIG_MAP["FLAVOR"],,}
            PrintSetting app-mode
            printf "): "
            ;;
        *)
            ConsolePrint error "print-prompt: unknown prompt: $1"
            ;;
    esac
}



##
## function: PrintSetting()
## - prints the requested setting with color and effects
## $1: setting, one of: app-mode, app-mode-flavor, strict, shell-snp
##         loader-level, shell-level, task-level, loader-quiet, shell-quiet, task-quiet
##
PrintSetting(){
    case $1 in
        app-mode)
            case "${CONFIG_MAP["APP_MODE"]}" in
                all)    PrintColor red              "${CONFIG_MAP["APP_MODE"]}" ;; 
                dev)    PrintColor yellow           "${CONFIG_MAP["APP_MODE"]}" ;;
                build)  PrintColor light-blue       "${CONFIG_MAP["APP_MODE"]}" ;;
                use)    PrintColor green            "${CONFIG_MAP["APP_MODE"]}" ;;
            esac
            ;;
        app-mode-flavor)
            case "${CONFIG_MAP["APP_MODE_FLAVOR"]}" in
                std)        PrintColor cyan             "${CONFIG_MAP["APP_MODE_FLAVOR"]}" ;; 
                install)    PrintColor purple           "${CONFIG_MAP["APP_MODE_FLAVOR"]}" ;;
            esac
            ;;
        loader-level | shell-level | task-level)
            local LEVEL=${CONFIG_MAP["LOADER_LEVEL"]}
            case $1 in
                shell-level)    LEVEL=${CONFIG_MAP["SHELL_LEVEL"]};;
                task-level)     LEVEL=${CONFIG_MAP["TASK_LEVEL"]};;
            esac
            case $LEVEL in
                all)            PrintColor light-cyan      $LEVEL;;
                fatal)          PrintColor red             $LEVEL;;
                error)          PrintColor light-red       $LEVEL;;
                warn-strict)    PrintColor yellow "warn"; printf "-"; PrintColor light-red "strict";;
                warn)           PrintColor yellow          $LEVEL;;
                info)           PrintColor green           $LEVEL;;
                debug | trace)  PrintColor light-blue      $LEVEL;;
                off)            PrintColor light-purple    $LEVEL;;
                *)              PrintColor light-purple    $LEVEL;;
            esac
            ;;
        strict)
            case "${CONFIG_MAP["STRICT"]}" in
                on)     PrintColor light-red "on" ;;
                off)    PrintColor light-green "off" ;;
            esac
            ;;
        loader-quiet | shell-quiet | task-quiet)
            local QUIET=${CONFIG_MAP["LOADER_QUIET"]}
            case $1 in
                shell-quiet)    QUIET=${CONFIG_MAP["SHELL_QUIET"]};;
                task-quiet)     QUIET=${CONFIG_MAP["TASK_QUIET"]};;
            esac
            case "$QUIET" in
                on)     PrintColor light-red        $QUIET;;
                off)    PrintColor light-green      $QUIET;;
                *)      PrintColor light-purple     $QUIET;;
            esac
            ;;
        shell-snp)
            case "${CONFIG_MAP["SHELL_SNP"]}" in
                on)     PrintColor light-red "on" ;;
                off)    PrintColor light-green "off" ;;
            esac
            ;;
        *)
            ConsolePrint error "print-setting: unknown setting: $1"
            ;;
    esac
}



##
## function: PrintTests()
## - prints terminal tests
## $1: required tests, comma-separated, supported: a | all, c | colors, e | effects, u | utf8
##     - all: runs all tests in the order: color, effect, utf8
##     - colors: prints lines to test terminal ANSI color capabilities and show alternatives for other print modes
##     - effects: prints lines to test terminal ANSI effect capabilities and show alternatives for other print modes
##     - utf8: prints all used UTF-8 characters in a single line
##
PrintTests() {
    if [[ -z ${1:-} ]]; then
        ConsolePrint error "print-tests: no test given"
    fi

    local TESTS=
    if [[ "$1" == "all" ]]; then
        TESTS=colors,effects,utf8
    else
        TESTS=$1
    fi

    FIELD_SEAPARATOR=$IFS
    IFS=,
    for TEST in $TESTS; do
        case $TEST in
            c | colors)
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
                ;;
            e | effects)
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
                ;;
            u | utf8)
                local KEY
                printf "\n  Used UTF-8 characters: "
                for KEY in ${!CHAR_MAP[@]}; do
                    printf "%s  " "${CHAR_MAP[$KEY]}"
                done
                printf "\n"
                ;;
            *)
                ConsolePrint error "print-tests: unknown test: $TEST"
                ;;
        esac
    done
}
