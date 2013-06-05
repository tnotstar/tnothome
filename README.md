The `tnothome` README
=====================

What?
-----

This folder contains a copy of my `%HOME%\Local` tree.


How?
----

You just need to creates your own *home directory*, e.g. using the *Vincent's `setenv` tool* [1]:

    C:\> setenv -u HOME "<put-your-home-directory-path-here>"

Now, to easy deploy it, you should execute following command at the *Command prompt*:

    C:\> hg clone https://bitbucket.org/tnotstar/tnothome "%HOME%\Local"
    destination directory: tnothome
    requesting all changes
    adding changesets
    adding manifests
    adding file changes
    added 1 changesets with 4 changes to 4 files
    updating to branch default
    4 files updated, 0 files merged, 0 files removed, 0 files unresolved

> **WARN:** Last command will fail if you already have a `%HOME%\Local` folder in your box.

It's useful to append `%HOME%\Local\bin` to the `PATH` environment variable.

    C:\> setenv -u PATH "%PATH%;%HOME%\Local\bin"

Warning
-------

Tested only on *Windows XP SP3* and *Windows 7*!

[1]: http://barnyard.syr.edu/~vefatica/#SETENV