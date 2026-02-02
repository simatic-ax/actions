FROM mcr.microsoft.com/dotnet/runtime:8.0.20
ARG APAX_TOKEN=

# Definiere Metadaten als ENV
ENV SIMATIC_AX_TITLE="SIMATIC AX Runner Image" \
    SIMATIC_AX_DESCRIPTION="Official runner image for SIMATIC AX applications and builds" \
    SIMATIC_AX_VENDOR="Siemens AG" \
    SIMATIC_AX_AUTHORS="SIMATIC AX TeamOfAXion" \
    SIMATIC_AX_LICENSE="MIT" \
    SIMATIC_AX_URL="https://console.simatic-ax.siemens.io/" \
    SIMATIC_AX_DOCUMENTATION="https://github.com/simatic-ax/ci-images/README.md" \
    SIMATIC_AX_SOURCE="https://github.com/simatic-ax/ci-images"

# Setze Labels aus ENV
LABEL org.opencontainers.image.title="${SIMATIC_AX_TITLE}" \
      org.opencontainers.image.description="${SIMATIC_AX_DESCRIPTION}" \
      org.opencontainers.image.vendor="${SIMATIC_AX_VENDOR}" \
      org.opencontainers.image.authors="${SIMATIC_AX_AUTHORS}" \
      org.opencontainers.image.licenses="${SIMATIC_AX_LICENSE}" \
      org.opencontainers.image.url="${SIMATIC_AX_URL}" \
      org.opencontainers.image.documentation="${SIMATIC_AX_DOCUMENTATION}" \
      org.opencontainers.image.source="${SIMATIC_AX_SOURCE}"

# Copy apax public key for later verification
COPY dockerfiles/apax-ci-image/apax-public-key.txt /tmp/apax-public-key.txt

# Step 1: Install basic system dependencies and prepare package sources
# We combine all repository preparations and basic tool installations to reduce layers
RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends --assume-yes \
        curl=7.88.1-10+deb12u14 \
        wget=1.21.3-1+deb12u1 \
    && apt-get update

# Step 2: Install all required SIMATIC AX dependencies
# We combine all package installations to reduce layers and cleanup in the same step
RUN set -ex \
    && apt-get install --no-install-recommends --assume-yes \
        git=1:2.39.5-0+deb12u2 \
        libtinfo6=6.4-4 \
        libtinfo5=6.4-4 \
        binutils=2.40-2 \
        libstdc++-12-dev=12.2.0-14+deb12u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Installed package versions:" \
    && dpkg-query -W -f='${Package}\t${Version}\n' \
        git libtinfo5 libtinfo6 binutils libstdc++-12-dev

# Step 3: Install Node.js using nvm and global npm packages
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=20.19.5
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin:${PATH}"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && npm install -g renovate@39.264.1

# Step 4: Install and verify apax
# We perform all apax-related operations in one step
RUN set -ex \
    && cd /tmp \
    && mkdir apax-dep \
    && cd apax-dep \
    && npm init -y \
    && curl -f -H "Authorization: bearer $APAX_TOKEN" \
        https://api.simatic-ax.siemens.io/apax/login?format=npmrc > .npmrc \
    && npm add "@ax/apax-signed@4.1.1" \
    && npm install \
    && cd node_modules/@ax/apax-signed \
    && { echo "-----BEGIN PUBLIC KEY-----"; \
        cat dockerfiles/apax-ci-image/apax-public-key.txt | tr -d '\r\n'; \
        echo ""; \
        echo "-----END PUBLIC KEY-----"; } > public.pem \
    && openssl dgst -sha256 -verify public.pem -signature ax-apax.sig ax-apax-*.tgz \
    && npm install -g ax-apax-*.tgz \
    && apax --version \
    && cd / \
    && rm -rf /tmp/apax-dep /tmp/apax-public-key.txt

# Kopiere das Entrypoint-Skript in den Container
COPY dockerfiles/apax-ci-image/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
