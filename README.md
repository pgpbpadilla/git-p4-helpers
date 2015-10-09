# Motivation

* I'm lazy.

# TL; DR

## Dependencies

* Properly setup Perforce CLI. You have to be able to login to P4 using its CLI.

## Scripts

* [`update-last-green.sh`](update-last-green.sh) - Adds/Updates the tag `last-green` to the Git commit associated with the Perforce Changelist number provided as argument. Updates the tag in the remote `origin`.
* [`p4-desc.sh`](p4-desc.sh) - List files affected by the Perforce changelist with  number `p4cl`.


# Long description

So, I've been working with `git-p4` in order to submit to a Perforce depot while doing my daily work with Git.

As I learn move about this workflow I have written a few scripts that save me some typing for common operations during my daily workflow.

## My setup

* Clone this repo into my `~/bin` directory
* I create symbolic links (`ln -s`) for each of the scripts but with shorter names so I won't have to type as much, did I mention I'm lazy?

	```bash
	p4-desc -> git-p4-helpers/p4-desc.sh
	green-up -> git-p4-helpers/update-last-green.sh
	```

## Use cases

### Getting the latest from P4 and tagging it

As part of my daily process I have to sync my Git repo with the latest changes submitted to the
Perforce depo and also keep a tag to the last successful build. It usually looks like this:

* Checkout the synchronization branch
* Synchronize with P4 depot
* Find the latest P4 changelist number that builds successfully
* Create/Update tag `last-green` in the commit corresponding to such changelist
* Update my remote (`origin`)

Using the script this becomes:

`$ ./update-last-green.sh 123123`

## List files affected in a Perforce changelist

Many times I'm pairing with someone but for some reason they need to share some changes with me but they don't use Git.
So after lecturing them I ask them to shelve their changes so I can get them and apply them to my Git repo.

Running `p4 describe` usually adds meta information that makes it hard to pipe its output to be processed by other commands like `rsync`, e.g.

```bash
	$ p4 describe <changelist>

	Change 123123 by user@domain on <timestamp>

		Changelist description...

	Jobs fixed ...

		Stuffs....

	Affected files ...

	... //path/to/depot/branch/path/to/file1.xml#3 edit
	... //path/to/depot/branch/path/to/file2.xml#3 edit
	... //path/to/depot/branch/path/to/file3.xml#3 edit

	Differences ...

       More stuffs...

```

So the script `p4-desc.sh` cleans up the output so that we can pipe it into `rsync` to bring those changes in to our Git repo, e.g.,

```bash
	$ ./p4-desc.sh <changelist> "... //path/to/depot/"
	./path/to/depot/branch/path/to/file1.xml
	./path/to/depot/branch/path/to/file2.xml
	./path/to/depot/branch/path/to/file3.xml
```

At the end the whole process using the script looks like this:

* Manually unshelve the wanted changes into a new changelist
  * this step is still manual but can be automated, see [p4 unshelve](http://www.perforce.com/perforce/r14.2/manuals/cmdref/p4_unshelve.html))
* Test overwrite (`rsync -avn`):
  * `$ ./p4-desc.sh <changelist> [<prefix>] | rsync -avn --files-from=- $P4_DEPO/ $GIT_REPO/`
* Overwrite (`rsync -av`):
  * `$ ./p4-desc.sh <changelist> [<prefix>] | rsync -av --files-from=- $P4_DEPO/ $GIT_REPO/`

**Caveats:** this probably won't work for files that have been removed, only in files added or modified.
