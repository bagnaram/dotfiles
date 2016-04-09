DOTFILES := $(shell pwd)

all: shell xterm vim i3
mutt:
	ln -fs $(DOTFILES)/muttrc ${HOME}/.muttrc
	ln -fs $(DOTFILES)/mailcap ${HOME}/.mailcap
xterm:
	ln -fs $(DOTFILES)/Xdefaults ${HOME}/.Xdefaults
vim:
	ln -fs $(DOTFILES)/vimrc ${HOME}/.vimrc
i3:
	ln -fs $(DOTFILES)/i3_config  ${HOME}/.config/i3/config
	ln -fs $(DOTFILES)/i3_status.conf  ${HOME}/.config/i3/status.conf
