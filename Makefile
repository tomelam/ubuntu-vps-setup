# TODO: Check whether this Makefile should use 'sudo -i -u' in place of 'sudo su -' in some places.

SUDOER = tom
SUDOER_HOME = ~${SUDOER}
USER = rails
HOME = ~${USER}
PLUGINS = ${HOME}/.rbenv/plugins

all:	ssh sudoer ruby upgrade once

# TODO: Maybe use rbenv-installer from GitHub.
once:	/usr/bin/git rvm-implode rbenv rbenv-extras gemrc

# See http://unix.stackexchange.com/a/200256/223943 .
# Note: This is a fix for incoming and outgoing ssh.
# TODO: Check for existence of these lines properly and check only once per config file.
ssh:
	@echo
	@echo '*** Prevent SSH from freezing ***'
	#-sudo su - root -c 'if ! grep "# val0x00ff fix" /etc/ssh/ssh_config >/dev/null; then echo "Host *" >>/etc/ssh/ssh_config; fi'
	-sudo su - root -c 'if ! grep "# val0x00ff fix" /etc/ssh/ssh_config >/dev/null; then echo "ServerAliveInterval 100" >>/etc/ssh/ssh_config; fi'
	-sudo su - root -c 'if ! grep "# val0x00ff fix" /etc/ssh/ssh_config >/dev/null; then echo "# val0x00ff fix" >>/etc/ssh/ssh_config; fi'
	-sudo su - root -c 'if ! grep "# val0x00ff fix" /etc/ssh/sshd_config >/dev/null; then echo "ClientAliveInterval 60" >>/etc/ssh/sshd_config; fi'
	#-sudo su - root -c 'if ! grep "# val0x00ff fix" /etc/ssh/sshd_config >/dev/null; then echo "TCPKeepAlive yes" >>/etc/ssh/sshd_config; fi'
	-sudo su - root -c 'if ! grep "# val0x00ff fix" /etc/ssh/sshd_config >/dev/null; then echo "ClientAliveCountMax 10000" >>/etc/ssh/sshd_config; fi'
	-sudo su - root -c 'if ! grep "# val0x00ff fix" /etc/ssh/sshd_config >/dev/null; then echo "# val0x00ff fix" >>/etc/ssh/sshd_config; fi'
	@echo 'Now restart the ssh server'

# The first time this target is made on Ubuntu 16.04, it
# it is expected that it will be run as root, because
# there probably won't be any sudoer.
sudoer:	${SUDOER_HOME}

${SUDOER_HOME}:
	@echo
	sudo adduser ${SUDOER}
	sudo usermod -aG sudo ${SUDOER}

# TODO: Don't change .bash_profile if it already sets up rbenv.
ruby:	${HOME}/.rbenv
	@echo
	-sudo fallocate -l 1G /swapfile
	sudo chmod 600 /swapfile
	-sudo mkswap /swapfile
	-sudo swapon /swapfile
	sudo su - ${USER} -c 'rbenv install 2.4.0'
	sudo su - ${USER} -c 'rbenv global 2.4.0'

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

rvm-implode:
	@echo
	@echo '*** Remove rvm ***'
	sudo 'rvm implode'
	@echo 'Edit .bashrc, .bash_profile, and .profile manually to remove rvm from paths'

rbenv:	${HOME}/.rbenv rbenv-path rbenv-function

# TODO: Don't change .bash_profile if it already contains the lines needed for rbenv.
${HOME}/.rbenv:
	@echo
	@echo '*** Installing rbenv ***'
	sudo su - ${USER} -c "git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv"

rbenv-extras:	${PLUGINS}/rbenv-vars ${PLUGINS}/ruby-build

# On the subject of quoting and escaping, see http://unix.stackexchange.com/a/23349/223943 and http://stackoverflow.com/a/7860705/438912 .
rbenv-path:	${HOME}/.rbenv
	@echo
	@echo '*** Setting up rbenv path ***'
	-sudo su - ${USER} -c 'if ! grep '\''export PATH=\$$HOME/.rbenv/bin:\$$PATH'\'' ${HOME}/.profile >/dev/null; then echo export PATH=\$$HOME/.rbenv/bin:\$$PATH >>${HOME}/.bash_profile; fi'
	@echo 'User ${USER} must source his .bash_profile .'

rbenv-function:	${HOME}/.rbenv
	@echo
	@echo '*** Setting up rbenv to be a function ***'
	-sudo su - ${USER} -c 'if ! grep '\''eval \"$$(rbenv init -)\"'\'' ${HOME}/.profile >/dev/null; then echo '\''eval "$$(rbenv init -)"'\'' >>${HOME}/.bash_profile; fi'
	@echo 'User ${USER} must source his .bash_profile .'

${PLUGINS}/rbenv-vars:
	@echo
	@echo '*** Installing rbenv-vars ***'
	sudo su - ${USER} -c 'git clone https://github.com/sstephenson/rbenv-vars.git ${HOME}/.rbenv/plugins/rbenv-vars'

${PLUGINS}/ruby-build:
	@echo
	@echo '*** Installing ruby-build ***'
	sudo su - ${USER} -c 'git clone https://github.com/rbenv/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build'

gemrc:
	@echo
	@echo '*** Set up gems so that documentation is not automatically installed with them ***'
	sudo su - ${USER} -c 'if ! grep "gem: --no-rdoc --no-ri" ${HOME}/.gemrc >/dev/null; then echo "gem: --no-rdoc --no-ri" >>${HOME}/.gemrc; fi'
