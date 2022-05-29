DOTFILES := $(shell pwd)

.PHONY: all
all: mutt xterm vim i3 screen redshift dunst doom waybar rofi kanshi fnott swaylock

.PHONY: ohmyzsh
ohmyzsh:
	if [ ! -d "${HOME}/.zshrc" ]; then \
	  ln -fs $(DOTFILES)/zshrc ${HOME}/.zshrc; \
	  sed -i '1iexport ZSH="$(DOTFILES)/zsh"' $(DOTFILES)/zshrc; \
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
.PHONY: doom
doom:
	if [ ! -d "${HOME}/.doom.d" ]; then ln -fs $(DOTFILES)/.doom.d ${HOME}/.doom.d; fi
.PHONY: gammastep
gammastep:
	if [ ! -d "${HOME}/.config/gammastep" ]; then ln -fs $(DOTFILES)/gammastep ${HOME}/.config/gammastep; fi
.PHONY: vim
vim:
	if [ ! -d "${HOME}/.vim" ]; then ln -fs $(DOTFILES)/vim ${HOME}/.vim; fi
	if [ ! -d "${HOME}/.vim/autoload" ]; then ln -fs $(DOTFILES)/vim/pathogen/autoload ${HOME}/.vim/autoload; fi
.PHONY: mako
.PHONY: gpg-agent
gpg-agent:
	if [ ! -d "${HOME}/.gnupg/gpg-agent.conf" ]; then ln -fs $(DOTFILES)/gpg-agent.conf ${HOME}/.gnupg/gpg-agent.conf; fi
.PHONY: redshift
redshift:
	if [ ! -d "${HOME}/.config/redshift.conf" ]; then ln -fs $(DOTFILES)/redshift.conf ${HOME}/.config/redshift.conf; fi
.PHONY: i3
i3:
	mkdir -p ${HOME}/.config/i3/
	ln -fs $(DOTFILES)/i3_config  ${HOME}/.config/i3/config
	ln -fs $(DOTFILES)/i3_status.conf  ${HOME}/.config/i3/status.conf
.PHONY: sway
sway:
	if [ ! -d "${HOME}/.config/i3" ]; then ln -fs $(DOTFILES)/sway  ${HOME}/.config/i3; fi
.PHONY: dunst
dunst:
	mkdir -p ${HOME}/.config/dunst/
	ln -fs $(DOTFILES)/dunstrc  ${HOME}/.config/dunst/dunstrc
.PHONY: kanshi
kanshi:
	if [ ! -d "${HOME}/.config/kanshi" ]; then ln -fs $(DOTFILES)/kanshi  ${HOME}/.config/kanshi; fi
.PHONY: waybar
waybar:
	ln -fs $(DOTFILES)/waybar  ${HOME}/.config/waybar
.PHONY: pavolume
pavolume:
	ln -fs $(DOTFILES)/pavolume  ${HOME}/.config/pavolume
.PHONY: mako
mako:
	ln -fs $(DOTFILES)/mako  ${HOME}/.config/mako
.PHONY: fnott
fnott:
	ln -fs $(DOTFILES)/fnott  ${HOME}/.config/fnott
.PHONY: fontconfig
fontconfig:
	ln -fs $(DOTFILES)/fontconfig  ${HOME}/.config/fontconfig
.PHONY: swaylock
swaylock:
	ln -fs $(DOTFILES)/swaylock  ${HOME}/.config/swaylock
.PHONY: rofi
rofi:
	mkdir -p ${HOME}/.config/rofi/
	ln -fs $(DOTFILES)/rofi/config.rasi  ${HOME}/.config/rofi
.PHONY: alacritty
alacritty:
	mkdir -p ${HOME}/.config/alacritty/
	touch ${HOME}/.config/alacritty/alacritty.yml
	yq w -i ${HOME}/.config/alacritty/alacritty.yml import[+] $(DOTFILES)/alacritty/dracula.yml
.PHONY: foot
foot:
	if [ ! -d "${HOME}/.config/foot" ]; then ln -fs $(DOTFILES)/foot ${HOME}/.config/foot; fi
.PHONY: crontab
crontab:
	sed -i "s#DOTFILES#${DOTFILES}#g" ${DOTFILES}/cron/crontab
	(crontab -l ; cat ${DOTFILES}/cron/crontab)| crontab -
.PHONY: systemd
systemd:
	mkdir -p ${HOME}/.config/systemd/
	if [ ! -d "${HOME}/.config/systemd/user.control/" ]; then ln -fs $(DOTFILES)/systemd ${HOME}/.config/systemd/user.control; fi
	systemctl --user enable battery@`whoami`.service
	systemctl --user start battery@`whoami`.service
.PHONY: clean
clean:
	rm ${HOME}/.muttrc
	rm ${HOME}/.mailcap
	rm ${HOME}/.Xdefaults
	rm ${HOME}/.vim/autoload/
	rm ${HOME}/.vim/
	rm ${HOME}/.config/i3/config
	rm ${HOME}/.config/i3/status.conf
	rm ${HOME}/.zshrc
	rm ${HOME}/.doom.d
