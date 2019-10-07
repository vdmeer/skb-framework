Set current phase File
if [[ -r "${FW_OBJECT_SET_VAL["CONFIG_FILE"]:-}" ]]; then
    Load settings from file "${FW_OBJECT_SET_VAL["CONFIG_FILE"]}"
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 11; fi
elif [[ -r "${FW_OBJECT_CFG_VAL["USER_CONFIG"]:-}" ]]; then
    Load settings from file "${FW_OBJECT_CFG_VAL["USER_CONFIG"]}"
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 12; fi
fi
