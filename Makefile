DOTFILES := $(shell pwd)

.PHONY: all
all: mutt xterm vim i3 screen redshift
.PHONY: mutt
mutt:
	ln -fs $(DOTFILES)/muttrc ${HOME}/.muttrc
	ln -fs $(DOTFILES)/mailcap ${HOME}/.mailcap
.PHONY: xterm
xterm:
	ln -fs $(DOTFILES)/Xdefaults ${HOME}/.Xdefaults
.PHONY: screen
screen:
	ln -fs $(DOTFILES)/screenrc ${HOME}/.screenrc
.PHONY: vim
vim:
	if [ ! -d "${HOME}/.vim" ]; then ln -fs $(DOTFILES)/vim ${HOME}/.vim; fi
	if [ ! -d "${HOME}/.vim/autoload" ]; then ln -fs $(DOTFILES)/vim/pathogen/autoload ${HOME}/.vim/autoload; fi
.PHONY: redshift
redshift:
	if [ ! -d "${HOME}/.config/redshift.conf" ]; then ln -fs $(DOTFILES)/redshift.conf ${HOME}/.config/redshift.conf; fi
.PHONY: i3
i3:
	mkdir -p ${HOME}/.config/i3/
	ln -fs $(DOTFILES)/i3_config  ${HOME}/.config/i3/config
	ln -fs $(DOTFILES)/i3_status.conf  ${HOME}/.config/i3/status.conf
.PHONY: clean
clean:
	rm ${HOME}/.muttrc
	rm ${HOME}/.mailcap
	rm ${HOME}/.Xdefaults
	rm ${HOME}/.vim/autoload/
	rm ${HOME}/.vim/
	rm ${HOME}/.config/i3/config
	rm ${HOME}/.config/i3/status.conf

