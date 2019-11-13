#!/bin/bash

BASEDIR=`cd "$(dirname $0)"; pwd`

if [ "$#" -lt 1 ]; then
    echo "Illegal number of parameters, please provide demo name to run."
    echo "Usage: $0 <class name> <demo arguments>"
    echo "Example: $0 WriteDemo some_target_file \"some text I want to write to target file\""
    exit 1
fi

java -cp "build/libs/*:build/deps/*" com.datastax.bdp.fs.$1 "${@:2}"
