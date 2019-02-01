#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Must pass a path"
    exit 1
fi

BASEPATH=$1

for DIRECTORY in ${BASEPATH}/*; do
    pushd ${DIRECTORY} > /dev/null
        REPO=$(basename ${DIRECTORY})
        echo "Pulling '${REPO}'..."
        git pull -r
        if [ $? -ne 0 ]
        then
            echo "!! Problem with git pull in '${REPO}' !!"
        fi
    popd > /dev/null
    echo
done
