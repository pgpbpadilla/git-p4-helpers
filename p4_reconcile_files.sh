# Reconciles all files listed in the file
function p4_reconcile_files {

    if [ "$#" -ne 1 ]; then
	echo -e "\nIllegal number of parameters\n"
	echo -e "\tUsage: \$ $0 <file list>\n"
	echo -e "\n\tfile list - path to a file with the list of files to reconcile\n"
	return 1
    fi

    for file in $(cat $1)
    do
	echo "Reconciling file: $file ..."
	p4 reconcile $file
    done

    return 0
}

p4_reconcile_files "$@"
