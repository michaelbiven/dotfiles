FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        git \
        python \
        python-pip \
        software-properties-common \
        sudo \
        curl \
        man \
        locales-all \
        net-tools \
        dnsutils \
        iproute2 \
        iputils-ping && \
    rm -Rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get autoremove -y

# Add mbiven as user
RUN useradd --user-group \
            --create-home \
            --shell /bin/bash \
            mbiven && \
    echo 'mbiven ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
# Switch to damon user and /home/damon directory
USER mbiven
ENV HOME /home/mbiven
WORKDIR /home/mbiven


# Download and install Go.  GOROOT and GOPATH will be set in dot files
ENV GO_VERSION=1.9.1
RUN curl -LO https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    mv go goroot && \
    rm go${GO_VERSION}.linux-amd64.tar.gz && \
    mkdir -p src/go/bin

COPY . /home/mbiven/src/dotfiles

RUN mkdir .ssh && \
    sudo chown -R mbiven.mbiven /home/mbiven 

ENTRYPOINT ["/bin/bash"]
CMD ["--login"]