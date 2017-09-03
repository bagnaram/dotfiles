DOTFILES := $(shell pwd)

all: mutt xterm vim i3
mutt:
	ln -fs $(DOTFILES)/muttrc ${HOME}/.muttrc
	ln -fs $(DOTFILES)/mailcap ${HOME}/.mailcap
xterm:
	ln -fs $(DOTFILES)/Xdefaults ${HOME}/.Xdefaults
vim:
	ln -fs $(DOTFILES)/vim ${HOME}/.vim
	ln -fs $(DOTFILES)/vim/pathogen/autoload ${HOME}/.vim/autoload
i3:
	mkdir -p ${HOME}/.config/i3/
	ln -fs $(DOTFILES)/i3_config  ${HOME}/.config/i3/config
	ln -fs $(DOTFILES)/i3_status.conf  ${HOME}/.config/i3/status.conf
clean:
	rm ${HOME}/.muttrc
	rm ${HOME}/.mailcap
	rm ${HOME}/.Xdefaults
	rm ${HOME}/.vim/autoload/
	rm ${HOME}/.vim/
	rm ${HOME}/.config/i3/config
	rm ${HOME}/.config/i3/status.conf

