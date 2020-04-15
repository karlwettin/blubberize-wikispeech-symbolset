#!/bin/bash

echo "Executing entrypoint..."

DIR=`pwd`

export GOROOT=${DIR}/go
export GOPATH=${DIR}/goProjects
export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

cd ${DIR}/src/symbolset/server
./server -ss_files ss_files
