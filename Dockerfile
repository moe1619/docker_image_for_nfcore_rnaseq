# Use the latest version of the official Ubuntu image as the base image
# FROM ubuntu:latest
# # FROM python:3.11.5-slim
# # RUN apt-get update && apt-get install -y \
# # software-properties-common
# RUN apt update && apt install -y software-properties-common

# RUN add-apt-repository -y ppa:apptainer/ppa
# RUN apt update && apt install -y python-is-python3 default-jdk apptainer

# Use the latest version of the official Ubuntu image as the base image
FROM ubuntu:latest

# Set maintainer label
LABEL maintainer="jm4279@cumc.columbia.edu"

# Install Java
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk \
    curl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y software-properties-common && add-apt-repository -y ppa:apptainer/ppa && apt update && apt install -y python-is-python3 apptainer

# Set the JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Optionally, you can set the default command for the container
CMD ["bash"]



# FROM rust:1.72.0
# # WORKDIR /usr/src/myapp
# WORKDIR /usr/local/
# RUN pwd
# RUN git clone --depth 1 --branch v0.11.0 https://github.com/stjude-rust-labs/fq.git
# WORKDIR /usr/local/fq
# RUN pwd
# RUN cargo install --locked --path .
# # ENV PATH="/user/local/fq:$PATH"
# # COPY . .
# # RUN cargo install --path .

# FROM python:3.11.5-slim
# FROM rust:1.72.0-bullseye
# RUN mkdir -p /user/local/fq
# RUN mkdir -p /opt/bin/fq
# COPY --from=0 /usr/local/fq /opt/bin/fq

# RUN cargo --help
# ENV PATH="/usr/local/fq:$PATH"
# ENV PATH="/opt/bin/fq/bin:$PATH"
# RUN /user/local/fq/fq
#

# Set the maintainer label
# LABEL maintainer="jm4279@cumc.columbia.edu"
# # for easy upgrade later. ARG variables only persist during image build
# ARG SAMTOOLSVER=1.18
# ARG R_VERSION=4.0.4
# ARG SALMON_VERSION=1.10.0
# ENV DEBIAN_FRONTEND=noninteractive 

# # RUN apt update && apt install -y --no-install-recommends python-is-python3 r-base-core=${R_VERSION} r-base-dev=${R_VERSION}
# RUN apt update && apt install -y python-is-python3 #--no-install-recommends 
# # RUN apt update && apt install -y --no-install-recommends python-is-python3 r-base r-base-dev
# # RUN java -version
# # Update the package list and install curl and git
# RUN apt-get update && apt-get install -y \
#   apt-transport-https \
#   autoconf \
#   bedtools \
#   build-essential \
#   bzip2 \
#   ca-certificates \
#   curl \
#   g++ \
#   gawk \
#   gcc \
#   git \
#   gnupg \
#   gnuplot \
#   make \
#   nq \
#   perl \ 
#   software-properties-common \
#   unzip \
#   wget && rm -rf /var/lib/apt/lists/*

#   # libboost-all-dev \
#   # libncurses5-dev \
#   # libbz2-dev \
#   # liblzma-dev \
#   # libcurl4 \
#   # libxml2-dev \
#   # libssl-dev \
#   # littler \
# # \
# #   zlib1g-dev  
#   # openjdk-17-jdk \ 
#   # openjdk-17-jre \ 

# RUN add-apt-repository -y ppa:apptainer/ppa
# RUN apt update && apt install -y default-jdk apptainer
# #   # clean \

# # libcurl4-gnutls-dev \
# # libcurl4-openssl-dev \

# RUN wget https://bootstrap.pypa.io/get-pip.py
# RUN python get-pip.py

# # install conda
# # Install miniconda
# ENV CONDA_DIR /opt/conda
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
#     /bin/bash ~/miniconda.sh -b -p /opt/conda

# # Put conda in path so we can use conda activate
# ENV PATH=$CONDA_DIR/bin:$PATH

# # install bioconda
# RUN conda config --add channels defaults
# RUN conda config --add channels bioconda
# RUN conda config --add channels conda-forge
# RUN conda config --set channel_priority strict

# # install fq
# RUN conda install fq=0.11.0

# # Update pip to latest version
# RUN python -m pip install --upgrade pip

# # Install dependencies
# COPY requirements.txt requirements.txt
#  RUN python -m pip install -r requirements.txt

# #install samtools
# RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLSVER}/samtools-${SAMTOOLSVER}.tar.bz2 && \
#  tar -xjf samtools-${SAMTOOLSVER}.tar.bz2 && \
#  rm samtools-${SAMTOOLSVER}.tar.bz2 && \
#  cd samtools-${SAMTOOLSVER} && \
#  ./configure && \
#  make && \
#  make install

# # Install nf-core
# #COPY setup.py setup.py
# #COPY pyproject.toml pyproject.toml
# # RUN python -m pip install .

# # install STAR
# RUN git clone https://github.com/alexdobin/STAR.git
# RUN cd STAR/source
# RUN make STAR

# #install rsem
# WORKDIR /usr/local/
# RUN pwd
# RUN git clone https://github.com/deweylab/RSEM.git
# WORKDIR /usr/local/RSEM
# RUN pwd
# RUN git checkout v1.3.3
# RUN make 
# RUN make install
# ENV PATH /usr/local/RSEM:$PATH

# #install umi-tools
# RUN pip install umi_tools

# # INSTALL QUALIMAP
# RUN ln -s /usr/lib/x86_64-linux-gnu/libncursesw.so.6 /usr/lib/x86_64-linux-gnu/libncursesw.so.5

# #Install R 3.6
# # RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 51716619E084DAB9 && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran35/" && apt update && apt install -y r-base

# #Install Bioconductor packages required by Qualimap
# RUN Rscript -e "install.packages('optparse')"
# RUN Rscript -e "install.packages('BiocManager', repos = 'http://cran.us.r-project.org')"
# RUN Rscript -e "BiocManager::install(c('NOISeq', 'Repitools','Rsamtools', 'GenomicFeatures', 'rtracklayer','DESeq2'))"

# #Install Qualimap
# RUN cd /opt && wget https://bitbucket.org/kokonech/qualimap/downloads/qualimap_v2.3.zip && unzip qualimap_v2.3.zip && rm qualimap_v2.3.zip
# # RUN Rscript /opt/qualimap_v2.3/scripts/installDependencies.r

# ENV PATH="/opt/qualimap_v2.3:$PATH"

# # install salmon
# WORKDIR /usr/local/
# RUN wget https://github.com/COMBINE-lab/salmon/releases/download/v${SALMON_VERSION}/salmon-${SALMON_VERSION}_linux_x86_64.tar.gz && tar xzf salmon-${SALMON_VERSION}_linux_x86_64.tar.gz
# ENV PATH="/usr/local/salmon-latest_linux_x86_64/bin:$PATH"
# # Set the working directory inside the container
# WORKDIR /app

# #install string tie
# ARG STRINGTIE_VERSION=2.2.1
# WORKDIR /usr/local/
# RUN cd /usr/local/
# # RUN wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-${STRINGTIE_VERSION}.tar.gz
# # RUN tar xvfz ./stringtie-${STRINGTIE_VERSION}.tar.gz
# # RUN cd stringtie-${STRINGTIE_VERSION}
# # RUN make release
# # RUN conda install -c bioconda stringtie
# # RUN git clone https://github.com/gpertea/stringtie
# # RUN cd stringtie
# # RUN make release
# RUN wget https://github.com/gpertea/stringtie/releases/download/v${STRINGTIE_VERSION}/stringtie-${STRINGTIE_VERSION}.Linux_x86_64.tar.gz
# RUN tar xvfz stringtie-${STRINGTIE_VERSION}.Linux_x86_64.tar.gz
# ENV PATH="/usr/local/stringtie-${STRINGTIE_VERSION}.Linux_x86_64:$PATH"

# #INSTALL multiqc
# WORKDIR /usr/local/
# ARG MULTIQC_VERSION=1.16
# RUN pip install multiqc

# #INSTALL RSeQC
# WORKDIR /usr/local/
# ARG RSEQC_VERSION=5.0.1
# RUN pip install RSeQC

# #INSTALL dupRadar (should move up to other R when optimizing)
# WORKDIR /usr/local/
# ARG DUPRADAR=1.30.0
# RUN Rscript -e "BiocManager::install(c('dupRadar'))"

# #INSTALL picard
# RUN conda config --add channels defaults
# RUN conda config --add channels bioconda
# RUN conda config --add channels conda-forge
# RUN conda config --set channel_priority strict
# WORKDIR /usr/local/
# ARG PICARD_VERSION=3.0.0
# # RUN mamba install -y picard=${PICARD_VERSION}
# RUN conda install -y picard=${PICARD_VERSION}
# # RUN conda install -c "bioconda/label/cf201901" picard


# #update conda
# # RUN conda update -n base -c defaults conda
# # RUN conda update -y conda

# #install bedgraphtobigwig
# RUN conda config --add channels defaults
# RUN conda config --add channels bioconda
# RUN conda config --add channels conda-forge
# RUN conda config --set channel_priority strict
# ARG BEDGRAPHTOBIGWIG_VERSION=377
# WORKDIR /usr/local/
# # RUN conda install -c "bioconda/label/cf201901" ucsc-bedgraphtobigwig
# # RUN conda install -y -c bioconda ucsc-bedgraphtobigwig=${BEDGRAPHTOBIGWIG_VERSION}
# RUN conda install -y ucsc-bedgraphtobigwig=${BEDGRAPHTOBIGWIG_VERSION}

# Set an environment variable
# ENV MY_ENV_VARIABLE=value

# # When the container is started, run the bash shell by default
# CMD ["/bin/bash"]

