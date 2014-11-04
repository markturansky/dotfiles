#!/bin/bash


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

dockerClear() {
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
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



# git rebase from master
function grfm(){

    git checkout master
    git fetch upstream
    git merge upstream/master
    git checkout $1
    git rebase -i master
}

# which etcd
function wetcd(){
    ps -ef | grep etcd
}
