FROM maven:3.9-amazoncorretto-20 as build

WORKDIR /app

# Update and install necessary dependencies
RUN yum update -y && yum install -y \
    curl \
    jq \
    zip \
    unzip \
    file \
    diffutils \
    autoconf \
    gcc-c++ \
    fontconfig-devel \
    alsa-lib-devel \
    cups-devel \
    freetype-devel \
    libX11-devel \
    libXext-devel \
    libXrender-devel \
    libXrandr-devel \
    libXi-devel \
    libXtst-devel \
    libXt-devel \
    wget \
    make \
    tar

# Download and extract corretto-20 source code
RUN curl -sSL https://github.com/corretto/corretto-20/archive/refs/tags/20.0.1.9.1.tar.gz | tar xvz

# Download and extract binutils
RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.gz && tar xvzf binutils-2.38.tar.gz

# Configure and make hsdis
WORKDIR /app/corretto-20-20.0.1.9.1

RUN bash ./configure --with-hsdis=binutils --with-binutils-src=/app/binutils-2.38
RUN make clean build-hsdis

# Copy hsdis file to correct location
RUN cp build/linux-x86_64-server-release/support/hsdis/hsdis-amd64.so /usr/lib/jvm/java-20-amazon-corretto/lib/server/
