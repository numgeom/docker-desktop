# Builds a Docker image for NumGeom development environment
# with Ubuntu 16.04, Octave, Python3, Jupyter Notebook and Atom
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM fastsolve/desktop:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

ARG SSHKEY_ID=secure
ADD image/bin $DOCKER_HOME/bin
RUN chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME/bin

USER $DOCKER_USER

###############################################################
# Build NumGeom for Octave
###############################################################
RUN rm -f $DOCKER_HOME/.octaverc && \
    mkdir -p $DOCKER_HOME/.numgeom && \
    echo "\
    run /usr/local/paracoder/startup.m\n\
    run /usr/local/ilupack4m/startup.m\n\
    run /usr/local/petsc4m/startup.m\n\
    " > $DOCKER_HOME/.numgeom/startup.m && \
    \
    gd-get-pub -o - $(sh -c "echo '$SSHKEY_ID'") | tar xf - -C $DOCKER_HOME && \
    ssh-keyscan -H bitbucket.org >> $DOCKER_HOME/.ssh/known_hosts && \
    $DOCKER_HOME/bin/pull_numgeom && \
    $DOCKER_HOME/bin/build_numgeom

WORKDIR $DOCKER_HOME/numgeom
USER root
