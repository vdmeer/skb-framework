## maps to flaten naming edge cases and static component properties
## {name,,} means the name, plural, lower case
## components with special plural spelling (e.g. dependency/dependencies) can get 2 entries in each map

declare -A -g FW_COMPONENTS_SINGULAR                ## [name]="all lower case singular of the term for elements, instances, objects"
declare -A -g FW_COMPONENTS_PLURAL                  ## [name]="all lower case plural of the term for elements, instances, objects"
declare -A -g FW_COMPONENTS_TITLE_LONG_SINGULAR     ## [name]="Long Title, singular"
declare -A -g FW_COMPONENTS_TITLE_LONG_PLURAL       ## [name]="Long Title, plural"
declare -A -g FW_COMPONENTS_TITLE_SHORT_SINGULAR    ## [name]="Short Title, singular"
declare -A -g FW_COMPONENTS_TITLE_SHORT_PLURAL      ## [name]="Short Title, plural"
declare -A -g FW_COMPONENTS_TABLE_DESCR             ## [name]="text for table head when showing taglines"
declare -A -g FW_COMPONENTS_TABLE_VALUE             ## [name]="text for table head when showing values"
declare -A -g FW_COMPONENTS_TABLE_DEFVAL            ## [name]="text for table head when showing default values"
declare -A -g FW_COMPONENTS_TABLE_EXTRA             ## [name]="Extra properties in table", empty if none
declare -A -g FW_COMPONENTS_TAGLINE                 ## [name]="tagline", i.e. s short description

## create entries for the 4 components, they don't have a function defined
FW_COMPONENTS_SINGULAR["Actions"]="action"
    FW_COMPONENTS_PLURAL["Actions"]="actions"
    FW_COMPONENTS_TITLE_LONG_SINGULAR["Actions"]="Action"
    FW_COMPONENTS_TITLE_LONG_PLURAL["Actions"]="Actions"
    FW_COMPONENTS_TITLE_SHORT_SINGULAR["Actions"]="Action"
    FW_COMPONENTS_TITLE_SHORT_PLURAL["Actions"]="Actions"
    FW_COMPONENTS_TABLE_DESCR["Actions"]="Description"
    FW_COMPONENTS_TABLE_VALUE["Actions"]="Description"
    FW_COMPONENTS_TABLE_EXTRA["Actions"]=""

FW_COMPONENTS_SINGULAR["Elements"]="element"
    FW_COMPONENTS_PLURAL["Elements"]="elements"
    FW_COMPONENTS_TITLE_LONG_SINGULAR["Elements"]="Element"
    FW_COMPONENTS_TITLE_LONG_PLURAL["Elements"]="Elements"
    FW_COMPONENTS_TITLE_SHORT_SINGULAR["Elements"]="Element"
    FW_COMPONENTS_TITLE_SHORT_PLURAL["Elements"]="Elements"
    FW_COMPONENTS_TABLE_DESCR["Elements"]="Description"
    FW_COMPONENTS_TABLE_VALUE["Elements"]="Description"
    FW_COMPONENTS_TABLE_EXTRA["Elements"]=""

FW_COMPONENTS_SINGULAR["Instances"]="instance"
    FW_COMPONENTS_PLURAL["Instances"]="instances"
    FW_COMPONENTS_TITLE_LONG_SINGULAR["Instances"]="Instance"
    FW_COMPONENTS_TITLE_LONG_PLURAL["Instances"]="Instances"
    FW_COMPONENTS_TITLE_SHORT_SINGULAR["Instances"]="Instance"
    FW_COMPONENTS_TITLE_SHORT_PLURAL["Instances"]="Instances"
    FW_COMPONENTS_TABLE_DESCR["Instances"]="Description"
    FW_COMPONENTS_TABLE_VALUE["Instances"]="Description"
    FW_COMPONENTS_TABLE_EXTRA["Instances"]=""

FW_COMPONENTS_SINGULAR["Objects"]="object"
    FW_COMPONENTS_PLURAL["Objects"]="objects"
    FW_COMPONENTS_TITLE_LONG_SINGULAR["Objects"]="Object"
    FW_COMPONENTS_TITLE_LONG_PLURAL["Objects"]="Objects"
    FW_COMPONENTS_TITLE_SHORT_SINGULAR["Objects"]="Object"
    FW_COMPONENTS_TITLE_SHORT_PLURAL["Objects"]="Objects"
    FW_COMPONENTS_TABLE_DESCR["Objects"]="Description"
    FW_COMPONENTS_TABLE_VALUE["Objects"]="Description"
    FW_COMPONENTS_TABLE_EXTRA["Objects"]=""


## create entries for operations, it doesn't have a function defined
FW_COMPONENTS_SINGULAR["Operations"]="operation"
    FW_COMPONENTS_PLURAL["Operations"]="operations"
    FW_COMPONENTS_TITLE_LONG_SINGULAR["Operations"]="Operation"
    FW_COMPONENTS_TITLE_LONG_PLURAL["Operations"]="Operations"
    FW_COMPONENTS_TITLE_SHORT_SINGULAR["Operations"]="Operation"
    FW_COMPONENTS_TITLE_SHORT_PLURAL["Operations"]="Operations"
    FW_COMPONENTS_TABLE_DESCR["Operations"]="Function"
    FW_COMPONENTS_TABLE_VALUE["Operations"]="Description"
    FW_COMPONENTS_TABLE_EXTRA["Operations"]=""
