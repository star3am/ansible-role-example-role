ARG DOTNET_VERSION="3.1.413"
ARG UBUNTU_RELEASE="jammy"

FROM ubuntu:${UBUNTU_RELEASE}

ARG DEBIAN_FRONTEND=noninteractive
ARG MIRROR="http://archive.ubuntu.com"

# UBUNTU_RELEASE must be redeclared because it is used before "FROM"
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG UBUNTU_RELEASE="jammy"
ARG UBUNTU_VERSION="22.04.2"
ARG TARGETPLATFORM
ARG PKGS="\
apt-transport-https \
apt-utils \
build-essential \
ca-certificates \
curl \
wget \
git \
gnupg \
gpg \
jq \
libffi-dev \
libssl-dev \
lsb-release \
make \
openssh-client \
python3-crcmod \
python3-dev \
python3-pip \
python3-virtualenv \
python3-venv \
shellcheck \
snapd \
software-properties-common \
tree \
unzip \
zip \
nano \
vim \
less \
dos2unix \
"

# Env vars
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Apt Updates
RUN apt update && \
    apt install --no-install-recommends -y ${PKGS} && \
    apt upgrade -y && \
    apt autoremove --purge -y

# packages.microsoft.com repo key
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Microsoft hosted agent uses a User `vsts` with UID `1001` and GID `117`
# https://github.com/microsoft/azure-pipelines-agent/issues/2043#issuecomment-524683461
ARG USER_ID="1001"
RUN adduser --disabled-password --gecos "" --shell /bin/bash --uid ${USER_ID} ubuntu

# ansible
# Python virtual environment
# https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"
# ansible and dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir

# hadolint
ARG HADOLINT_VERSION="v2.10.0"
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=x86_64; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE=arm64; elif [ "$TARGETPLATFORM" = "linux/arm/v8" ]; then ARCHITECTURE=arm64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=x86_64; fi && \
    curl -Lo /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-${ARCHITECTURE} && \
    chmod +x /usr/local/bin/hadolint

# pre-commit https://pre-commit.com/#install
RUN python3 -m pip install --no-cache-dir --quiet --upgrade --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org git+https://github.com/pre-commit/pre-commit.git@v2.20.0

# cleanup
RUN apt autoremove --purge -y && \
    find /opt /usr/lib -name __pycache__ -print0 | xargs --null rm -rf && \
    rm -rf /var/lib/apt/lists/*

USER ubuntu
ENV PATH="$PATH:/home/ubuntu/.local/bin"

WORKDIR /app
