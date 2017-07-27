FROM ubuntu:rolling

ENV PYMOL_URL https://sourceforge.net/projects/pymol/files/pymol/1.8
ENV PYMOL_VERSION 1.8.6.0
ENV PREFIX /opt/pymol
ENV MODULES $PREFIX/modules

RUN apt-get update && apt-get install -y \
  build-essential \
  freeglut3-dev \
  libfreetype6-dev \
  libglew-dev \
  libmsgpack-dev \
  libpng-dev \
  libxml2-dev \
  python-dev \
  python-pmw \
  subversion \
  wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget -qO - ${PYMOL_URL}/pymol-v${PYMOL_VERSION}.tar.bz2 | tar -xvj
WORKDIR pymol
RUN python setup.py build install --home=$PREFIX --install-lib=$MODULES --install-scripts=$PREFIX
WORKDIR $PREFIX

# Nasty workaround for GUI apps; slightly modified from http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${gid}:" >> /etc/group && \
    echo "developer ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer
USER developer
ENV HOME /home/developer

VOLUME $PREFIX

CMD ["./pymol"]
