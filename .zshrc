# .zshrc
# James R Cheshire IV
#
# last updated 2019/06/23

#source .zshenv

# -- History --

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=5000

# -- User Configuration --

bindkey -e

setopt prompt_subst

# -- Prompt --

PROMPT=$'\e[37m┌[%B%n@\e[31m%M\e[37m%b]\e[0m\e[37m%B────%b[%B%~%b]\e[0m
\e[37m└─☉\e[0m '

export SUDO_PROMPT=$'\e[37m[\e[31;1msudo\e[0m]\e[37m password for \e[37;1m%p\e[0m\e[37m:\e[0m '

# -- Aliases --

# Utility aliases
alias ssh="ssh -YC"
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
alias ls="ls -B --color=tty"
alias ll="ls -alh --color=tty"
alias diskspace="du -hS --max-depth=1 | sort -n -r | more"
alias rsync="rsync -axvuEP"
alias emacs="emacs -nw"
alias nvrc="nordvpn disconnect && nordvpn connect"
alias thesiscompile='rm *.aux *.bbl *.blg *.dvi *.lof *.lot *.out *.xml *.toc ; pdflatex main && bibtex main && pdflatex main && pdflatex main'
alias updatekitty='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'
# -- Miscellaneous --

set -k # Allow comments in the shell

# -- Scripts --

# Script to extract archives
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

ca () {
    conda activate $1
    if [ ! -z "$CONDA_DEFAULT_ENV" ]
    then
	#PROMPT+="($CONDA_DEFAULT_ENV) "
	PROMPT="${PROMPT:0:56}($CONDA_DEFAULT_ENV)${PROMPT:56}"
    fi
}

cda () {
    # this might get mangled if you're nesting envs...
    conda deactivate
    PROMPT=$'\e[37m┌[%B%n@\e[31m%M\e[37m%b]\e[0m\e[37m%B────%b[%B%~%b]\e[0m
\e[37m└─☉\e[0m '
}

# -- Autocompletion --

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list ''
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl false
zstyle :compinstall filename '/home/jcheshire/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt autocd extendedglob notify

# set up history search with up/down arrow keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search


# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-beginning-search #up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-beginning-search #down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
[ -f /opt/mambaforge/etc/profile.d/conda.sh ] && source /opt/mambaforge/etc/profile.d/conda.sh
