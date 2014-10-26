#!/bin/bash

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

function echogo(){
    echo "GOROOT=$GOROOT"
    echo "GOPATH=$GOPATH"
    echo "PATH=$PATH"
}

function devkube(){

	export GOPATH="$GOPATH:$GOPATH/src/github.com/GoogleCloudPlatform/kubernetes/Godeps/_workspace"		
	echogo
	alias work='cd /Users/markturansky/Projects/go/src/github.com/GoogleCloudPlatform/kubernetes'

    # KUBERNETES!
    export KUBERNETES_PROVIDER='vagrant'
    export KUBERNETES_NUM_MINIONS=1
    alias kup='ku; cluster/kube-up.sh'
    alias kdn='ku; cluster/kube-down.sh'
    alias kfg='ku; cluster/kubecfg.sh'
}

function devopen(){
	export GOPATH="$GOPATH:$GOPATH/src/github.com/openshift/origin/Godeps/_workspace"		
    export PATH="$PATH:/Users/markturansky/Projects/go/src/github.com/openshift/origin/_output/go/bin"
   	echo $GOPATH
   	alias work='cd /Users/markturansky/Projects/go/src/github.com/openshift/origin'
}

function platform(){

    platform='unknown'
    unamestr=`uname`
    if [[ "$unamestr" == 'Linux' ]]; then
       platform='linux'
       islinux=true
       source ~/.bash_profile_linux
    elif [[ "$unamestr" == 'Darwin' ]]; then
       platform='osx'
       isosx=true
       source ~/.bash_profile_osx
    fi

    echo $platform
}

function src(){
    source ~/.bash_profile
}

if [ ! -d "$HOME/bin"  ]; then
    echo "no $HOME/bin"
    echo "git clone https://github.com/markturansky/dotfiles.git $HOME"
fi

platform

alias ll='ls -l'
alias la='ls -la'

# git shortcuts
alias gs='git status'


# Git support
[ -f /usr/share/git-core/contrib/completion/git-prompt.sh ] && . /usr/share/git-core/contrib/completion/git-prompt.sh >/dev/null
[ -f /etc/bash_completion.d/git ] && . /etc/bash_completion.d/git >/dev/null

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

# Color setup
prompt_title="\033]0;\W\007\n\[\e[1;37m\]"
prompt_glyph="★"

color_reset="\[\e[0;39m\]"
color_user="\[\e[1;33m\]"
color_host="\[\e[1;36m\]"
color_pwd="\[\e[0;33m\]"
color_git="\[\e[0;36m\]"
color_glyph="\[\e[35;40m\]"

# Thy holy prompt.
PROMPT_COMMAND='history -a;PS1="${prompt_title}${color_glyph}${prompt_glyph}${color_reset} ${color_user}\u${color_reset}:${color_pwd}\w${color_reset}${color_git} ${color_reset} \[\e[1;37m\]${color_reset}\n$ "'

export TERM="xterm-color" PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '



