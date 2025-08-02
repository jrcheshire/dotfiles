#!/usr/bin/env sh

cd ~/dotfiles || return
# Sync zshell and environment setup
rsync -a .zsh* ~
# sync tmux config
rsync -a .tmux.conf ~
# sync ssh config
rsync -a .ssh ~
# xbindkeysrc
rsync -a .xbindkeysrc ~
xbindkeys --poll-rc
# conda init, if conda exists
if command -v conda 2>&1 >/dev/null
then
    conda init zsh
fi
# doom emacs setup
rsync -av doom ~/.config/
if command -v doom 2>&1 >/dev/null
then
    doom sync
    if systemctl is-active --user --quiet emacs; then
        # killing emacs is unreliable unless done through Lisp, amusingly
        emacsclient -e '(kill-emacs)'
        sleep 5
        systemctl --user restart emacs
    fi
fi
