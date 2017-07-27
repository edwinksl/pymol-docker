FROM ubuntu:rolling

ENV PYMOL_URL https://sourceforge.net/projects/pymol/files/pymol/1.8
ENV PYMOL_VERSION 1.8.6.0
ENV PREFIX /opt/pymol
ENV MODULES $PREFIX/modules

RUN apt-get update && apt-get install -y \
  software-properties-common
RUN add-apt-repository -y \
  ppa:paulo-miguel-dias/mesa

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
RUN rm -rf /tmp/pymol

# Nasty workaround for GUI apps; slightly modified from http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
ENV USER_NAME developer
ENV USER_GROUP developer
ENV HOME /home/$USER_NAME
RUN export UID=1000 GID=1000 && \
  mkdir -p $HOME && \
  mkdir -p /etc/sudoers.d && \
  echo "$USER_NAME:x:$UID:$GID:$USER_NAME,,,:$HOME:/bin/bash" >> /etc/passwd && \
  echo "$USER_GROUP:x:$GID:" >> /etc/group && \
  echo "$USER_NAME ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER_NAME && \
  chmod 0440 /etc/sudoers.d/$USER_NAME && \
  chown $UID:$GID -R $HOME
USER $USER_NAME

VOLUME $PREFIX

CMD ["./pymol"]
