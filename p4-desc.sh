function files_from_p4_cl {

    if [[ ($# > 2) || ($# < 1) ]]; then
       echo "Wrong number of paramters..."
       echo "Usage: $ cmd <cl> <prefix>"
       echo "cl - is the P4 change list number"
       echo "prefix - Prefix string to remove from the file URI"
       return -1
    fi
    
    CL=$1
    PREFIX=$2

    IFS=$'\n' # Make the new line the separator

    CL_FILES=$(p4 describe $CL | grep '^[.]\{3\}')

    for file in $CL_FILES
    do
	NO_SUFFIX=$(echo $file |  sed 's/#.*$//')
	NO_PREFIX=${NO_SUFFIX//$PREFIX/./}
	echo -e "${NO_PREFIX}"
    done
}

