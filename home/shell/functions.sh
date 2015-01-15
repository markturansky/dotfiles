#!/bin/bash

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
}

function src(){
    source ~/home/shell/rebash
    source ~/home/shell/mtail
}

function echogo(){
    echo "GOROOT=$GOROOT"
    echo "GOPATH=$GOPATH"
    echo "PATH=$PATH"
}

function ku(){

    export PATH="$PATH:~/go/src/github.com/coreos/etcd/bin"
    export GOPATH=~/openshift_3/src/github.com/GoogleCloudPlatform/kubernetes

	cd $GOPATH

	export GOPATH="$GOPATH:$GOPATH/Godeps/_workspace"
	echo "GOPATH: $GOPATH"

	pwd

    # KUBERNETES!
    export KUBERNETES_PROVIDER='local'
    export KUBERNETES_NUM_MINIONS=1
    alias kup='ku; cluster/kube-up.sh'
    alias kdn='ku; cluster/kube-down.sh'
    alias kfg='cluster/kubecfg.sh'
    alias kft='cluster/kubectl.sh'
    alias mtail='~/home/shell/mtail'
}

function devopen(){
	export GOPATH="$GOPATH:$GOPATH/src/github.com/openshift/origin/Godeps/_workspace"
    export PATH="$PATH:/Users/markturansky/Projects/go/src/github.com/openshift/origin/_output/go/bin"
   	echo $GOPATH
   	alias work='cd /Users/markturansky/Projects/go/src/github.com/openshift/origin'
}



dockerClear() {
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
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

# kill etcd
function ketcd(){

    LINE=`ps -ef | grep etcd | grep test`
    echo $LINE

    ## Convert string to bash array
    ARR=($LINE)

    if [ -z ${ARR[1]} ]; then
        echo 'nothing to kill'
    else
        echo "killing etcd pid ${ARR[1]}"
        kill ${ARR[1]}
    fi
}

function klog(){
    mtail /tmp/kube-apiserver.log /tmp/kube-controller-manager.log /tmp/kubelet.log /tmp/kube-proxy.log /tmp/kube-scheduler.log
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

function mm(){
    make clean
    make
}
function t(){
    hack/test-go.sh $1
}
function  i(){
    hack/test-integration.sh
}
function mmt(){
    mm
    t $1
}
function amend(){
    git commit --amend --no-edit
}
