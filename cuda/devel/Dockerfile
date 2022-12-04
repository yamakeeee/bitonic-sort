FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y sudo && \
    apt-get install -y build-essential && \
    apt-get install -y vim && \
    apt-get install -y wget && \
    apt-get install -y unzip && \
    apt-get install -y git && \
    apt-get install -y libssl-dev

# Install compilers.
RUN apt-get install -y gcc && \
    apt-get install -y g++

# SET path to compilers.
# https://stackoverflow.com/questions/17275348/how-to-specify-new-gcc-path-for-cmake
ENV CC=/usr/bin/gcc \
    CXX=/usr/bin/g++

# Install newer CMake manually
# https://qiita.com/hyasuda/items/16c21458f0ecd08db857
RUN cd $HOME && \
    wget https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1.tar.gz && \
    tar zxvf cmake-3.17.1.tar.gz && \
    cd cmake-3.17.1/ && \
    ./bootstrap && \
    make -j12 && sudo make install -j8
RUN echo 'export PATH=$HOME/cmake-3.17.1/bin/:$PATH' >> ~/.bashrc && \
    . ~/.bashrc

# OpenBlas, Lapack
RUN apt-get install -y libopenblas-dev && \
    apt-get install -y liblapack-dev

# Please use below directory to install cpp libraries.
WORKDIR $HOME/usr/
RUN mkdir ./library

CMD bash