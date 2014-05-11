FROM ubuntu
MAINTAINER s. rannou <mxs@sbrk.org>

# deps
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y		    \
    git				   		      			    \
    binutils								    \
    gcc									    \
    wget								    \
    g++									    \
    make								    \
    portaudio19-dev							    \
    libpcre3-dev							    \
    mesa-common-dev							    \
    libgl1-mesa-dev

RUN git clone https://github.com/digego/extempore.git /extempore

RUN wget http://llvm.org/releases/3.2/llvm-3.2.src.tar.gz -O llvm.tar.gz && \
    tar -xf llvm.tar.gz && 				     		    \
    rm -f llvm.tar.gz && 				  		    \
    mv llvm-3.2.src /llvm &&						    \
    cd /llvm/lib/AsmParser &&						    \
    patch < /extempore/extras/llparser.patch &&				    \
    cd /llvm &&				     				    \
    mkdir /llvm-build &&						    \
    ./configure --prefix=/llvm-build --enable-optimized &&		    \
    make -j5 &&			     					    \
    make install &&							    \
    rm -rf /llvm

ENV EXT_LLVM_DIR /llvm-build

RUN cd /extempore &&							    \
    ./all.bash

CMD cd /extempore && /extempore/extempore