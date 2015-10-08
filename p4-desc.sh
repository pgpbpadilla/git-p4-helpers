function files_from_p4_cl {

    if [[ ($# > 2) || ($# < 1) ]]; then
	echo -e "Invalid arguments: $# \n"

	for arg in $@
	do
	    echo -e "\t$arg"
	done
	
	echo -e "\nUsage: $ cmd <cl> <prefix>\n"
	echo -e "\tcl - is the P4 change list number\n"
	echo -e "\tprefix - Prefix string to remove from the file URI\n"
	return -1
    fi
    
    CL=$1
    PREFIX=$2
    echo "CL - $CL"
    echo "PREFIX - $PREFIX"

    IFS=$'\n' # Make the new line the separator

    CL_FILES=$(p4 describe $CL | grep '^[.]\{3\}')

    for file in $CL_FILES
    do
	NO_SUFFIX=$(echo $file |  sed 's/#.*$//')

	echo "Replacing '${PREFIX}' with './' in '$NO_SUFFIX'"
	echo -e ${NO_SUFFIX//"$PREFIX"/./}
    done
}

files_from_p4_cl "$@"
