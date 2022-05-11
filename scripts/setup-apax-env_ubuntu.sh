#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help() {
    # Display Help
    echo "Sets up apax and dependencies in an ubuntu environment"
    echo
    echo "Syntax: setup-apax-env-ubuntu [token] "
    echo "where:"
    echo "   t     sets your personal apax access token"
    echo

    exit 1
}

# check if the bash script is called with no argument or
# more arguments than one
if [[ $# -ne 1 ]]; then
    Help
fi

# Check if apt is installed and exiting early to save time
if command -v apax &>/dev/null; then
    echo "Apax already installed, skip installation"

    apax login -p $1

    exit 0
fi


echo "Checking system requirements.."

# Check if apt is installed and exiting early to save time
if ! command -v apt-get &>/dev/null; then
    echo "Error: apt has not been found, make sure that apt is installed"
    exit 1
fi

if ! command -v node &>/dev/null; then
    echo "Installing nodejs from nodesource"
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
else
    # Abusing bash again.. (https://unix.stackexchange.com/questions/285924/how-to-compare-a-programs-version-in-a-shell-script)
    # Check if node version >= 14 is installed as required by apax
    nodeversion="$(node -v)"
    requirednodever="14.0.0"

    if [ "$(printf '%s\n' "$requirednodever" "$nodeversion" | sort -V | head -n1)" = "$requirednodever" ]; then
        echo "NodeJs is already installed with the version $nodeversion"
    else
        echo "Installing nodejs from nodesource"
        curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
    fi
fi

sudo apt-get update
apt-get install --assume-yes --no-install-recommends
# for libLLVM
libtinfo5 \
    git nodejs

# Clean up apt lists
sudo rm -rf /var/lib/apt/lists/*

# Initialize a npm package in order to add apax as a dependency
# and adding the auth bearer to the npm config settings
mkdir apax-dep
npm init -y
curl -H "Authorization: bearer $1" https://api.prod.ax.siemens.cloud/apax/login?format=npmrc\  >.npmrc

npm add @ax/apax-signed
npm install

# verifying that the apax package has the correct signature 
cd node_modules/@ax/apax-signed
echo "-----BEGIN PUBLIC KEY-----" >public.pem
echo "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4m2LqXil8zyn+Z9v0J93" >>public.pem
echo "03hNjjrw6JMKvj0skNJvSaNPq1cYwq1Q/cu86Ny/Wl+lJT+Nzl32oKcgPuU+eY1Z" >>public.pem
echo "VTm9ZYPmIuoO+WPEsW5v1q8u7LURJt5jMxyfVQLXakUzkrjdQY+8/fO77R/s7ndi" >>public.pem
echo "qOXvoDw4SC8RAcbFVoske7R9L8nr8+lAjyOAs7fcWEOAkXaFF3BNIddxAGtAjXr5" >>public.pem
echo "5y+ecHh0wom+diN3RdSDk5TqKl9F8lThAqd8LjFxRcjaeaKftruTB9yd+ppN/4wl" >>public.pem
echo "avwaTQ/7eYHbvNV5aYeELUzxFykhsqKlIeo93y/ncnU0xS7W6ccCvNJ74kRfRtJY" >>public.pem
echo "WwIDAQAB" >>public.pem
echo "-----END PUBLIC KEY-----" >>public.pem
openssl dgst -sha256 -verify public.pem -signature ax-apax.sig ax-apax-*.tgz

# installing apax globally
sudo npm install -g ax-apax-*.tgz
apax --version
