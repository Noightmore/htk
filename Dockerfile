#
# HTK (Hidden Markov Model Toolkit) Docker
# v3.4.1
# @author Loreto Parisi (loretoparisi at gmail dot com)
# v1.0.0
#
# Copyright (c) 2017 Loreto Parisi - https://github.com/loretoparisi/docker
#

# FROM ubuntu:16.04
FROM ubuntu:20.04

# Set working directory and environment
ENV HOME /root
WORKDIR $HOME

# Install required packages and clean up apt lists
RUN apt-get update && apt-get install -y \
    libc6-dev-i386 \
    libx11-dev \
    gawk \
    python3-dev \
    python3-pip \
    curl \
    git \
    libffi-dev \
 && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Jupyter Notebook
#RUN pip3 install --upgrade pip && \ #  pip==9.0.3 &&
#    pip3 install notebook

RUN pip3 install --upgrade pip  
RUN pip3 install notebook

# Create the desired folder structure (for HTK files and fun scripts)
RUN mkdir -p $HOME/htk/fun

# Copy HTK source files into the image and build HTK
COPY . $HOME/htk/
WORKDIR $HOME/htk/
RUN ./configure --disable-hslab && \
    make all && \
    make install

# Optionally, expose port 8888 (the default for Jupyter Notebook)
EXPOSE 8888

# Set the default command to run Jupyter Notebook on container start
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]

