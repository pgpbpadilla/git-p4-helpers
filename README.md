# Helper scripts for git-p4

So, I've been working with `git-p4` in order to submit to a Perforce depot while doing my daily work with Git.

As I learn move about this workflow I have written a few scripts that save me some typing for commong operations during my daily workflow.

Here they are:

* [`update-last-green.sh`](update-last-green.sh) - Adds/Updates the tag `last-green` to the Git commit associated with the Perforce Changelist number provided as argument. Updates the tag in the remote `origin`.
