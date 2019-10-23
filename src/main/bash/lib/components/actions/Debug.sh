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
## Debug - action to debugs something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Debug() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno width1 width2 format mode comma
    if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi

    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in

        application)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing application id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_APP_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_APP_DECPHA[${id}]}"
            printf "        s-phase:    %s\n"       "${FW_ELEMENT_APP_PHA[${id}]}"
            printf "        command:    %s\n"       "${FW_ELEMENT_APP_COMMAND[${id}]}"
            printf "        argnum:     %s\n"       "${FW_ELEMENT_APP_ARGNUM[${id}]}"
            printf "        args:       %s\n"       "${FW_ELEMENT_APP_ARGS[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_APP_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_APP_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_APP_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_APP_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_APP_REQIN[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req out:    %s\n"       "${FW_ELEMENT_APP_REQOUT_COUNT[${id}]}"
            printf "            app:    %s\n"       "${FW_ELEMENT_APP_REQOUT_APP[${id}]}"
            printf "            dep:    %s\n"       "${FW_ELEMENT_APP_REQOUT_DEP[${id}]}"
            printf "            dls:    %s\n"       "${FW_ELEMENT_APP_REQOUT_DLS[${id}]}"
            printf "            dir:    %s\n"       "${FW_ELEMENT_APP_REQOUT_DIR[${id}]}"
            printf "            fls:    %s\n"       "${FW_ELEMENT_APP_REQOUT_FLS[${id}]}"
            printf "            fil:    %s\n"       "${FW_ELEMENT_APP_REQOUT_FIL[${id}]}"
            printf "            par:    %s\n"       "${FW_ELEMENT_APP_REQOUT_PAR[${id}]}"
            printf "            tsk:    %s\n"       "${FW_ELEMENT_APP_REQOUT_TSK[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        dependency)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing dependency id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_DEP_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_DEP_DECPHA[${id}]}"
            printf "        command:    %s\n"       "${FW_ELEMENT_DEP_COMMAND[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_DEP_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_DEP_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_DEP_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_DEP_REQIN[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req out:    %s\n"       "${FW_ELEMENT_DEP_REQOUT_COUNT[${id}]}"
            printf "            dep:    %s\n"       "${FW_ELEMENT_DEP_REQOUT_DEP[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        dirlist)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing dirlist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_DLS_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_DLS_DECPHA[${id}]}"
            printf "        s-phase:    %s\n"       "${FW_ELEMENT_DLS_PHA[${id}]}"

            printf "        d-modes:    %s\n"       "${FW_ELEMENT_DLS_MOD[${id}]}"
            printf "        value:      %s\n"       "${FW_ELEMENT_DLS_VAL[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_DLS_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_DLS_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_DLS_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_DLS_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_DLS_REQIN[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        dir)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing dir id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_DIR_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_DIR_DECPHA[${id}]}"
            printf "        s-phase:    %s\n"       "${FW_ELEMENT_DIR_PHA[${id}]}"

            printf "        d-modes:    %s\n"       "${FW_ELEMENT_DIR_MOD[${id}]}"
            printf "        value:      %s\n"       "${FW_ELEMENT_DIR_VAL[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_DIR_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_DIR_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_DIR_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_DIR_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_DIR_REQIN[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        filelist)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing filelist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_FLS_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_FLS_DECPHA[${id}]}"
            printf "        s-phase:    %s\n"       "${FW_ELEMENT_FLS_PHA[${id}]}"

            printf "        f-modes:    %s\n"       "${FW_ELEMENT_FLS_MOD[${id}]}"
            printf "        value:      %s\n"       "${FW_ELEMENT_FLS_VAL[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_FLS_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_FLS_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_FLS_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_FLS_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_FLS_REQIN[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        file)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing file id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_FIL_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_FIL_DECPHA[${id}]}"
            printf "        s-phase:    %s\n"       "${FW_ELEMENT_FIL_PHA[${id}]}"

            printf "        f-modes:    %s\n"       "${FW_ELEMENT_FIL_MOD[${id}]}"
            printf "        value:      %s\n"       "${FW_ELEMENT_FIL_VAL[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_FIL_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_FIL_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_FIL_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_FIL_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_FIL_REQIN[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        module)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_MDS_DECPHA[${id}]}"
            printf "        acronym:    %s\n"       "${FW_ELEMENT_MDS_ACR[${id}]}"
            printf "        path:       %s\n"       "${FW_ELEMENT_MDS_PATH[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_MDS_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_MDS_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_MDS_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_MDS_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_MDS_REQIN[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req out:    %s\n"       "${FW_ELEMENT_MDS_REQOUT_COUNT[${id}]}"
            printf "            mod:    %s\n"       "${FW_ELEMENT_MDS_REQOUT_MDS[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        option)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing option id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            id="$(Get option id ${id})"
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        len:        %s\n"       "${FW_ELEMENT_OPT_LEN[${id}]}"
            printf "        short:      %s\n"       "${FW_ELEMENT_OPT_LS[${id}]}"
            printf "        arg:        %s\n"       "${FW_ELEMENT_OPT_ARG[${id}]}"
            printf "        sort:       %s\n"       "${FW_ELEMENT_OPT_SORT[${id}]}"
            printf "        category:   %s\n"       "${FW_ELEMENT_OPT_CAT[${id}]}"
            printf "        set:        %s\n"       "${FW_ELEMENT_OPT_SET[${id}]}"
            printf "        value:      %s\n"       "${FW_ELEMENT_OPT_VAL[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_OPT_LONG[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        parameter)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing parameter id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_PAR_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_PAR_DECPHA[${id}]}"
            printf "        def-val:    %s\n"       "${FW_ELEMENT_PAR_DEFVAL[${id}]}"
            printf "        value:      %s\n"       "${FW_ELEMENT_PAR_VAL[${id}]}"

            printf "        descr:      %s\n"       "${FW_ELEMENT_PAR_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_PAR_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_PAR_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_PAR_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_PAR_REQIN[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        project)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing project id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_PRJ_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_PRJ_DECPHA[${id}]}"
            printf "        modes:      "
            comma=""
            for mode in ${FW_ELEMENT_PRJ_MODES[${id}]}; do
                printf "%s%s" "${comma}" "${FW_OBJECT_STO_SET["mode-${mode}-${format}"]}"
                comma=" "
            done
            printf "\n"            printf "        showexec:   %s\n"       "${FW_ELEMENT_PRJ_SHOW_EXEC[${id}]}"
            printf "        path:       %s\n"       "${FW_ELEMENT_PRJ_PATH[${id}]}"
            printf "        path-text:  %s\n"       "${FW_ELEMENT_PRJ_PATH_TEXT[${id}]}"
            printf "        root-dir:   %s\n"       "${FW_ELEMENT_PRJ_RDIR_TEXT[${id}]}"
            printf "        targets:    %s\n"       "${FW_ELEMENT_PRJ_TGTS_TEXT[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_PRJ_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_PRJ_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_PRJ_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_PRJ_REQIN[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req out:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_COUNT[${id}]}"
            printf "            app:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_APP[${id}]}"
            printf "            dep:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_DEP[${id}]}"
            printf "            dls:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_DLS[${id}]}"
            printf "            dir:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_DIR[${id}]}"
            printf "            fls:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_FLS[${id}]}"
            printf "            fil:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_FIL[${id}]}"
            printf "            par:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_PAR[${id}]}"
            printf "            prj:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_PRJ[${id}]}"
            printf "            scn:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_SCN[${id}]}"
            printf "            sit:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_SIT[${id}]}"
            printf "            tsk:    %s\n"       "${FW_ELEMENT_PRJ_REQOUT_TSK[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        scenario)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing scenario id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_SCN_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_SCN_DECPHA[${id}]}"
            printf "        modes:      "
            comma=""
            for mode in ${FW_ELEMENT_SCN_MODES[${id}]}; do
                printf "%s%s" "${comma}" "${FW_OBJECT_STO_SET["mode-${mode}-${format}"]}"
                comma=" "
            done
            printf "\n"
            printf "        showexec:   %s\n"       "${FW_ELEMENT_SCN_SHOW_EXEC[${id}]}"
            printf "        path:       %s\n"       "${FW_ELEMENT_SCN_PATH[${id}]}"
            printf "        path-text:  %s\n"       "${FW_ELEMENT_SCN_PATH_TEXT[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_SCN_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_SCN_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_SCN_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_SCN_REQIN[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req out:    %s\n"       "${FW_ELEMENT_SCN_REQOUT_COUNT[${id}]}"
            printf "            app:    %s\n"       "${FW_ELEMENT_SCN_REQOUT_APP[${id}]}"
            printf "            scn:    %s\n"       "${FW_ELEMENT_SCN_REQOUT_SCN[${id}]}"
            printf "            tsk:    %s\n"       "${FW_ELEMENT_SCN_REQOUT_TSK[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        script)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing script id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_SCR_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_SCR_DECPHA[${id}]}"
            printf "        modes:      "
            comma=""
            for mode in ${FW_ELEMENT_SCR_MODES[${id}]}; do
                printf "%s%s" "${comma}" "${FW_OBJECT_STO_SET["mode-${mode}-${format}"]}"
                comma=" "
            done
            printf "\n"
            printf "        showexec:   %s\n"       "${FW_ELEMENT_SCR_SHOW_EXEC[${id}]}"
            printf "        path:       %s\n"       "${FW_ELEMENT_SCR_PATH[${id}]}"
            printf "        path-text:  %s\n"       "${FW_ELEMENT_SCR_PATH_TEXT[${id}]}"
            printf "        root-dir:   %s\n"       "${FW_ELEMENT_SCR_RDIR_TEXT[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_SCR_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_SCR_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_SCR_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_SCR_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_SCR_REQIN[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req out:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_COUNT[${id}]}"
            printf "            app:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_APP[${id}]}"
            printf "            dep:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_DEP[${id}]}"
            printf "            dls:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_DLS[${id}]}"
            printf "            dir:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_DIR[${id}]}"
            printf "            fls:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_FLS[${id}]}"
            printf "            fil:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_FIL[${id}]}"
            printf "            par:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_PAR[${id}]}"
            printf "            prj:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_PRJ[${id}]}"
            printf "            scn:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_SCN[${id}]}"
            printf "            scr:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_SCR[${id}]}"
            printf "            sit:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_SIT[${id}]}"
            printf "            tsk:    %s\n"       "${FW_ELEMENT_SCR_REQOUT_TSK[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        site)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing site id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_SIT_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_SIT_DECPHA[${id}]}"
            printf "        modes:      "
            comma=""
            for mode in ${FW_ELEMENT_SIT_MODES[${id}]}; do
                printf "%s%s" "${comma}" "${FW_OBJECT_STO_SET["mode-${mode}-${format}"]}"
                comma=" "
            done
            printf "\n"
            printf "        showexec:   %s\n"       "${FW_ELEMENT_SIT_SHOW_EXEC[${id}]}"
            printf "        path:       %s\n"       "${FW_ELEMENT_SIT_PATH[${id}]}"
            printf "        path-text:  %s\n"       "${FW_ELEMENT_SIT_PATH_TEXT[${id}]}"
            printf "        root-dir:   %s\n"       "${FW_ELEMENT_SIT_RDIR_TEXT[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_SIT_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_SIT_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_SIT_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_SIT_REQIN[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req out:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_COUNT[${id}]}"
            printf "            app:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_APP[${id}]}"
            printf "            dep:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_DEP[${id}]}"
            printf "            dls:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_DLS[${id}]}"
            printf "            dir:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_DIR[${id}]}"
            printf "            fls:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_FLS[${id}]}"
            printf "            fil:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_FIL[${id}]}"
            printf "            par:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_PAR[${id}]}"
            printf "            scn:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_SCN[${id}]}"
            printf "            tsk:    %s\n"       "${FW_ELEMENT_SIT_REQOUT_TSK[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        task)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing task id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            width1="${2:-$(tput cols)}";  width2=$(( width1 - 7 ))

            Format table toprule ${width1}
            printf "    %s\n"                       "${id}"
            printf "        d-module:   %s\n"       "${FW_ELEMENT_TSK_DECMDS[${id}]}"
            printf "        d-phase:    %s\n"       "${FW_ELEMENT_TSK_DECPHA[${id}]}"
            printf "        modes:      "
            comma=""
            for mode in ${FW_ELEMENT_TSK_MODES[${id}]}; do
                printf "%s%s" "${comma}" "${FW_OBJECT_STO_SET["mode-${mode}-${format}"]}"
                comma=" "
            done
            printf "\n"
            printf "        showexec:   %s\n"       "${FW_ELEMENT_TSK_SHOW_EXEC[${id}]}"
            printf "        path:       %s\n"       "${FW_ELEMENT_TSK_PATH[${id}]}"
            printf "        path-text:  %s\n"       "${FW_ELEMENT_TSK_PATH_TEXT[${id}]}"
            printf "        descr:      %s\n"       "${FW_ELEMENT_TSK_LONG[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        status:     %s\n"       "${FW_ELEMENT_TSK_STATUS[${id}]}"
            printf "        comments:   %s\n"       "${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req in:     %s\n"       "${FW_ELEMENT_TSK_REQIN_COUNT[${id}]}"
            printf "                    %s\n"       "${FW_ELEMENT_TSK_REQIN[${id}]}"

            printf "       "; Format table midrule ${width2}
            printf "        req out:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_COUNT[${id}]}"
            printf "            app:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_APP[${id}]}"
            printf "            dep:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_DEP[${id}]}"
            printf "            dls:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_DLS[${id}]}"
            printf "            dir:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_DIR[${id}]}"
            printf "            fls:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_FLS[${id}]}"
            printf "            fil:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_FIL[${id}]}"
            printf "            par:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_PAR[${id}]}"
            printf "            tsk:    %s\n"       "${FW_ELEMENT_TSK_REQOUT_TSK[${id}]}"
            Format table toprule ${width1}
            printf "\n" ;;


        verification)
            ;;


        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
