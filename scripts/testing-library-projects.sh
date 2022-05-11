#!/bin/bash

echo \> apax --version

apax --version
exitcode=$?
if [ $exitcode -ne 0 ]; then
    echo "Apax is not installed, please install apax first"
    exit $exitcode
fi

echo \> apax install
apax install -L
exitcode=$?
if [ $exitcode -ne 0 ]; then
    echo "Directory not a apax project, apax.yml is required"
    exit $exitcode; 
fi


echo \> apax build
apax build
exitcode=$?
if [ $exitcode -ne 0 ]; then 
    echo "Failed building the apax library"
    exit $exitcode;
fi

echo \> apax test
apax test
exitcode=$?
if [ $exitcode -ne 0 ]; then 
    echo "Tests failed"
    exit $exitcode;
fi