#Write fast config; Write slow config

if [[ "${FW_ELEMENT_OPT_SET["execute-task"]}" == "yes" ]]; then
    Execute task "${FW_ELEMENT_OPT_VAL["execute-task"]}" ${FW_ELEMENT_OPT_EXTRA}
    if (( $(Get object phase Task error count) > 0 )); then printf "\n"; Terminate framework 14; else Terminate framework 0; fi
fi

if [[ "${FW_ELEMENT_OPT_SET["execute-scenario"]}" == "yes" ]]; then
    Execute scenario "${FW_ELEMENT_OPT_VAL["execute-scenario"]}"
    if (( $(Get object phase Scenario error count) > 0 )); then printf "\n"; Terminate framework 15; else Terminate framework 0; fi
fi

if [[ "${FW_ELEMENT_OPT_SET["execute-command"]}" == "yes" ]]; then
    cmd="${FW_ELEMENT_OPT_VAL["execute-command"]}"
    case "$(Framework has actions) $(Framework has elements) $(Framework has instances) $(Framework has objects)" in
        *" ${cmd} "*)   ${cmd} ${FW_ELEMENT_OPT_EXTRA}
                        if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 17; else Terminate framework 0; fi ;;
        *)              Report application fatalerror E803 "${cmd}"; Terminate framework 16 ;;
    esac
fi
