#
# .bashrc
# James Cheshire
# Last updated 7/19/2018

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# set the prompt
if [ $TERM = "dumb" ];then
        PS1="$ "
else
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[01;37m\]⚛\[\033[00m\] '
fi

export EDITOR=emacs
export CVS_RSH=ssh

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# auto prepend cd when entering a path
shopt -s autocd

# correct minor spelling errors in cd and directory names
shopt -s cdspell
shopt -s dirspell

# navigation and search aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ls='ls -B --color=auto'
alias ll='ls -alh'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ssh aliases
alias odyssey='ssh -YC jcheshire@login.rc.fas.harvard.edu'
alias holybicep='ssh -YC holybicep01'
alias spudws4='ssh -YC jcheshire@spudws4.spa.umn.edu'

# misc utility aliases
alias update='sudo pacman -Syu' # Pacman
#alias update='sudo dnf upgrade --refresh' # DNF
#alias update='sudo apt-get update; sudo apt-get upgrade' # Aptitude
alias diskspace='du -hS | sort -n -r | more'
alias rsync='rsync -axvuP'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


# script to extract archives
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


# odyssey-specific options
if [[ $HOSTNAME =~ .*"rclogin".* ]] || [[ $HOSTNAME =~ .*"holybicep".* ]]; then

    # Source global definitions
    if [ -f /etc/bashrc ]; then
	. /etc/bashrc
    fi

    # enable group write permissions
    umask 002

    # find and load modules
    if [[ $HOSTNAME =~ .*"holybicep".* ]]; then
        module use /n/holylfs/LABS/kovac_lab/general/software/modulefiles
        module load bicepkeck
        module load tmux
    fi
    
    # fix MANPATH
    export MANPATH=/usr/share/man:/usr/man:/usr/X11R6/man

    # aliases
    alias holybicep='ssh -YC jcheshire@holybicep01'
    alias matlab='matlab -nodesktop -nosplash'
    alias sq='squeue -u jcheshire -o "%.12i %.9P %.8u %.2t %.10M %.15R  %j"'
    alias sqq='/usr/bin/squeue -u jcheshire -o "%.12i %.9P %.8u %.2t %.10M %.15R  %j"'
    alias emacs='emacs -nw'
    
    function loadmatlab()
    {
	module unload bicepkeck/3.0.0
        module load bicepkeck/2.0.0
        alias matlab='matlab -nodesktop -nosplash -singleCompThread'
    }
    function loadmatlablatest()
    {
        module unload bicepkeck/2.0.0
        module load bicepkeck/3.0.0
        alias matlab='matlab -nodesktop -nosplash -singleCompThread'
    }
    
fi
