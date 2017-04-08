USER = tom
HOME = ~${USER}

all:	git rbenv rbenv-vars rbenv-build

apt-get:	apt-get-update apt-get-upgrade

apt-get-update:
	sudo apt-get update

apt-get-upgrade:	apt-get-update
	sudo apt-get upgrade

git:	/usr/bin/git

/usr/bin/git:
	sudo apt-get install git

rbenv:	${HOME}/.rbenv rbenv-path rbenv-function

${HOME}/.rbenv:
	sudo su - ${USER} -c "git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv"

# In the grep command below, ' ends a single-quoted string and \''
# adds a single quote then begins another single-quoted string.
# See http://unix.stackexchange.com/a/23349/223943 .
rbenv-path:
	@echo 'Testing that .rbenv/bin will be prepended to $$PATH'
	-sudo su - ${USER} -c 'if ! grep "export PATH=\".HOME/\.rbenv/bin:.PATH" ${HOME}/.bashrc >/dev/null; then echo "export PATH=''$$HOME/.rbenv/bin:PATH"'' >> /tmp/bashrc; fi'

rbenv-function:
	echo "function"
	#if grep 'eval "$$(rbenv init -)"' ${HOME}/.bashrc; then echo 'eval "$$(rbenv init -)"' >> ~/.bashrc; fi

rbenv-vars:	${HOME}/.rbenv/plugins/rbenv-vars

${HOME}/.rbenv/plugins/rbenv-vars:
	sudo su - ${USER} -c "git clone https://github.com/sstephenson/rbenv-vars.git ${HOME}/.rbenv/plugins/rbenv-vars"

rbenv-build:	${HOME}/.rbenv/plugins/ruby-build

${HOME}/.rbenv/plugins/ruby-build:
	sudo su - ${USER} -c "git clone https://github.com/rbenv/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build"
