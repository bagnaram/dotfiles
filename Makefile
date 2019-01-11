DOTFILES := $(shell pwd)

.PHONY: all
all: mutt xterm vim i3 screen redshift dunst

.PHONY: ohmyzsh
ohmyzsh:
	if [ ! -d "${HOME}/.zshrc" ]; then \
	  ln -fs $(DOTFILES)/zshrc ${HOME}/.zshrc; \
	  echo "export ZSH=\"$(DOTFILES)/zsh\"" >> $(DOTFILES)/zshrc; \
	fi; 

.PHONY: mutt
mutt:
	if [ ! -d "${HOME}/.mutt" ]; then ln -fs $(DOTFILES)/mutt ${HOME}/.mutt; fi

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
.PHONY: i3
dunst:
	mkdir -p ${HOME}/.config/dunst/
	ln -fs $(DOTFILES)/dunstrc  ${HOME}/.config/dunst/dunstrc
.PHONY: clean
clean:
	rm ${HOME}/.muttrc
	rm ${HOME}/.mailcap
	rm ${HOME}/.Xdefaults
	rm ${HOME}/.vim/autoload/
	rm ${HOME}/.vim/
	rm ${HOME}/.config/i3/config
	rm ${HOME}/.config/i3/status.conf

