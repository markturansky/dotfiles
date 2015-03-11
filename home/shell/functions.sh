#!/bin/bash

function platform(){

    platform='unknown'
    unamestr=`uname`
    if [[ "$unamestr" == 'Linux' ]]; then
       platform='linux'
       islinux=true
       source ~/home/shell/.bash_profile_linux
    elif [[ "$unamestr" == 'Darwin' ]]; then
       platform='osx'
       isosx=true
       source ~/home/shell/.bash_profile_osx
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

    export GOPATH="$KUBE_ROOT"
	export GOPATH="$GOPATH:$GOPATH/Godeps/_workspace"

	cd $KUBE_ROOT

    # KUBERNETES!
    export KUBERNETES_PROVIDER=''
    export NUM_MINIONS=1
    alias kdn='ku; cluster/kube-down.sh'
    alias kfg='cluster/kubecfg.sh'
    alias kft='cluster/kubectl.sh --v=5'
    alias mtail='~/home/shell/mtail'

    alias cv1='kft create -f examples/persistent-volumes/volumes/local-01.yaml'
    alias cc1='kft create -f examples/persistent-volumes/claims/claim-01.yaml'
    alias cp1='kft create -f examples/persistent-volumes/pods/pod.yaml'

	echo "Kubernetes dev ... "
	echo "GOPATH                = $GOPATH"
	echo "KUBE_ROOT             = $KUBE_ROOT"
    echo "PWD                   = `pwd`"
    echo "KUBERNETES_PROVIDER   = $KUBERNETES_PROVIDER"
    echo "NUM_MINIONS           = $NUM_MINIONS"
    echo "boot2docker           = `boot2docker status`"
    echo "Happy hacking!"

}

function os(){

    export GOPATH="$ORIGIN_ROOT"
    cd $ORIGIN_ROOT

	echo "Origin dev ... "
	echo "GOPATH                = $GOPATH"
	echo "ORIGIN_ROOT           = $ORIGIN_ROOT"
    echo "PWD                   = `pwd`"
    echo "Happy hacking!"

}

dockerClearContainers() {
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
}

dockerClearImages() {
    dockerClearContainers
    docker rmi $(docker images)
}

dinit(){
    echo "Initializing boot2docker"
    $(boot2docker shellinit)
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
    git rebase master
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

function kup(){
    ku
    export LOG_LEVEL=5
    hack/local-up-cluster.sh
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
function  b(){
    hack/build-go.sh
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
