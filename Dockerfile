# Builds a Docker image for NumGeom development environment
# with Ubuntu 16.04, Octave, Python3, Jupyter Notebook and Atom
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
ARG COMMIT=

RUN chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

USER $DOCKER_USER

###############################################################
# Build NumGeom for Octave
###############################################################
RUN gd-get-pub -o - $(sh -c "echo '$SSHKEY_ID'") | tar xf - -C $DOCKER_HOME && \
    ssh-keyscan -H github.com >> $DOCKER_HOME/.ssh/known_hosts && \
    rm -f $DOCKER_HOME/.octaverc && \
    mkdir -p $DOCKER_HOME/.numgeom && \
    echo "\
    run $DOCKER_HOME/fastsolve/ilupack4m/startup.m\n\
    run $DOCKER_HOME/fastsolve/paracoder/startup.m\n\
    run $DOCKER_HOME/fastsolve/petsc4m/startup.m\n\
    " > $DOCKER_HOME/.numgeom/startup.m && \
    \
    $DOCKER_HOME/bin/pull_numgeom $COMMIT && \
    $DOCKER_HOME/bin/build_numgeom && \
    \
    $DOCKER_HOME/bin/pull_numgeom2 && \
    rm -f $DOCKER_HOME/.ssh/id_rsa*

    # $DOCKER_HOME/bin/build_numgeom2 && \
    # \
    # gd-get-pub $(sh -c "echo '$MFILE_ID'") | \
    #     sudo bsdtar zxf - -C /usr/local --strip-components 2 && \
    # MATLAB_VERSION=$(cd /usr/local/MATLAB; ls) sudo -E /etc/my_init.d/make_aliases.sh && \
    # $DOCKER_HOME/bin/build_numgeom -matlab && \
    # $DOCKER_HOME/bin/build_numgeom2 -matlab && \
    # sudo rm -rf /usr/local/MATLAB/R*

WORKDIR $DOCKER_HOME/numgeom
USER root
