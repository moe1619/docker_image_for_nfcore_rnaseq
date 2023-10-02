# Use the latest version of the official Ubuntu image as the base image
# FROM ubuntu:latest
# FROM python:3.11.5-slim
FROM rust:1.72.0-bullseye
#

# Set the maintainer label
LABEL maintainer="jm4279@cumc.columbia.edu"
# for easy upgrade later. ARG variables only persist during image build
ARG SAMTOOLSVER=1.18
ARG R_VERSION=4.0.4
ARG SALMON_VERSION=1.10.0


# RUN apt update && apt install -y --no-install-recommends python-is-python3 r-base-core=${R_VERSION} r-base-dev=${R_VERSION}
RUN apt update && apt install -y --no-install-recommends python-is-python3 r-base r-base-dev
# RUN java -version
# Update the package list and install curl and git
RUN apt-get update && apt-get install -y \
  apt-transport-https \
  autoconf \
  bedtools \
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
  g++ \
  gawk \
  gcc \
  git \
  gnupg \
  gnuplot \
  libboost-all-dev \
  libncurses5-dev \
  libbz2-dev \
  liblzma-dev \
  libcurl4 \
  libxml2-dev \
  libssl-dev \
  littler \
  make \
  nq \
  openjdk-17-jdk \ 
  openjdk-17-jre \ 
  perl \ 
  software-properties-common \
  unzip \
  wget \
  zlib1g-dev  && rm -rf /var/lib/apt/lists/*

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

# libcurl4-gnutls-dev \
# libcurl4-openssl-dev \

# Update pip to latest version
RUN python -m pip install --upgrade pip

# Install dependencies
COPY requirements.txt requirements.txt
 RUN python -m pip install -r requirements.txt

#install samtools
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLSVER}/samtools-${SAMTOOLSVER}.tar.bz2 && \
 tar -xjf samtools-${SAMTOOLSVER}.tar.bz2 && \
 rm samtools-${SAMTOOLSVER}.tar.bz2 && \
 cd samtools-${SAMTOOLSVER} && \
 ./configure && \
 make && \
 make install

# Install nf-core
#COPY setup.py setup.py
#COPY pyproject.toml pyproject.toml
# RUN python -m pip install .

# install STAR
RUN git clone https://github.com/alexdobin/STAR.git
RUN cd STAR/source
RUN make STAR

#install rsem
WORKDIR /usr/local/
RUN pwd
RUN git clone https://github.com/deweylab/RSEM.git
WORKDIR /usr/local/RSEM
RUN pwd
RUN git checkout v1.3.3
RUN make 
RUN make install
ENV PATH /usr/local/RSEM:$PATH

#install umi-tools
RUN pip install umi_tools

# INSTALL QUALIMAP
RUN ln -s /usr/lib/x86_64-linux-gnu/libncursesw.so.6 /usr/lib/x86_64-linux-gnu/libncursesw.so.5

#Install R 3.6
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 51716619E084DAB9 && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran35/" && apt update && apt install -y r-base

#Install Bioconductor packages required by Qualimap
RUN Rscript -e "install.packages('optparse')"
RUN Rscript -e "install.packages('BiocManager', repos = 'http://cran.us.r-project.org')"
RUN Rscript -e "BiocManager::install(c('NOISeq', 'Repitools','Rsamtools', 'GenomicFeatures', 'rtracklayer','DESeq2'))"

#Install Qualimap
RUN cd /opt && wget https://bitbucket.org/kokonech/qualimap/downloads/qualimap_v2.3.zip && unzip qualimap_v2.3.zip && rm qualimap_v2.3.zip
# RUN Rscript /opt/qualimap_v2.3/scripts/installDependencies.r

ENV PATH="/opt/qualimap_v2.3:$PATH"

# Install dependencies and Rust
 RUN cargo --help

# install fq
WORKDIR /usr/local/
RUN pwd
RUN git clone --depth 1 --branch v0.11.0 https://github.com/stjude-rust-labs/fq.git
WORKDIR /usr/local/fq
RUN pwd
RUN cargo install --locked --path .
ENV PATH="/user/local/fq:$PATH"

# install salmon
WORKDIR /usr/local/
RUN wget https://github.com/COMBINE-lab/salmon/releases/download/v${SALMON_VERSION}/salmon-${SALMON_VERSION}_linux_x86_64.tar.gz && tar xzf salmon-${SALMON_VERSION}_linux_x86_64.tar.gz
ENV PATH="/usr/local/salmon-latest_linux_x86_64/bin:$PATH"
# Set the working directory inside the container
WORKDIR /app
RUN java -version
# Set an environment variable
ENV MY_ENV_VARIABLE=value

# When the container is started, run the bash shell by default
CMD ["/bin/bash"]

