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

VOLUME $PREFIX

CMD ["./pymol"]
