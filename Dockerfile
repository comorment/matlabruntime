FROM ubuntu:xenial



RUN apt-get -qq update && apt-get -qq install -y \
    unzip \
    xorg \
    wget \
    curl && \
    mkdir /mcr-install && \
    mkdir /opt/mcr && \
    cd /mcr-install && \
    wget --no-check-certificate -q https://ssd.mathworks.com/supportfiles/downloads/R2021a/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2021a_Update_5_glnxa64.zip && \
    unzip -q MATLAB_Runtime_R2021a_Update_5_glnxa64.zip && \
    rm -f MATLAB_Runtime_R2021a_Update_5_glnxa64.zip && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    rm -rf mcr-install

    # octave

RUN apt-get update && apt-get install -y \
    octave \
    octave-control octave-image octave-io octave-optim octave-signal octave-statistics


# environment variables for MCR
ENV LD_LIBRARY_PATH /opt/mcr/v910/runtime/glnxa64:/opt/mcr/v910/bin/glnxa64:/opt/mcr/v910/sys/os/glnxa64:/opt/mcr/v910/extern/bin/glnxa64

ENV XAPPLRESDIR /opt/mcr/v910/X11/app-defaults

#ENV XAPPLRESDIR /etc/X11/app-defaults

ENV MCR_CACHE_ROOT /tmp

RUN apt-get update && apt-get install -y  --no-install-recommends apt-utils\
    python3 \
    tar \
    wget \
    unzip \
    git  \
  libgsl0-dev \
   perl \
    less \
    parallel \
    liboctave-dev \
    && \
    rm -rf /var/lib/apt/lists/*

 RUN  apt-get install -y liboctave-dev
