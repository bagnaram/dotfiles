DOTFILES := $(shell pwd)

all: shell xterm vim
mutt:
	ln -fs $(DOTFILES)/muttrc ${HOME}/.muttrc
	ln -fs $(DOTFILES)/mailcap ${HOME}/.mailcap
xterm:
	ln -fs $(DOTFILES)/Xdefaults ${HOME}/.Xdefaults
vim:
	ln -fs $(DOTFILES)/vimrc ${HOME}/.vimrc

