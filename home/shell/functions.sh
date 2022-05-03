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

function u(){
	alias dm="docker-machine"
	alias q="psql -h localhost -p 5432 -U postgres uhc"	

	export GOPATH="/Users/markturansky/Projects/uhc"
	export PATH="$PATH:$GOPATH/bin"
	export LOG_LEVEL=0

	eval "$(docker-machine env default)"

	export OCM_ACCESS_TOKEN=$(cat ~/.ocm_token)


        # export GORM_CONNECTION="host=localhost port=5432 dbname=uhc  user=uhc_account_manager password='foobar bizz buzz' sslmode=disable"
        export GORM_DIALECT="postgres"
 	export GORM_DEBUG="true"
	export GORM_DIALECT="postgres"
	export GORM_HOST="localhost"
	export GORM_PORT="5432"
	export GORM_NAME="uhc"
	export GORM_USERNAME="uhc_account_manager"
	export GORM_PASSWORD="foobar bizz buzz"
	export GORM_SSLMODE="disable"

	cd $GOPATH/src/gitlab.cee.redhat.com/service/uhc-account-manager
	echo "UHC Account Management Services ... "
	echo "GOPATH                = $GOPATH"
	echo "PWD                   = `pwd`"
	echo "Happy hacking!"
}

function src(){
    source ~/home/shell/rebash
    source ~/home/shell/mtail
}

function edit(){
    vi ~/home/shell/functions.sh
}

function myip(){
  echo "$(ipconfig getifaddr en0)"
}


dockerClearContainers() {
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
}

dockerClearImages() {
    dockerClearContainers
    docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")    
    # docker rmi -f $(docker images -q)
}

dockerClear() {
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
}


# git rebase from master
function grfm(){

    echo "---------------------------------------------------------"
    echo "Updating master and origin from upstream"
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

# git rebase from main
function grfmain(){

    echo "---------------------------------------------------------"
    echo "Updating maain and origin from upstream"
    echo "---------------------------------------------------------"
    git checkout main
    git fetch upstream
    git merge upstream/main
    git push origin main

    echo ""
    echo "---------------------------------------------------------"
    echo "Rebasing $1 from main"
    echo "---------------------------------------------------------"

    git checkout $1
    git rebase main
}

# git rebase from develop
function grfd(){
        
    echo "---------------------------------------------------------"
    echo "Updating develop  and origin from upstream"
    echo "---------------------------------------------------------"
    git checkout develop
    git fetch upstream
    git merge upstream/develop
    git push origin develop
 
    echo ""
    echo "---------------------------------------------------------"
    echo "Rebasing $1 from develop"
    echo "---------------------------------------------------------"

    git checkout $1
    git rebase develop
}

function girfm(){
    grfm $1
    git rebase -i master
}



function t(){
    make test WHAT='$1'
}


function amend(){
    git commit --amend --no-edit
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


function gitrecent(){
    git for-each-ref --sort=-committerdate refs/heads/
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

function uhctest {
  (make test && make test-integration) &&
    (echo "" && echo '                               `::/s+s::::`
                              .+`:h+++o//+s:.
                              yosh+:--------:/:
        WooHoo!              oy+/+:------------+`
                            s+////--------------+
                           -y/////--------------+.
                           :s/////---:/:-----:::-/-
                           `y/////+/:...:/+/:-.-:/+
       .-:-`                o+///s- `     -/     ./.                 ---.
   -++/oo/:+:               .y/o+o  o-     o  `../--               .o+/+so+/.
 -/so:-:yo++s:             .syoyys.       :o//::o//               +o+++y+::+s:`
s/::/oos/:---:+            .+sd+soo/-..-://---:/yo-              +o:/--:ooo///+-
hoo:--y+--/o--s             :-ho++/:/+ossosssso+/++-```          y/-++/:+y:-/y-o
+oys++s++y/---+-            o+s+//+os+//:::::::::::/o/+:       .+o/--o+::o+/o/+-
 /oo+++:-+-----:/-          ooso+/yo/::::::::::::::+y:o.     -+o+/:--/------:/-
  .+o+//---------:/-        `.:h++y/:::::::::::::/:oss.   `:+++/:---------//.`
    -o+//:---------:/-`        y/+h/:::::::::::::/s//:  ./o+//:----------/-
     `/o+//:---------:/:.      y//ss/::::::::::/+/`  `:+++//:----------/:`
       -o+///-----------:/:/-` y///ooo+//////+s:``:/+so///:----------:/.
        `/o+//:-----------:s+//hooo+//++oo+//-y-:o-.-:/+/-----------/-
          .+o+//:---------:s  -o/..    ---+:-.s/.-+..`  -+/-------/:`
            .+o+//:------:o`   `+/     o  `//:s/` o`      -+:---:/.
              -oo+//:---/+`      +/---:-    -:``/.:-       `+::/.
                -oo+///+:         +             `o-         `s-
                  -yso+.          .              `+        `::
                   /s:...`                        /-    `.:-`
                    `-:/:--.``                    .s-::--.
        All             .-o+/:.                   `:/-`
        Tests           `+/..                        .:-
        Pass!          -+-..                           -/`
                     `/:...`                            `+`
                    -o-....                               o`
                   -o.....                                `+
                  .s......                                 o`') ||
    (echo "" && echo "You tried your best, and you failed miserably. The lesson is: never try.")
}

export OCM_INTEGRATION_URL="https://api.integration.openshift.com"

ocmint() {
    echo 'ocm login --token=${OCM_ACCESS_TOKEN} --url=${OCM_INTEGRATION_URL}'
    if ocm login --token=${OCM_ACCESS_TOKEN} --url=${OCM_INTEGRATION_URL}; then
        echo "Logged into ocm integration"
    else
        echo "Error logging into ocm integration"
        false
    fi
}
ocmstage() {
    echo 'ocm login --token=${OCM_ACCESS_TOKEN} --url=https://api.stage.openshift.com'
    if ocm login --token=${OCM_ACCESS_TOKEN} --url=https://api.stage.openshift.com; then
        echo "Logged into ocm stage"
    else
        echo "Error logging into ocm stage"
        false
    fi
}
ocmlocal() {
    echo 'ocm login --token=${OCM_ACCESS_TOKEN} --url=http://localhost:8000'
    if ocm login --token=${OCM_ACCESS_TOKEN} --url=http://localhost:8000; then
        echo "Logged into ocm local"
    else
        echo "Error logging into ocm local"
        false
    fi
}
ocmprod() {
    echo 'ocm login --token=${OCM_ACCESS_TOKEN} --url=https://api.openshift.com'
    if ocm login --token=${OCM_ACCESS_TOKEN} --url=https://api.openshift.com; then
        echo "Logged into ocm prod"
    else
        echo "Error logging into ocm prod"
        false
    fi
}
