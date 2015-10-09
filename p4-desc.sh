# List files affected by the Perforce changelist with  number `p4cl`
# - Remove the characters in `prefix` from each file in the list
# - It also removes the trailing characters at the end of the name, e.g., # 123

function files_from_p4_cl {

    if [[ ($# > 2) || ($# < 1) ]]; then
	echo -e "Invalid arguments: $# \n"

	for arg in $@
	do
	    echo -e "\t$arg"
	done
	
	echo -e "\nUsage: $ cmd <p4cl> <prefix>\n"
	echo -e "\tp4cl - is the P4 changelist number\n"
	echo -e "\tprefix - Prefix string to remove from the file URI\n"
	return -1
    fi
    
    CL=$1
    PREFIX=$2
    
    IFS=$'\n' # Make the new line the separator

    CL_FILES=$(p4 describe $CL | grep '^[.]\{3\}')

    for file in $CL_FILES
    do
	NO_SUFFIX=$(echo $file |  sed 's/#.*$//')

	echo -e ${NO_SUFFIX//"$PREFIX"/./}
    done
}

files_from_p4_cl "$@"
