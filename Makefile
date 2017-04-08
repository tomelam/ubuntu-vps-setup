USER = rails
SUDOER = tom
HOME = ~${USER}
SUDOER_HOME = ~${SUDOER}
PLUGINS = ${HOME}/.rbenv/plugins

all:	sudoer upgrade once

once:	/usr/bin/git rbenv rbenv-extras gemrc

# The first time this target is made on Ubuntu 16.04, it
# it is expected that it will be run as root, because
# there probably won't be any sudoer.
sudoer:	${SUDOER_HOME}

${SUDOER_HOME}:
	@echo
	sudo adduser ${SUDOER}
	sudo usermod -aG sudo ${SUDOER}

upgrade:	apt-get-update apt-get-upgrade

apt-get-update:
	@echo
	sudo apt-get update

apt-get-upgrade:	apt-get-update
	@echo
	sudo apt-get upgrade

/usr/bin/git:
	@echo
	sudo apt-get install git

rbenv:	${HOME}/.rbenv rbenv-path rbenv-function

${HOME}/.rbenv:
	@echo
	@echo '*** Installing rbenv ***'
	sudo su - ${USER} -c "git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv"

rbenv-extras:	${PLUGINS}/rbenv-vars ${PLUGINS}/ruby-build

# On the subject of quoting and escaping, see http://unix.stackexchange.com/a/23349/223943 and http://stackoverflow.com/a/7860705/438912 .
rbenv-path:	${HOME}/.rbenv
	@echo
	@echo '*** Setting up rbenv path ***'
	-sudo su - ${USER} -c 'if ! grep '\''export PATH=\$$HOME/.rbenv/bin:\$$PATH'\'' ${HOME}/.bashrc >/dev/null; then echo export PATH=\$$HOME/.rbenv/bin:\$$PATH >>${HOME}/.bashrc; fi'
	@echo 'User ${USER} must source his .bashrc .'

rbenv-function:	${HOME}/.rbenv
	@echo
	@echo '*** Setting up rbenv to be a function ***'
	-sudo su - ${USER} -c 'if ! grep '\''eval \"$$(rbenv init -)\"'\'' ${HOME}/.bashrc >/dev/null; then echo '\''eval "$$(rbenv init -)"'\'' >>${HOME}/.bashrc; fi'

${PLUGINS}/rbenv-vars:
	@echo
	@echo '*** Installing rbenv-vars ***'
	-sudo su - ${USER} -c 'git clone https://github.com/sstephenson/rbenv-vars.git ${HOME}/.rbenv/plugins/rbenv-vars'

${PLUGINS}/ruby-build:
	@echo
	@echo '*** Installing ruby-build ***'
	-sudo su - ${USER} -c 'git clone https://github.com/rbenv/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build'

gemrc:
	@echo
	@echo '*** Set up gems so that documentation is not automatically installed with them ***'
	sudo su - ${USER} -c 'if ! grep "gem: --no-rdoc --no-ri" ${HOME}/.gemrc >/dev/null; then echo "gem: --no-rdoc --no-ri" >>${HOME}/.gemrc; fi'
