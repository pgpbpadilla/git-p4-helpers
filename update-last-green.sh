#!/bin/bash

# Adds/Updates the tag `last-green` to the Git commit associated
# to the Perforce Changelist number provided as argument.
#
# Updates the tag in the remote `origin`.

function update_last_green {

    if [ "$#" -ne 1 ]; then
	echo -e "Usage: $ .$0 <p4cl>\n"
	echo -e "\tp4cl - The Perforce changelist number\n"
	return -1
    fi

    P4CL=$1 # P4 Change List number

    # Fail if the specified commit does not exist in this repo
    SHA1=$(git log --format=format:%H --grep="${P4CL}") # The target commit
    if [ -z "${SHA1}" ]; then
	echo "Cannot find commit for P4 CL: $1"
	return -1
    fi

    echo "Commit ${SHA1} found for P4 CL: $1"

    # Make sure we delete the old tag locally
    if [ -n "$(git tag --list | grep last-green)" ]; then
	# Delete local tag
	git tag -d last-green
	# Create updated tag
	git tag last-green ${SHA1}
    fi

    # Check if the tag is in the remote
    if [ -n "$(git ls-remote --tags origin | grep last-green)" ]; then
	# Delete from remote
	if ! git push origin --delete last-green; then
	    echo "Failed to delete remote tag: last-green"
	    return -2
	fi
	
        # Push it to the remote
	if ! git push origin last-green; then
	    echo "Failed to push tag: last-green to remote"
	    return -3
	fi
    fi

    return 0
}

update_last_green $1
