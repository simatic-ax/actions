FROM ubuntu:18.04

# users API access token
ARG APAX_TOKEN=

RUN apt-get update
RUN apt-get -y install curl

# install prerequisites
RUN \ 
# apax requires node.js https://github.com/nodesource/distributions
echo "ℹ Downloading nodejs 14.x from nodesource.com" && \
curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
apt-get update && \
echo "ℹ Installing nodejs, git, libssl-dev and libtinfo5 for LLVM support" && \
apt-get install --assume-yes --no-install-recommends \
# for libLLVM
libtinfo5 \
git \
nodejs
# rm -rf /var/lib/apt/lists/*

RUN \
node -v && \
git -v && \
npm -v

# RUN |
#     cd /tmp
# mkdir apax-dep
# cd apax-dep
# npm init -y
# curl -H "Authorization: bearer $APAX_TOKEN" https://api.prod.ax.siemens.cloud/apax/login?format=npmrc\  >.npmrc
# npm add @ax/apax-signed
# npm install
# cd node_modules/@ax/apax-signed
# echo "-----BEGIN PUBLIC KEY-----" >public.pem
# echo "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4m2LqXil8zyn+Z9v0J93" >>public.pem
# echo "03hNjjrw6JMKvj0skNJvSaNPq1cYwq1Q/cu86Ny/Wl+lJT+Nzl32oKcgPuU+eY1Z" >>public.pem
# echo "VTm9ZYPmIuoO+WPEsW5v1q8u7LURJt5jMxyfVQLXakUzkrjdQY+8/fO77R/s7ndi" >>public.pem
# echo "qOXvoDw4SC8RAcbFVoske7R9L8nr8+lAjyOAs7fcWEOAkXaFF3BNIddxAGtAjXr5" >>public.pem
# echo "5y+ecHh0wom+diN3RdSDk5TqKl9F8lThAqd8LjFxRcjaeaKftruTB9yd+ppN/4wl" >>public.pem
# echo "avwaTQ/7eYHbvNV5aYeELUzxFykhsqKlIeo93y/ncnU0xS7W6ccCvNJ74kRfRtJY" >>public.pem
# echo "WwIDAQAB" >>public.pem
# echo "-----END PUBLIC KEY-----" >>public.pem
# cat public.pem
# openssl dgst -sha256 -verify public.pem -signature ax-apax.sig ax-apax-*.tgz
# npm install -g ax-apax-*.tgz
# apax --version
