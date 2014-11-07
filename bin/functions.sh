#!/bin/bash


function echogo(){
    echo "GOROOT=$GOROOT"
    echo "GOPATH=$GOPATH"
    echo "PATH=$PATH"
}

function devkube(){

	export GOPATH="$GOPATH:$GOPATH/src/github.com/GoogleCloudPlatform/kubernetes/Godeps/_workspace"
	echogo
	alias work='cd /Users/markturansky/Projects/src/github.com/GoogleCloudPlatform/kubernetes'

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

    echo "---------------------------------------------------------"
    echo "Updating master and origin from upstream Kubernetes"
    echo "---------------------------------------------------------"
    git checkout master
    git fetch upstream
    git merge upstream/master
    git push origin master

    echo ""
    echo "---------------------------------------------------------"
    echo "Rebasing $1 from master"
    echo "---------------------------------------------------------"

    git checkout $1
    git rebase -i master
}

# which etcd
function wetcd(){
    ps -ef | grep etcd
}

function fullbuild(){

    ku
    hack/verify-gofmt.sh
    make clean
    make
    hack/test-go.sh
    hack/test-cmd.sh
    hack/test-integration.sh
}

function amend(){
    git commit --amend --no-edit
}
