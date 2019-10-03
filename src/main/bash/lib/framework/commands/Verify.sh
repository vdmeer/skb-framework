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
## Verify - command to verify something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


##https://www.toolsqa.com/software-testing/difference-between-verification-and-validation/

FW_TAGS_COMMANDS["Verify"]="command to verify something"

function Verify() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local i id errno status dir file fileText modid modpath fsMode list element command
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        everything)
            Verify requests

            Verify applications
            Verify dependencies
            Verify dirlists
            Verify dirs
            Verify filelists
            Verify files
            Verify modules
            Verify parameters

            Verify tasks
            Verify projects
            Verify scenarios
            Verify sites

            Write medium config file ;;

        requests)
            if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_MDS_LONG[@]}; do FW_ELEMENT_MDS_STATUS[${id}]="N"; FW_ELEMENT_MDS_STATUS_COMMENTS[${id}]=""; FW_ELEMENT_MDS_REQUESTED[${id}]=""; done
                for id in ${!FW_ELEMENT_MDS_LONG[@]}; do
                    for entry in ${FW_ELEMENT_MDS_REQUIRED_MODULES[${id}]:-}; do if [[ ! -n "${FW_ELEMENT_MDS_REQUESTED[${entry}]:-}" ]];  then FW_ELEMENT_MDS_REQUESTED[${entry}]="module:${id}"; else FW_ELEMENT_MDS_REQUESTED[${entry}]+=" module:${id}"; fi; done
                done
            fi

            if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then for id in ${!FW_ELEMENT_APP_LONG[@]}; do FW_ELEMENT_APP_STATUS[${id}]="N"; FW_ELEMENT_APP_STATUS_COMMENTS[${id}]=""; FW_ELEMENT_APP_REQUESTED[${id}]=""; done; fi
            if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then for id in ${!FW_ELEMENT_DEP_LONG[@]}; do FW_ELEMENT_DEP_STATUS[${id}]="N"; FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]=""; FW_ELEMENT_DEP_REQUESTED[${id}]=""; done; fi
            if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then for id in ${!FW_ELEMENT_DIR_LONG[@]}; do FW_ELEMENT_DIR_STATUS[${id}]="N"; FW_ELEMENT_DIR_STATUS_COMMENTS[${id}]=""; FW_ELEMENT_DIR_REQUESTED[${id}]=""; done; fi
            if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" ]]; then for id in ${!FW_ELEMENT_DLS_LONG[@]}; do FW_ELEMENT_DLS_STATUS[${id}]="N"; FW_ELEMENT_DLS_STATUS_COMMENTS[${id}]=""; FW_ELEMENT_DLS_REQUESTED[${id}]=""; done; fi
            if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then for id in ${!FW_ELEMENT_FIL_LONG[@]}; do FW_ELEMENT_FIL_STATUS[${id}]="N"; FW_ELEMENT_FIL_STATUS_COMMENTS[${id}]=""; FW_ELEMENT_FIL_REQUESTED[${id}]=""; done; fi
            if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" ]]; then for id in ${!FW_ELEMENT_FLS_LONG[@]}; do FW_ELEMENT_FLS_STATUS[${id}]="N"; FW_ELEMENT_FLS_STATUS_COMMENTS[${id}]=""; FW_ELEMENT_FLS_REQUESTED[${id}]=""; done; fi
            if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then for id in ${!FW_ELEMENT_PAR_LONG[@]}; do FW_ELEMENT_PAR_STATUS[${id}]="N"; FW_ELEMENT_PAR_STATUS_COMMENTS[${id}]=""; FW_ELEMENT_PAR_REQUESTED[${id}]=""; done; fi

            if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_TSK_LONG[@]}; do FW_ELEMENT_TSK_STATUS[${id}]="N"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="";FW_ELEMENT_TSK_REQUESTED[${id}]=""; done
                for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_TSK_MODES[${id}]}" ]]; then
                        if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_TSK_MODES[${id}]}" != "all" ]]; then continue; fi
                    fi

                    for entry in ${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED[${entry}]="task:${id}"; else FW_ELEMENT_TSK_REQUESTED[${entry}]+=" task:${id}"; fi; done
                    for entry in ${FW_ELEMENT_TSK_REQUIRED_APP[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_APP_REQUESTED[${entry}]="task:${id}"; else FW_ELEMENT_APP_REQUESTED[${entry}]+=" task:${id}"; fi; done
                    for entry in ${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED[${entry}]="task:${id}"; else FW_ELEMENT_DEP_REQUESTED[${entry}]+=" task:${id}"; fi; done
                    for entry in ${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DIR_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DIR_REQUESTED[${entry}]="task:${id}"; else FW_ELEMENT_DIR_REQUESTED[${entry}]+=" task:${id}"; fi; done
                    for entry in ${FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DLS_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DLS_REQUESTED[${entry}]="task:${id}"; else FW_ELEMENT_DLS_REQUESTED[${entry}]+=" task:${id}"; fi; done
                    for entry in ${FW_ELEMENT_TSK_REQUIRED_FILE[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_FIL_REQUESTED[${entry}]="task:${id}"; else FW_ELEMENT_FIL_REQUESTED[${entry}]+=" task:${id}"; fi; done
                    for entry in ${FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_FLS_REQUESTED[${entry}]="task:${id}"; else FW_ELEMENT_FLS_REQUESTED[${entry}]+=" task:${id}"; fi; done
                    for entry in ${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_PAR_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_PAR_REQUESTED[${entry}]="task:${id}"; else FW_ELEMENT_PAR_REQUESTED[${entry}]+=" task:${id}"; fi; done
                done
            fi

            if [[ "${FW_ELEMENT_SIT_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_SIT_LONG[@]}; do
                    FW_ELEMENT_SIT_STATUSP[${id}]="N"; FW_ELEMENT_SIT_STATUS_COMMENTSP[${id}]=""

                    for entry in ${FW_ELEMENT_SIT_REQUIRED_DEP[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED[${entry}]="site:${id}"; else FW_ELEMENT_DEP_REQUESTED[${entry}]+=" site:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SIT_REQUIRED_DIR[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DIR_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DIR_REQUESTED[${entry}]="site:${id}"; else FW_ELEMENT_DIR_REQUESTED[${entry}]+=" site:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SIT_REQUIRED_DIRLIST[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DLS_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DLS_REQUESTED[${entry}]="site:${id}"; else FW_ELEMENT_DLS_REQUESTED[${entry}]+=" site:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SIT_REQUIRED_FILE[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_FIL_REQUESTED[${entry}]="site:${id}"; else FW_ELEMENT_FIL_REQUESTED[${entry}]+=" site:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SIT_REQUIRED_FILELIST[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_FLS_REQUESTED[${entry}]="site:${id}"; else FW_ELEMENT_FLS_REQUESTED[${entry}]+=" site:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SIT_REQUIRED_PAR[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_PAR_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_PAR_REQUESTED[${entry}]="site:${id}"; else FW_ELEMENT_PAR_REQUESTED[${entry}]+=" site:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SIT_REQUIRED_TSK[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED[${entry}]="site:${id}"; else FW_ELEMENT_TSK_REQUESTED[${entry}]+=" site:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SIT_REQUIRED_APP[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_APP_REQUESTED[${entry}]="site:${id}"; else FW_ELEMENT_APP_REQUESTED[${entry}]+=" site:${id}"; fi; done
                done
            fi

            if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                    FW_ELEMENT_SCN_STATUS[${id}]="N"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]=""
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SCN_MODES[${id}]}" ]]; then
                        if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SCN_MODES[${id}]}" != "all" ]]; then continue; fi
                    fi

                    for entry in ${FW_ELEMENT_SCN_REQUIRED_DEP[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED[${entry}]="scenario:${id}"; else FW_ELEMENT_DEP_REQUESTED[${entry}]+=" scenario:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SCN_REQUIRED_DIR[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DIR_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DIR_REQUESTED[${entry}]="scenario:${id}"; else FW_ELEMENT_DIR_REQUESTED[${entry}]+=" scenario:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DLS_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DLS_REQUESTED[${entry}]="scenario:${id}"; else FW_ELEMENT_DLS_REQUESTED[${entry}]+=" scenario:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SCN_REQUIRED_FILE[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_FIL_REQUESTED[${entry}]="scenario:${id}"; else FW_ELEMENT_FIL_REQUESTED[${entry}]+=" scenario:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_FLS_REQUESTED[${entry}]="scenario:${id}"; else FW_ELEMENT_FLS_REQUESTED[${entry}]+=" scenario:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SCN_REQUIRED_PAR[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_PAR_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_PAR_REQUESTED[${entry}]="scenario:${id}"; else FW_ELEMENT_PAR_REQUESTED[${entry}]+=" scenario:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED[${entry}]="scenario:${id}"; else FW_ELEMENT_TSK_REQUESTED[${entry}]+=" scenario:${id}"; fi; done
                    for entry in ${FW_ELEMENT_SCN_REQUIRED_APP[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_APP_REQUESTED[${entry}]="scenario:${id}"; else FW_ELEMENT_APP_REQUESTED[${entry}]+=" scenario:${id}"; fi; done
                done
            fi

            if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_PRJ_LONG[@]}; do
                    FW_ELEMENT_PRJ_STATUS[${id}]="N"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]=""
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_PRJ_MODES[${id}]}" ]]; then
                        if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_PRJ_MODES[${id}]}" != "all" ]]; then continue; fi
                    fi

                    for entry in ${FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DEP_REQUESTED[${entry}]="project:${id}"; else FW_ELEMENT_DEP_REQUESTED[${entry}]+=" project:${id}"; fi; done
                    for entry in ${FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DIR_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DIR_REQUESTED[${entry}]="project:${id}"; else FW_ELEMENT_DIR_REQUESTED[${entry}]+=" project:${id}"; fi; done
                    for entry in ${FW_ELEMENT_PRJ_REQUIRED_DIRLIST[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_DLS_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_DLS_REQUESTED[${entry}]="project:${id}"; else FW_ELEMENT_DLS_REQUESTED[${entry}]+=" project:${id}"; fi; done
                    for entry in ${FW_ELEMENT_PRJ_REQUIRED_FILE[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_FIL_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_FIL_REQUESTED[${entry}]="project:${id}"; else FW_ELEMENT_FIL_REQUESTED[${entry}]+=" project:${id}"; fi; done
                    for entry in ${FW_ELEMENT_PRJ_REQUIRED_FILELIST[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_FLS_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_FLS_REQUESTED[${entry}]="project:${id}"; else FW_ELEMENT_FLS_REQUESTED[${entry}]+=" project:${id}"; fi; done
                    for entry in ${FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_PAR_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_PAR_REQUESTED[${entry}]="project:${id}"; else FW_ELEMENT_PAR_REQUESTED[${entry}]+=" project:${id}"; fi; done
                    for entry in ${FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_TSK_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_TSK_REQUESTED[${entry}]="project:${id}"; else FW_ELEMENT_TSK_REQUESTED[${entry}]+=" project:${id}"; fi; done
                    for entry in ${FW_ELEMENT_PRJ_REQUIRED_APP[${id}]:-};  do if [[ ! -n "${FW_ELEMENT_APP_REQUESTED[${entry}]:-}" ]]; then FW_ELEMENT_APP_REQUESTED[${entry}]="project:${id}"; else FW_ELEMENT_APP_REQUESTED[${entry}]+=" project:${id}"; fi; done
                done
            fi

            if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_DEP_REQUESTED[${id}]:-}" ]]; then
                        for entry in ${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]:-}; do if [[ ! -n "${FW_ELEMENT_DEP_REQUESTED[${entry}]:-}" ]];  then FW_ELEMENT_DEP_REQUESTED[${entry}]="dependency:${id}"; else FW_ELEMENT_DEP_REQUESTED[${entry}]+=" dependency:${id}"; fi; done
                    fi
                done
            fi ;;


        applications)
            if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_APP_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_APP_REQUESTED[${id}]:-}" ]]; then
                        Test command ${FW_ELEMENT_APP_COMMAND[${id}]} application "${id}"; errno=$?
                        if [[ "${errno}" != 0 ]]; then
                            FW_ELEMENT_APP_STATUS[${id}]="E"; FW_ELEMENT_APP_STATUS_COMMENTS[${id}]="${FW_ELEMENT_APP_STATUS_COMMENTS[${id}]}command(E) "
                        else
                            FW_ELEMENT_APP_STATUS[${id}]="S"
                        fi
                    fi
                done
            fi ;;


        dependencies)
            if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_DEP_REQUESTED[${id}]:-}" ]]; then
                        Test command "${FW_ELEMENT_DEP_CMD[${id}]}" dependency "${id}"; errno=$?
                        if [[ "${errno}" != 0 ]]; then
                            FW_ELEMENT_DEP_STATUS[${id}]="E"; FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]="${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]}command(E) "
                        else
                            FW_ELEMENT_DEP_STATUS[${id}]="S"
                        fi
                    fi
                done

                ## Again for requested dependencies, once they are verified above
                for id in ${!FW_ELEMENT_DEP_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_DEP_REQUESTED[${id}]:-}" ]]; then
                        if [[ -n "${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]:-}" ]]; then
                            status="S"
                            for element in ${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]}; do
                                case "${FW_ELEMENT_DEP_STATUS[${element}]}" in
                                    N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 dependency "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                        status="${status}E"; FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]="${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]}dep(N):${element} " ;;
                                    E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 dependency "${element}"
                                        status="${status}E"; FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]="${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]}dep(E):${element} " ;;
                                    W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 dependency "${element}"
                                        status="${status}W"; FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]="${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]}dep(E):${element} " ;;
                                    S)  status="${status}S" ;;
                                esac
                            done
                            case ${status} in
                                *E*)    FW_ELEMENT_DEP_STATUS[${id}]=E ;;
                                *W*)    FW_ELEMENT_DEP_STATUS[${id}]=W ;;
                                *S*)    FW_ELEMENT_DEP_STATUS[${id}]=S ;;
                            esac
                        fi
                    fi
                done
            fi ;;


        dirlists)
            if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DLS_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_DLS_REQUESTED[${id}]:-}" ]]; then
                        list="${FW_ELEMENT_DLS_VAL[${id}]}"
                        fsMode=${FW_ELEMENT_DLS_MOD[${id}]}; i=0
                        status="S"
                        for dir in $list; do
                            while [ ${i} -lt ${#fsMode} ]; do
                                char=${fsMode:$i:1}; errno=0
                                case "${char}" in
                                    r)  Test dir can read "${dir}"; errno=$? ;;
                                    w)  Test dir can write "${dir}"; errno=$? ;;
                                    x)  Test dir can execute "${dir}"; errno=$? ;;
                                    c)  Test dir can create ${dir}; errno=$? ;;
                                    d)  Test dir can delete ${dir}; errno=$? ;;
                                esac
                                if [[ "${errno}" != 0 ]]; then
                                    status="${status}E"
                                    FW_ELEMENT_DLS_STATUS_COMMENTS[${id}]="${FW_ELEMENT_DLS_STATUS_COMMENTS[${id}]}dir(E):${dir} "
                                else
                                    status="${status}S"
                                fi
                                i=$(( i + 1 ))
                            done
                        done
                        case ${status} in
                            *E*)    FW_ELEMENT_DIR_STATUS[${id}]=E ;;
                            *W*)    FW_ELEMENT_DIR_STATUS[${id}]=W ;;
                            *S*)    FW_ELEMENT_DIR_STATUS[${id}]=S ;;
                        esac
                    fi
                done
            fi ;;


        dirs)
            if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_DIR_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_DIR_REQUESTED[${id}]:-}" ]]; then
                        dir=${FW_ELEMENT_DIR_VAL[${id}]}
                        fsMode=${FW_ELEMENT_DIR_MOD[${id}]}; i=0
                        status="S"
                        while [ ${i} -lt ${#fsMode} ]; do
                            char=${fsMode:$i:1}; errno=0
                            case "${char}" in
                                r)  Test dir can read "${dir}"; errno=$? ;;
                                w)  Test dir can write "${dir}"; errno=$? ;;
                                x)  Test dir can execute "${dir}"; errno=$? ;;
                                c)  Test dir can create ${dir}; errno=$? ;;
                                d)  Test dir can delete ${dir}; errno=$? ;;
                            esac
                            if [[ "${errno}" != 0 ]]; then
                                status="${status}E"
                                FW_ELEMENT_DIR_STATUS_COMMENTS[${id}]="${FW_ELEMENT_DIR_STATUS_COMMENTS[${id}]}dir(E):${dir} "
                            else
                                status="${status}S"
                            fi
                            i=$(( i + 1 ))
                        done
                        case ${status} in
                            *E*)    FW_ELEMENT_DIR_STATUS[${id}]=E ;;
                            *W*)    FW_ELEMENT_DIR_STATUS[${id}]=W ;;
                            *S*)    FW_ELEMENT_DIR_STATUS[${id}]=S ;;
                        esac
                    fi
                done
            fi ;;


        filelists)
            if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_FLS_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_FLS_REQUESTED[${id}]:-}" ]]; then
                        list="${FW_ELEMENT_FLS_VAL[${id}]}"
                        fsMode=${FW_ELEMENT_FLS_MOD[${id}]}; i=0
                        status="S"
                        for file in $list; do
                            while [ ${i} -lt ${#fsMode} ]; do
                                char=${fsMode:$i:1}; errno=0
                                case "${char}" in
                                    r)  Test file can read "${file}"; errno=$? ;;
                                    w)  Test file can write "${file}"; errno=$? ;;
                                    x)  Test file can execute "${file}"; errno=$? ;;
                                    c)  Test file can create ${file}; errno=$? ;;
                                    d)  Test file can delete ${file}; errno=$? ;;
                                esac
                                if [[ "${errno}" != 0 ]]; then
                                    status="${status}E"
                                    FW_ELEMENT_FLS_STATUS_COMMENTS[${id}]="${FW_ELEMENT_FLS_STATUS_COMMENTS[${id}]}file(E):${file} "
                                else
                                    status="${status}S"
                                fi
                                i=$(( i + 1 ))
                            done
                        done
                        case ${status} in
                            *E*)    FW_ELEMENT_FIL_STATUS[${id}]=E ;;
                            *W*)    FW_ELEMENT_FIL_STATUS[${id}]=W ;;
                            *S*)    FW_ELEMENT_FIL_STATUS[${id}]=S ;;
                        esac
                    fi
                done
            fi ;;


        files)
            if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_FIL_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_FIL_REQUESTED[${id}]:-}" ]]; then
                        file=${FW_ELEMENT_FIL_VAL[${id}]}
                        fsMode=${FW_ELEMENT_FIL_MOD[${id}]}; i=0
                        status="S"
                        while [ ${i} -lt ${#fsMode} ]; do
                            char=${fsMode:$i:1}; errno=0
                            case "${char}" in
                                r)  Test file can read "${file}"; errno=$? ;;
                                w)  Test file can write "${file}"; errno=$? ;;
                                x)  Test file can execute "${file}"; errno=$? ;;
                                c)  Test file can create ${file}; errno=$? ;;
                                d)  Test file can delete ${file}; errno=$? ;;
                            esac
                            if [[ "${errno}" != 0 ]]; then
                                status="${status}E"
                                FW_ELEMENT_FIL_STATUS_COMMENTS[${id}]="${FW_ELEMENT_FIL_STATUS_COMMENTS[${id}]}file(E):${file} "
                            else
                                status="${status}S"
                            fi
                            i=$(( i + 1 ))
                        done
                        case ${status} in
                            *E*)    FW_ELEMENT_FIL_STATUS[${id}]=E ;;
                            *W*)    FW_ELEMENT_FIL_STATUS[${id}]=W ;;
                            *S*)    FW_ELEMENT_FIL_STATUS[${id}]=S ;;
                        esac
                    fi
                done
            fi ;;


        modules)
            ;;


        parameters)
            if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_PAR_LONG[@]}; do
                    if [[ -n "${FW_ELEMENT_PAR_REQUESTED[${id}]:-}" ]]; then
                        echo "###"
##TODO veryfy parameter is set
                    fi
                done
            fi
            ;;


        projects)
            if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_PRJ_LONG[@]}; do
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_PRJ_MODES[${id}]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_PRJ_MODES[${id}]}" != "all" ]]; then continue; fi; fi

                    status="S"
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_APP[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_PRJ_REQUIRED_APP[${id}]}; do
                            case "${FW_ELEMENT_APP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 application "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}app(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${element}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}app(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${element}"
                                    status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}app(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]}; do
                            case "${FW_ELEMENT_DEP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 dependency "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dep(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 dependency "${element}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dep(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 dependency "${element}"
                                    status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dep(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]}; do
                            case "${FW_ELEMENT_PAR_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 parameter "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}par(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 parameter "${element}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}par(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 parameter "${element}"
                                    status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}par(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]}; do
                            case "${FW_ELEMENT_TSK_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}tsk(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}tsk(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                    status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}tsk(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_FILE[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_PRJ_REQUIRED_FILE[${id}]}; do
                            case "${FW_ELEMENT_FIL_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 file "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}fil(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 file "${element}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}fil(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 file "${element}"
                                    status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}fil(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_FILELIST[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_PRJ_REQUIRED_FILELIST[${id}]}; do
                            case "${FW_ELEMENT_FLS_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "file list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}fls(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "file list" "${element}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}fls(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "file list" "${element}"
                                    status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}fls(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]}; do
                            case "${FW_ELEMENT_DIR_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 directory "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dir(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 directory "${element}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dir(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 directory "${element}"
                                    status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dir(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_PRJ_REQUIRED_DIRLIST[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_PRJ_REQUIRED_DIRLIST[${id}]}; do
                            case "${FW_ELEMENT_DLS_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "directory list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dls(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "directory list" "${element}"
                                    status="${status}E"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dls(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "directory list" "${element}"
                                    status="${status}W"; FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]="${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}dls(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi

                    case ${status} in
                        *E*)    FW_ELEMENT_PRJ_STATUS[${id}]=E ;;
                        *W*)    FW_ELEMENT_PRJ_STATUS[${id}]=W ;;
                        *S*)    FW_ELEMENT_PRJ_STATUS[${id}]=S ;;
                    esac
                done
            fi ;;


        scenarios)
            if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_SCN_LONG[@]}; do
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SCN_MODES[${id}]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SCN_MODES[${id}]}" != "all" ]]; then continue; fi; fi

                    status="S"
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_APP[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SCN_REQUIRED_APP[${id}]}; do
                            case "${FW_ELEMENT_APP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 application "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}app(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}app(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}app(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DEP[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SCN_REQUIRED_DEP[${id}]}; do
                            case "${FW_ELEMENT_DEP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 dependency "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dep(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 dependency "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dep(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 dependency "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dep(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_PAR[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SCN_REQUIRED_PAR[${id}]}; do
                            case "${FW_ELEMENT_PAR_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 parameter "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}par(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 parameter "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}par(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 parameter "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}par(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]}; do
                            case "${FW_ELEMENT_TSK_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}tsk(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}tsk(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}tsk(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_FILE[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SCN_REQUIRED_FILE[${id}]}; do
                            case "${FW_ELEMENT_FIL_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 file "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}fil(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 file "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}fil(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 file "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}fil(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SCN_REQUIRED_FILELIST[${id}]}; do
                            case "${FW_ELEMENT_FLS_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "file list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}fls(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "file list" "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}fls(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "file list" "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}fls(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DIR[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SCN_REQUIRED_DIR[${id}]}; do
                            case "${FW_ELEMENT_DIR_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 directory "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dir(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 directory "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dir(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 directory "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dir(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SCN_REQUIRED_DIRLIST[${id}]}; do
                            case "${FW_ELEMENT_DLS_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "directory list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dls(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "directory list" "${element}"
                                    status="${status}E"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dls(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "directory list" "${element}"
                                    status="${status}W"; FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}dls(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi

                    case ${status} in
                        *E*)    FW_ELEMENT_SCN_STATUS[${id}]=E ;;
                        *W*)    FW_ELEMENT_SCN_STATUS[${id}]=W ;;
                        *S*)    FW_ELEMENT_SCN_STATUS[${id}]=S ;;
                    esac
                done
            fi ;;


        sites)
            if [[ "${FW_ELEMENT_SIT_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_SIT_LONG[@]}; do
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_SIT_MODES[${id}]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_SIT_MODES[${id}]}" != "all" ]]; then continue; fi; fi

                    status="S"
                    if [[ -n "${FW_ELEMENT_SIT_REQUIRED_APP[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SIT_REQUIRED_APP[${id}]}; do
                            case "${FW_ELEMENT_APP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 application "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}app(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${element}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}app(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${element}"
                                    status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}app(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DEP[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SIT_REQUIRED_DEP[${id}]}; do
                            case "${FW_ELEMENT_DEP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 dependency "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dep(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 dependency "${element}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dep(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 dependency "${element}"
                                    status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dep(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SIT_REQUIRED_PAR[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SIT_REQUIRED_PAR[${id}]}; do
                            case "${FW_ELEMENT_PAR_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 parameter "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}par(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 parameter "${element}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}par(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 parameter "${element}"
                                    status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}par(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SIT_REQUIRED_TSK[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SIT_REQUIRED_TSK[${id}]}; do
                            case "${FW_ELEMENT_TSK_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}tsk(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}tsk(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                    status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}tsk(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SIT_REQUIRED_FILE[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SIT_REQUIRED_FILE[${id}]}; do
                            case "${FW_ELEMENT_FIL_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 file "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}fil(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 file "${element}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}fil(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 file "${element}"
                                    status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}fil(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SIT_REQUIRED_FILELIST[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SIT_REQUIRED_FILELIST[${id}]}; do
                            case "${FW_ELEMENT_FLS_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "file list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}fls(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "file list" "${element}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}fls(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "file list" "${element}"
                                    status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}fls(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DIR[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SIT_REQUIRED_DIR[${id}]}; do
                            case "${FW_ELEMENT_DIR_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 directory "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dir(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 directory "${element}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dir(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 directory "${element}"
                                    status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dir(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_SIT_REQUIRED_DIRLIST[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_SIT_REQUIRED_DIRLIST[${id}]}; do
                            case "${FW_ELEMENT_DLS_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "directory list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dls(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "directory list" "${element}"
                                    status="${status}E"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dls(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "directory list" "${element}"
                                    status="${status}W"; FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]="${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}dls(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi

                    case ${status} in
                        *E*)    FW_ELEMENT_SIT_STATUS[${id}]=E ;;
                        *W*)    FW_ELEMENT_SIT_STATUS[${id}]=W ;;
                        *S*)    FW_ELEMENT_SIT_STATUS[${id}]=S ;;
                    esac
                done
            fi ;;


        tasks)
            if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" ]]; then
                for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_TSK_MODES[${id}]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_TSK_MODES[${id}]}" != "all" ]]; then continue; fi; fi

                    status="S"
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_APP[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_TSK_REQUIRED_APP[${id}]}; do
                            case "${FW_ELEMENT_APP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 application "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}app(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${element}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}app(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${element}"
                                    status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}app(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]}; do
                            case "${FW_ELEMENT_DEP_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 dependency "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dep(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 dependency "${element}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dep(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 dependency "${element}"
                                    status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dep(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]}; do
                            case "${FW_ELEMENT_PAR_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 parameter "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}par(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 parameter "${element}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}par(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 parameter "${element}"
                                    status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}par(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FILE[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_TSK_REQUIRED_FILE[${id}]}; do
                            case "${FW_ELEMENT_FIL_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 file "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}fil(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 file "${element}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}fil(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 file "${element}"
                                    status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}fil(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_TSK_REQUIRED_FILELIST[${id}]}; do
                            case "${FW_ELEMENT_FLS_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "file list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}fls(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "file list" "${element}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}fls(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "file list" "${element}"
                                    status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}fls(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]}; do
                            case "${FW_ELEMENT_DIR_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 directory "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dir(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 directory "${element}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dir(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 directory "${element}"
                                    status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dir(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]:-}" ]]; then
                        for element in ${FW_ELEMENT_TSK_REQUIRED_DIRLIST[${id}]}; do
                            case "${FW_ELEMENT_DLS_STATUS[${element}]}" in
                                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 "directory list" "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dls(N):${element} " ;;
                                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 "directory list" "${element}"
                                    status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dls(E):${element} " ;;
                                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 "directory list" "${element}"
                                    status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}dls(W):${element} " ;;
                                S)  status="${status}S" ;;
                            esac
                        done
                    fi

                    case ${status} in
                        *E*)    FW_ELEMENT_TSK_STATUS[${id}]=E ;;
                        *W*)    FW_ELEMENT_TSK_STATUS[${id}]=W ;;
                        *S*)    FW_ELEMENT_TSK_STATUS[${id}]=S ;;
                    esac
                done

                ## Again for requested tasks, once they are verified above
                for id in ${!FW_ELEMENT_TSK_LONG[@]}; do
                    if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "${FW_ELEMENT_TSK_MODES[${id}]}" ]]; then if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" != "all" && "${FW_ELEMENT_TSK_MODES[${id}]}" != "all" ]]; then continue; fi; fi
                    if [[ -n "${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]:-}" ]]; then
                        if [[ -n "${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]:-}" ]]; then
                            status="S"
                            for element in ${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]}; do
                                case "${FW_ELEMENT_TSK_STATUS[${element}]}" in
                                    N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 task "${element}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                                        status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}tsk(N):${element} " ;;
                                    E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 task "${element}"
                                        status="${status}E"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}tsk(E):${element} " ;;
                                    W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 task "${element}"
                                        status="${status}W"; FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]="${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}tsk(E):${element} " ;;
                                    S)  status="${status}S" ;;
                                esac
                            done
                            case ${status} in
                                *E*)    FW_ELEMENT_TSK_STATUS[${id}]=E ;;
                                *W*)    FW_ELEMENT_TSK_STATUS[${id}]=W ;;
                                *S*)    FW_ELEMENT_TSK_STATUS[${id}]=S ;;
                            esac
                        fi
                    fi
                done
            fi ;;

        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
