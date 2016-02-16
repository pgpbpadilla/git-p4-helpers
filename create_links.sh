function create_links {

    if [ "$#" -ne 1 ]; then
	      echo -e "\nIllegal number of parameters\n"
	      echo -e "\nUsage: \$ $0 <target-path>\n"
	      return -1
    fi
    
    local TGT_DIR=$1

    ln patch_for_p4.sh $TGT_DIR/p4-patch
    ln p4_reconcile_files.sh $TGT_DIR/p4-recon
    ln p4-desc.sh $TGT_DIR/p4-desc
    ln update-last-green.sh $TGT_DIR/green-up

    return 0
}

create_links "$@"
