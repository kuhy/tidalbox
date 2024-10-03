FROM debian:bookworm

# SuperCollider version
ENV SC_VERSION=3.13.0

# SC plugins version
ENV SCP_VERSION=3.13.0

# SuperDirt version
ENV SD_VERSION=1.7.3

# Install packages
RUN apt update && apt install -y -q \
    pipewire-audio \
    pipewire-audio-client-libraries \
    wget \
    bzip2 \
    cmake \
    build-essential \
    libasound2-dev \
    libavahi-client-dev \
    libffi-dev \
    libfftw3-dev \
    libicu-dev \
    libjack-jackd2-dev \
    libncurses-dev \
    libreadline6-dev \
    libsndfile1-dev \
    libudev-dev \
    libxt-dev \
    git \
    ghc \
    cabal-install \
    npm

# Download SuperCollider
RUN mkdir -p /tmp/sc && \
    cd /tmp/sc && \
    wget -q https://github.com/supercollider/supercollider/releases/download/Version-$SC_VERSION/SuperCollider-$SC_VERSION-Source.tar.bz2 -O sc.tar.bz2 && \
    tar xvf sc.tar.bz2

# Build SuperCollider
RUN cd /tmp/sc/SuperCollider-$SC_VERSION-Source && \
    mkdir -p build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE="Release" \
    -DBUILD_TESTING=OFF \
    -DSUPERNOVA=ON \
    -DNATIVE=OFF \
    -DSC_WII=OFF \
    -DSC_QT=OFF \
    -DSC_ED=OFF \
    -DSC_EL=OFF \
    -DSC_VIM=OFF \
    .. && \
    make -j && \
    make install

# Download SC plugins
RUN mkdir -p /tmp/scp && \
    cd /tmp/scp && \
    wget -q https://github.com/supercollider/sc3-plugins/releases/download/Version-$SCP_VERSION/sc3-plugins-$SCP_VERSION-Source.tar.bz2 -O scp.tar.bz2 && \
    tar xvf scp.tar.bz2

# Build SC plugins
RUN cd /tmp/scp/sc3-plugins-$SCP_VERSION-Source && \
    mkdir -p build && \
    cd build && \
    cmake -DCMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu/ \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DSC_PATH=/tmp/sc/SuperCollider-$SC_VERSION-Source/ \
    -DQUARKS=ON \
    -DNATIVE=OFF \
    -DSUPERNOVA=ON .. && \
    make -j && \
    make install && \
    ldconfig && \
    mkdir /usr/local/share/SuperCollider/Extensions && \
    mv /usr/local/share/SuperCollider/SC3plugins /usr/local/share/SuperCollider/Extensions/SC3plugins

# Install SuperDirt
RUN echo "Quarks.install(\"SuperDirt\", \"v$SD_VERSION\"); 0.exit;" | sclang

# Install Tidal Cycles
RUN cabal update && cabal install tidal --lib

# Install Tidal Drum Patterns
RUN git clone https://github.com/lvm/tidal-drum-patterns && \
    cd tidal-drum-patterns && \
    cabal clean && \
    cabal configure && \
    cabal build && \
    cabal install --lib

# Install Flok
RUN npm install -g flok-web@latest flok-repl@latest

# SuperCollider startup file
COPY startup.scd /root/.config/SuperCollider/startup.scd

# Tidal Cycles startup file
COPY startup.hs /root/.config/tidal/startup.hs

# Startup script
COPY startup.sh /root/startup.sh
RUN chmod 755 /root/startup.sh
ENTRYPOINT ["/root/startup.sh"]
