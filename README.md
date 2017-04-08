# ubuntu-vps-setup
This Git repository contains a Makefile to set up Apt, Git &amp; rbenv on Ubuntu-16.04-based VPS.
The Makefile might work on other *nixen, too. The Makefile was tested with version 4.3.46(1)-release
of Bash. The Makefile is useful to document and set up a user's login and to avoid repeating the
same manual commands again and again. The reason it is a Makefile is that this way the prerequisites
are very sparing and ordinary and the prior setups will not get re-attempted (except in the case of
the Apt repository setup, which normally shouldn't matter much).

The main target of this Makefile, 'all', sets up Git, rbenv, rbenv-vars, and ruby-build.
Another target, 'apt-get', updates and upgrades the Apt repository.

See also https://gist.github.com/framallo/6283959 .
