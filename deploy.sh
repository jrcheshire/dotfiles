#!/usr/bin/env sh

cd ~/dotfiles || return
# Sync zshell and environment setup
rsync -av .zshrc ~
rsync -av .zsh_alias ~
rsync -av .zsh_env ~
rsync -av .zsh_scripts ~
# sync tmux config
rsync -av .tmux.conf ~
# sync ssh config
rsync -av .ssh ~
# conda init, if conda exists
if ! command -v conda 2>&1 >/dev/null
then
    exit 0
else
    conda init zsh
fi
# dom emacs setup
rsync -av doom ~/.config/
if ! command -v doom 2>&1 >/dev/null
then
    exit 0
else
    doom sync
    if systemctl is-active --user --quiet emacs; then
        # just doing systemctl restart randomly doesn't work...
        systemctl --user stop emacs
        sleep 5
        systemctl --user start emacs
    fi
fi
