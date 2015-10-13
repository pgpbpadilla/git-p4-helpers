# Prepares patch file and list of changed files to be reconciled in P4

function patch_for_p4 {

    if [ "$#" -ne 1 ]; then
	echo -e "\nIllegal number of parameters\n"
	echo -e "\nUsage: \$ $0 <range>\n"
	echo -e "\trange - a git revision range, e.g., abc123..abc124\n"
	return -1
    fi

    RANGE=$1
    TIMESTAMP=$(date +"%s" | cut -c 8-10)
    PATCH_FILE="patch-${TIMESTAMP}.diff"
    CHG_LIST="changes-${TIMESTAMP}.txt"
    
    if ! git diff --full-index --binary $RANGE > ${PATCH_FILE}; then
	rm ${PATCH_FILE}
	echo "Failed to generate diff file"
	return -1
    fi
    
    echo "Patch written to ${PATCH_FILE}"

    if ! git diff --name-only $RANGE > ${CHG_LIST}; then
	rm ${CHG_LIST}
	echo "Failed to generate list of changes"
	return -1
    fi
    
    echo "List of changes written to ${CHG_LIST}"
    
    return 0 # success
}


patch_for_p4 "$@"
