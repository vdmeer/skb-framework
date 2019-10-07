declare -A FW_INSTANCE_CLI_LONG     ## [long]="description"
declare -A FW_INSTANCE_CLI_SHORT    ## [short]=long
declare -A FW_INSTANCE_CLI_LS       ## [long]=short
declare -A FW_INSTANCE_CLI_ARG      ## [long]="argument"
declare -A FW_INSTANCE_CLI_CAT      ## [long]="category+name"
declare -A FW_INSTANCE_CLI_LEN      ## [long]="length: long + arg" + 5 for short/long dashes and short and blank, plus 1 if arg is set
declare -A FW_INSTANCE_CLI_SET      ## [long]="yes if option was set, no otherwise"
declare -A FW_INSTANCE_CLI_VAL      ## [long]="parsed value"
           FW_INSTANCE_CLI_EXTRA="" ## string with extra arguments parsed

FW_COMPONENTS_SINGULAR["clioptions"]="clioption"
FW_COMPONENTS_PLURAL["clioptions"]="clioptions"
FW_COMPONENTS_TITLE_LONG_SINGULAR["clioptions"]="Command Line Option"
FW_COMPONENTS_TITLE_LONG_PLURAL["clioptions"]="CLI Options"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["clioptions"]="Command Line Option"
FW_COMPONENTS_TITLE_SHORT_PLURAL["clioptions"]="CLI Options"
FW_COMPONENTS_TABLE_DESCR["clioptions"]="Description"
FW_COMPONENTS_TABLE_VALUE["clioptions"]="Value from Command Line"
#FW_COMPONENTS_TABLE_DEFVAL["clioptions"]=""
FW_COMPONENTS_TABLE_EXTRA["clioptions"]=""
FW_COMPONENTS_TAGLINE["clioptions"]="instance representing CLI options for tasks"



FW_COMPONENTS_SINGULAR["exitcodes"]="exitcode"
FW_COMPONENTS_PLURAL["exitcodes"]="exitcodes"
FW_COMPONENTS_TITLE_LONG_SINGULAR["exitcodes"]="Exit Code"
FW_COMPONENTS_TITLE_LONG_PLURAL["exitcodes"]="Exit Codes"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["exitcodes"]="Exit Code"
FW_COMPONENTS_TITLE_SHORT_PLURAL["exitcodes"]="Exit Codes"
FW_COMPONENTS_TABLE_DESCR["exitcodes"]="Description"
FW_COMPONENTS_TABLE_VALUE["exitcodes"]="Description"
#FW_COMPONENTS_TABLE_DEFVAL["exitcodes"]=""
FW_COMPONENTS_TABLE_EXTRA["exitcodes"]=""
FW_COMPONENTS_TAGLINE["exitcodes"]="instance representing the framework's exit codes"



declare -A FW_INSTANCE_TABLE_CHARS  ## [id-format]="formatted char"
FW_INSTANCE_TABLE_CHARS_BUILT=" "   ## string with built formats, with leading and trailing space

FW_COMPONENTS_TAGLINE["tablechars"]="instance that maintains cached table characters"