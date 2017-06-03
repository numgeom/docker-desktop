# Builds a Docker image for NumGeom development environment
# with Ubuntu 16.04, Octave, Python3, Jupyter Notebook and Atom
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM numgeom/desktop:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

# Install debugging tools and Atom
RUN add-apt-repository ppa:webupd8team/atom && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        meld \
        atom \
        clang-format && \
    curl -L https://goo.gl/ExjLDP | bsdtar zxf - -C /usr/local --strip-components 2 && \
    ln -s -f /usr/local/MATLAB/R2017a/bin/glnxa64/mlint /usr/local/bin && \
    apt-get clean && \
    pip3 install -U \
         autopep8 \
         flake8 \
         PyQt5 \
         spyder && \
    rm -rf /var/lib/apt/lists/* && \
    apm install \
        language-cpp14 \
        language-matlab \
        language-fortran \
        language-docker \
        autocomplete-python \
        autocomplete-fortran \
        git-plus \
        merge-conflicts \
        split-diff \
        gcc-make-run \
        platformio-ide-terminal \
        intentions \
        busy-signal \
        linter-ui-default \
        linter \
        linter-gcc \
        linter-gfortran \
        linter-flake8 \
        linter-matlab \
        dbg \
        output-panel \
        dbg-gdb \
        python-debugger \
        auto-detect-indentation \
        python-autopep8 \
        clang-format && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

ADD image/bin $DOCKER_HOME/bin
COPY sshkey /tmp/sshkey

# Clone NumGeom
RUN curl -L "https://onedrive.live.com/download?$(cat /tmp/sshkey)" | \
        tar xf - -C $DOCKER_HOME && rm -f /tmp/sshkey && \
    $DOCKER_HOME/bin/pull_numgeom && \
    $DOCKER_HOME/bin/build_numgeom && \
    \
    rm -f $DOCKER_HOME/.octaverc && \
    echo "@octave --force-gui" >> $DOCKER_HOME/.config/lxsession/LXDE/autostart && \
    echo "@atom $DOCKER_HOME/numgeom" >> $DOCKER_HOME/.config/lxsession/LXDE/autostart && \
    \
    chown -R $DOCKER_USER:$DOCKER_USER $DOCKER_HOME

WORKDIR $DOCKER_HOME/numgeom
