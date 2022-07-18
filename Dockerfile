FROM ubuntu:20.04@sha256:fd92c36d3cb9b1d027c4d2a72c6bf0125da82425fc2ca37c414d4f010180dc19


RUN apt-get update
RUN apt-get -y install curl wget

ADD https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb packages-microsoft-prod.deb
RUN apt-get update; \
    apt-get install -y  ca-certificates apt-transport-https; \	
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb; \	
    apt-get update && \
    apt-get install -y dotnet-sdk-3.1 dotnet-sdk-6.0

# Install npm
ADD https://deb.nodesource.com/setup_18.x install_nodejs.sh
RUN chmod 777 ./install_nodejs.sh && \
    ./install_nodejs.sh
RUN	apt-get install -y nodejs


RUN apt-get install -y git libtinfo5

# Install apax
COPY apax.tgz apax.tgz
RUN npm install --global apax.tgz
RUN apax --version

CMD  dotnet --info && \
    node --version && \
    npm --version