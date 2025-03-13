# .zshrc
# James R Cheshire IV
#
# last updated 2025/02/16

# -- History --

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=5000

# -- User Configuration --

bindkey -e

setopt prompt_subst

# -- Prompt --
if  [ "$TERM" != "dumb" ]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd set-prompt
fi

# -- Aliases --
source ~/.zsh_alias

set -k # Allow comments in the shell

# -- Scripts --
source ~/.zsh_scripts

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

leftPrompt() {

    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
	branchinfo="   $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    else
	branchinfo=""
    fi

    if [ ! -z "${CONDA_DEFAULT_ENV}" ]; then
	condainfo=" 🐍 ${CONDA_DEFAULT_ENV} "
    else
	condainfo=""
    fi

    print -v wd -n -P '%n@%M: %~${branchinfo}'
    printf -v line '\n╭──%*s──╯' $#wd ''
    line=${line// /─}
    
    directory="%F{59}%K{59}%B%F{white}%n@%F{yellow}%M: %F{cyan}%~"
    arrows="%B%F{magenta}❯%B%F{yellow}❯%F{cyan}❯ "
    row1="\n%B%F{green}◆ "$directory"%B%F{green}"$branchinfo"%F{59}%k─╮"
    row2=$line
    row3="\n╰─%B%F{magenta}${condainfo}%F{59} "$arrows"%f%b"
 
    print $row1$row2$row3
}

rightPrompt() {
    row1="%T"
    print $row1
}

set-prompt() {
    PROMPT='$(leftPrompt)'
    RPROMPT='$(rightPrompt)'
}
