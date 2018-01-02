# Builds a Docker image for NumGeom development environment
# with Ubuntu 17.10, Octave, Python3, Jupyter Notebook and Atom
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM fastsolve/desktop:dev
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp
ADD image/home $DOCKER_HOME/

ARG SSHKEY_ID=secret
ARG MFILE_ID=secret
ARG BRANCH=
ARG COMMIT=

RUN chown -R $DOCKER_USER:$DOCKER_GROUP \
    $DOCKER_HOME/.numgeom $DOCKER_HOME/bin $DOCKER_HOME/WELCOME

USER $DOCKER_USER

###############################################################
# Build NumGeom for Octave
###############################################################
RUN gd-get-pub -o - $(sh -c "echo '$SSHKEY_ID'") | tar xf - -C $DOCKER_HOME && \
    ssh-keyscan -H github.com >> $DOCKER_HOME/.ssh/known_hosts && \
    rm -f $DOCKER_HOME/.octaverc && \
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

WORKDIR $DOCKER_HOME/numgeom
USER root
