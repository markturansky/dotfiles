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

	cd $GOPATH/src/github.com/GoogleCloudPlatform/kubernetes

    # KUBERNETES!
    export LOG_LEVEL=5
    export KUBERNETES_PROVIDER=''
    export NUM_MINIONS=1
    alias kdn='ku; cluster/kube-down.sh'
    alias kfg='cluster/kubecfg.sh'
    alias k='cluster/kubectl.sh --v=5'
    alias kup="sudo PATH=$PATH -E hack/local-up-cluster.sh"

    alias v2='k create -f examples/persistent-volumes/volumes/local-02.yaml'
    alias c2='k create -f examples/persistent-volumes/claims/claim-02.yaml'
    alias p1='k create -f examples/persistent-volumes/simpletest/pod.yaml'

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

    cd $GOPATH/src/github.com/openshift/origin


    alias o='_output/local/go/bin/osc'

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
    docker rmi -f $(docker images -q)
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

function girfm(){
    grfm $1
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

function kill8(){
    ps -ef | grep 8080 | awk '{print $2}' | xargs sudo kill -9
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

function verify(){
    hack/verify-gofmt.sh
    hack/verify-description.sh
}

# usage: watch <your_command> <sleep_duration>
function watch(){
    while :;
      do
      clear;
      echo "$(date)"
      $1;
      sleep $2;
    done
}

function isempty(){
    DIR=$1
    # init
    # look for empty dir
    echo "$(ls -A $DIR)"
    if [ "$(ls -A $DIR)" ]; then
         echo "Take action $DIR is not Empty"
    else
        echo "$DIR is Empty"
    fi
}
