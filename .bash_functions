##################################################################################
# Function settitle
##################################################################################
settitle ()
{
  echo -ne "\e]2;$@\a\e]1;$@\a";
}

##################################################################################
# Function cd_func
##################################################################################
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}


##################################################################################
# Windows GVim Wrapper
##################################################################################
win_gvim_wrapper ()
{
  local continue_ files file

  continue_="true"
  files=""

  while [[ $continue_ == "true" ]]; do
    if [[ $1 != "" ]]; then
      file=`cygpath -d "$1"`
      echo $file
      files="$files $file"
      shift
    else
      continue_="false"
    fi
  done

  gvim $files
}

##################################################################################
# Function creplacer
##################################################################################
creplacer ()
{
    usage="cfinder [-p|--searchpath SEARCHPATH] [-f|--filenamepattern FILEPAT]\n"
    usage="$usage      [-i|igncase] [-s|--short] [-d|--dispcommand] SEARCHREGEXP REPLACESTRING"

    local FILEPAT
    local SEARCHPATH
    local SEARCHREGEXP
    local REPLACESTRING
    local IGNCASE
    local VERBOSITY
    local DISPCMD
    VERBOSITY="-Hn"
    DISPCMD="false"

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
            -p|--searchpath)
                SEARCHPATH="$2"
                shift # past argument
                ;;
            -i|--igncase)
                IGNCASE="i"
                ;;
            -s|--short)
                VERBOSITY=""
                ;;
            -d|--dispcommand)
                DISPCMD="true"
                ;;
            -h|--help)
                echo "Usage:"
                echo -e $usage
                return
                ;;
            *)
                if [[ $SEARCHREGEXP == "" ]]; then
                    SEARCHREGEXP="$1"
                elif [[ $REPLACESTRING == "" ]]; then
                    REPLACESTRING="$1"
                else
                    echo "###Error: Extra argument found: $1"
                    return
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

    if [[ $FILEPAT = "" ]]; then
        FILEPAT="*.[ch]"
    fi


    if [[ $SEARCHREGEXP == "" ]]; then
        echo "###Error: No search pattern found"
        return
    fi

    if [[ $REPLACESTRING == "" ]]; then
        echo "###Error: No replacement string found"
        return
    fi

    #
    # Find matches
    #
    if [[ $DISPCMD = "true" ]]; then
        echo "find $SEARCHPATH -name \"${FILEPAT}\" -exec sed -i \"s/$SEARCHREGEXP/$REPLACESTRING/g$IGNCASE\" {} \;"
    fi

    find $SEARCHPATH -name "${FILEPAT}" -exec sed -i -e "s/$SEARCHREGEXP/$REPLACESTRING/g$IGNCASE" {} \;
}


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



##################################################################################
# Function cfinder
##################################################################################
__cfinderOLD ()
{
    usage="cfinder [-p|--searchpath SEARCHPATH] [-f|--filenamepattern FILEPAT]\n"
    usage="$usage      [-i|igncase] [-s|--short] [-d|--dispcommand] GREPPATTERN"

    local FILEPAT
    local SEARCHPATH
    local GREPPATTERN
    local IGNCASE
    local VERBOSITY
    local DISPCMD
    VERBOSITY="-Hn"
    DISPCMD="false"

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
                echo -e $usage
                return
                ;;
            *)
                if [[ $GREPPATTERN == "" ]]; then
                    GREPPATTERN="$1"
                else
                    echo "###Error: Too many patterns: $1, $GREPPATTERN"
                    return
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

    if [[ $FILEPAT = "" ]]; then
        FILEPAT="*.[ch]"
    fi


    if [[ $GREPPATTERN == "" ]]; then
        echo "###Error: No grep pattern found"
        return
    fi

    #
    # Find matches
    #
    #find . -name "*.[ch]" -exec grep -aHn "REG_fDuty" {} \;
    if [[ $DISPCMD = "true" ]]; then
        echo "find $SEARCHPATH -name \"${FILEPAT}\" -exec grep --color $IGNCASE -a $VERBOSITY \"$GREPPATTERN\" {} \;"
    fi

    find $SEARCHPATH -name "${FILEPAT}" -exec grep --color $IGNCASE -a $VERBOSITY "$GREPPATTERN" {} \;
}


