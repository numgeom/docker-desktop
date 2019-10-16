# Builds a Docker image for NumGeom development environment
# with Ubuntu, Octave, Python3, Jupyter Notebook and VS Code
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM fastsolve/desktop:dev
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

COPY image/config $DOCKER_HOME/.config
COPY image/bin /usr/local/bin
COPY image/share /usr/share
COPY image/etc /etc
COPY image/home $DOCKER_HOME

# Install texlive and lyx
RUN add-apt-repository ppa:lyx-devel/release && \
    sh -c "curl -s http://dl.openfoam.org/gpg.key | apt-key add -" && \
    add-apt-repository http://dl.openfoam.org/ubuntu && \
    apt-get update && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections && \
    apt-get install -q -y --no-install-recommends \
        texlive \
        texlive-lang-english \
        texlive-generic-recommended \
        texlive-latex-recommended \
        texlive-fonts-recommended \
        texlive-extra-utils \
        texlive-font-utils \
        texlive-formats-extra \
        texlive-generic-extra \
        texlive-latex-extra \
        texlive-bibtex-extra \
        texlive-publishers \
        texlive-pstricks \
        texlive-science \
        lmodern \
        \
        libxml2-dev \
        python-lxml \
        \
        preview-latex-style \
        dvipng \
        texmaker \
        lyx \
        fonts-lyx \
        msttcorefonts \
        jabref \
        imagemagick \
        hunspell \
        hunspell-en-us \
        aspell \
        aspell-en \
        ispell \
        evince \
        xpdf \
        at-spi2-core \
        psutils \
        pstoedit \
        ps2eps \
        gv \
        latex2rtf \
        latex2html \
        libreoffice \
        chktex \
        pandoc \
        \
        pinta \
        inkscape \
        tgif \
        xfig \
        cups cups-client \
        printer-driver-all \
        openprinting-ppds \
        system-config-printer \
        paraviewopenfoam56 \
        ffmpeg winff \
        libeigen3-dev && \
    apt-get clean && \
    curl -O http://bluegriffon.org/freshmeat/3.0.1/bluegriffon-3.0.1.Ubuntu16.04-x86_64.deb && \
    dpkg -i bluegriffon-3.0.1.Ubuntu16.04-x86_64.deb && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chown -R $DOCKER_USER:$DOCKER_USER $DOCKER_HOME && \
    pip3 install \
        python-igraph \
        networkx \
        meshio &&
    mv /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml_old

RUN chown -R $DOCKER_USER:$DOCKER_GROUP \
    $DOCKER_HOME/.numgeom $DOCKER_HOME/bin $DOCKER_HOME/WELCOME

USER $DOCKER_USER
RUN mkdir -p ~/.lyx && \
    ln -s -f $DOCKER_HOME/.config/LyX/preferences ~/.lyx

ARG SSHKEY_ID=secret
ARG MFILE_ID=secret
ARG BRANCH=
ARG COMMIT=

USER $DOCKER_USER

#############################
# Build NumGeom and PyNumGeom
#############################
RUN gd-get-pub -o - $(sh -c "echo '$SSHKEY_ID'") | tar xf - -C $DOCKER_HOME && \
    ssh-keyscan -H bitbucket.org >> $DOCKER_HOME/.ssh/known_hosts && \
    rm -f $DOCKER_HOME/.octaverc && \
    $DOCKER_HOME/bin/pull_pyng && \
    $DOCKER_HOME/bin/build_pyng && \
    $DOCKER_HOME/bin/pull_numgeom $BRANCH $COMMIT && \
    $DOCKER_HOME/bin/pull_numgeom2 && \
    $DOCKER_HOME/bin/build_numgeom && \
    $DOCKER_HOME/bin/build_numgeom2 && \
    \
    gd-get-pub -o - $(sh -c "echo '$MFILE_ID'") | \
        sudo bsdtar zxf - -C /usr/local --strip-components 2 && \
    MATLAB_VERSION=$(cd /usr/local/MATLAB; ls) sudo -E /etc/my_init.d/make_aliases.sh && \
    \
    $DOCKER_HOME/bin/build_numgeom -matlab && \
    $DOCKER_HOME/bin/build_numgeom2 -matlab && \
    sudo rm -rf /usr/local/MATLAB/R* && \
    \
    rm -f $DOCKER_HOME/.ssh/id_rsa*

WORKDIR $DOCKER_HOME/project
USER root
