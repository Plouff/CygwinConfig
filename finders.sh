##################################################################################
# Function myfinder
##################################################################################
myfinder ()
{
    local FILEPAT
    local DEFFILEPAT
    local SEARCHPATH
    local GREPPATTERN
    local IGNCASE
    local VERBOSITY
    local DISPCMD
    local SCRIPTNAME

    SCRIPTNAME="myfinder"
    VERBOSITY="-Hn"
    DISPCMD="false"

    simpleusage="${FUNCNAME[-1]} [-p|--searchpath SEARCHPATH] [-f|--filenamepattern FILEPAT]\n"
    simpleusage="$simpleusage      [-i|igncase] [-s|--short] [-d|--dispcommand] GREPPATTERN"

    scriptusage="myfinder [-p|--searchpath SEARCHPATH] [-f|--filenamepattern FILEPAT]\n"
    scriptusage="$scriptusage      [-i|igncase] [-s|--short] [-d|--dispcommand] --deffilepat FILEPAT GREPPATTERN"

    #
    # Parse command line arguments
    #
    while [[ $# -ge 1 ]]
    do
        key="$1"

        case $key in
            -f|--filenamepattern)
                FILEPAT="$2"
                shift # past argument
                ;;
            --deffilepat)
                DEFFILEPAT="$2"
                shift # past argument
                ;;
            -p|--searchpath)
                SEARCHPATH="$2"
                shift # past argument
                ;;
            -i|--igncase)
                IGNCASE="-i "
                ;;
            -s|--short)
                VERBOSITY=""
                ;;
            -d|--dispcommand)
                DISPCMD="true"
                ;;
            -h|--help)
                echo "Usage:"
                echo -e $simpleusage
                return 0
                ;;
            -ah|--advancedhelp)
                echo "Usage:"
                echo -e $scriptusage
                return 0
                ;;
            *)
                if [[ $GREPPATTERN == "" ]]; then
                    GREPPATTERN="$1"
                else
                    echo "###Error: Too many patterns: $1, $GREPPATTERN"
                    return -1
                fi
                ;;
        esac
        shift # past argument or value
    done

    #
    # Validate arguments
    #
    if [[ $SEARCHPATH = "" ]]; then
        SEARCHPATH="."
    fi

    # File pattern
    if [[ $FILEPAT = "" ]]; then
        if [[ $DEFFILEPAT = "" ]]; then
            FILEPAT="*"
        else
            FILEPAT="$DEFFILEPAT"
        fi
    fi

    # Grep pattern
    if [[ $GREPPATTERN == "" ]]; then
        echo "###Error: No grep pattern found"
        return -1
    fi

    #
    # Find matches
    #
    #find . -name "*.[ch]" -exec grep -aHn "REG_fDuty" {} \;
    if [[ $DISPCMD = "true" ]]; then
        echo "find $SEARCHPATH -type f -name \"${FILEPAT}\" -exec grep --color $IGNCASE -a $VERBOSITY \"$GREPPATTERN\" {} \;"
    fi

    find $SEARCHPATH -type f -name "${FILEPAT}" -exec grep --color $IGNCASE -a $VERBOSITY "$GREPPATTERN" {} \;
}


##################################################################################
# Function cfinder
##################################################################################
cfinder()
{
    myfinder --deffilepat "*.[ch]" $@
}

##################################################################################
# Function pyfinder
##################################################################################
pyfinder()
{
    myfinder --deffilepat "*.py" $@
}


