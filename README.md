<!-- Copyright 2021, Antonio Alvarado Hernández -->

The `tnothome` README
=====================

What?
-----

This repository contains a copy of my `%HOME%\Local` directory tree.

How?
----

### From Windows ###

You just need to create your own *home directory*, e.g. using the *Vincent's `setenv` tool* [1]:

~~~~
C:\> setenv -u HOME "%USERPROFILE%"
~~~~

Or, with _PowerShell_:

~~~~
$ [System.Environment]::SetEnvironmentVariable("HOME", $Env:USERPROFILE, "User")
~~~~

Now, to easy deploy it, you should execute following command at the *Command prompt*:

~~~~
C:\> git clone https://github.com/tnotstar/tnothome.git "%HOME%\Local"
~~~~

Or, with _PowerShell_:

~~~~
$ git clone https://github.com/tnotstar/tnothome.git "$env:HOME\Local"
~~~~

> **WARN:** Last command will fail if you already have a `%HOME%\Local` folder in your box.

It's useful to append `%HOME%\Local\bin` to the `PATH` environment variable.

~~~~
C:\> setenv -u PATH "%PATH%;%HOME%\Local\bin"
~~~~

### From Linux ###

Common Linux distros set the `$HOME` environment variable by default, so you just need to clone this repository:

~~~~{.sh}
$ git clone https://github.com/tnotstar/tnothome.git "$HOME/Local"
~~~~

Warning
-------

Tested only on *Windows XP SP3*, *Windows 7*, *Windows 10* and now *Ubuntu LTS 20.04*!!

[1]: http://barnyard.syr.edu/~vefatica/#SETENV

