#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help() {
    # Display Help
    echo "Installs dependencies and builds a apax package"
    echo
    echo "Syntax: testing-library-projects [dir] [token]"
    echo "where:"
    echo "   dir     Directory of the library project"
    echo "   token   Sets your personal apax access token"

    exit 1
}

# check if the bash script is called with no argument or
# more arguments than one
if [[ $# -ne 2 ]]; then
    Help
fi

cd $1

pwd

echo \> apax --version

apax --version
exitcode=$?
if [ $exitcode -ne 0 ]; then
    echo "Apax is not installed, please install apax first"
    exit $exitcode
fi

echo $2

apax login --password $2

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
    echo "Failed building the apax package"
    exit $exitcode;
fi
