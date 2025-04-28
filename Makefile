help:
	@echo "help: Start by executing the \`start_here.sh\` script"

list:
	@sh -c "$(MAKE) -p no_op__ | \
		awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);\
		for(i in A)print A[i]}' | \
		grep -v '__\$$' | \
		grep -v 'make\[1\]' | \
		grep -v 'Makefile' | \
		sort"

# required for list
no_op__:

brew:
	brew bundle

editorconfig:
	cp .editorconfig ${HOME}/.editorconfig

jenv:
	echo # eval "$(jenv init -)"
	jenv enable-plugin export

pyenv:
	echo # which pyenv > /dev/null \
		 # if [ $? -ne 0 ]; then \
		 #   eval "$(pyenv init -)" \
		 # fi

nenv:
	echo # which nenv > /dev/null \
		 # if [ $? -ne 0 ]; then \
		 #   export PATH="$HOME/.nenv/bin:$PATH"
		 #   eval "$(nenv init -)" \
		 # fi

__cleanup:
	brew bundle cleanup

__cleanup-force:
	brew bundle cleanup --force --zap
