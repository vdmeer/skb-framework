declare -A FW_INSTANCE_CLI_LONG     ## [long]="description"
declare -A FW_INSTANCE_CLI_SHORT    ## [short]=long
declare -A FW_INSTANCE_CLI_LS       ## [long]=short
declare -A FW_INSTANCE_CLI_ARG      ## [long]="argument"
declare -A FW_INSTANCE_CLI_CAT      ## [long]="category+name"
declare -A FW_INSTANCE_CLI_LEN      ## [long]="length: long + arg" + 5 for short/long dashes and short and blank, plus 1 if arg is set
declare -A FW_INSTANCE_CLI_SET      ## [long]="yes if option was set, no otherwise"
declare -A FW_INSTANCE_CLI_VAL      ## [long]="parsed value"
           FW_INSTANCE_CLI_EXTRA="" ## string with extra arguments parsed

FW_COMPONENTS_SINGULAR["Clioptions"]="clioption"
FW_COMPONENTS_PLURAL["Clioptions"]="clioptions"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Clioptions"]="Command Line Option"
FW_COMPONENTS_TITLE_LONG_PLURAL["Clioptions"]="CLI Options"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Clioptions"]="Command Line Option"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Clioptions"]="CLI Options"
FW_COMPONENTS_TABLE_DESCR["Clioptions"]="Description"
FW_COMPONENTS_TABLE_VALUE["Clioptions"]="Value from Command Line"
FW_COMPONENTS_TABLE_EXTRA["Clioptions"]=""
FW_COMPONENTS_TAGLINE["Clioptions"]="instance representing CLI options for tasks"



FW_COMPONENTS_SINGULAR["Exitcodes"]="exitcode"
FW_COMPONENTS_PLURAL["Exitcodes"]="exitcodes"
FW_COMPONENTS_TITLE_LONG_SINGULAR["Exitcodes"]="Exit Code"
FW_COMPONENTS_TITLE_LONG_PLURAL["Exitcodes"]="Exit Codes"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["Exitcodes"]="Exit Code"
FW_COMPONENTS_TITLE_SHORT_PLURAL["Exitcodes"]="Exit Codes"
FW_COMPONENTS_TABLE_DESCR["Exitcodes"]="Description"
FW_COMPONENTS_TABLE_VALUE["Exitcodes"]="Description"
FW_COMPONENTS_TABLE_EXTRA["Exitcodes"]=""
FW_COMPONENTS_TAGLINE["Exitcodes"]="instance representing the framework's exit codes"



declare -A FW_INSTANCE_TABLE_CHARS  ## [id-format]="formatted char"
FW_INSTANCE_TABLE_CHARS_BUILT=" "   ## string with built formats, with leading and trailing space

FW_COMPONENTS_TAGLINE["Tablechars"]="instance that maintains cached table characters"