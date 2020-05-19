FROM  docker.repository.cloudera.com/cdsw/engine:8

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends  \
            libssl-dev \
            libmariadb-client-lgpl-dev \
            mysql-client libmysqlclient20 \
            libxml2-dev  libnlopt-dev  \
            unixodbc-dev iodbc libiodbc2  \
            xorg libx11-dev  libglu1-mesa-dev  libfreetype6-dev   \
            libgmp-dev   libblas-dev libblas3 \
            libstdc++6  libcupti-dev openjdk-8-jdk	\
            git wget build-essential unzip  \
            graphviz libgraphviz-dev pkg-config  libc6-dev  \
            swig  libx11-dev libgsl0-dev libopenblas-dev liblapacke-dev && \
    rm -rf  *.deb && rm -rf /var/lib/apt/lists/* 

RUN mkdir -p /opt/conda/envs/python3.6  && \
    conda install -y  -n python3.6  biopython=1.70   python=3.6.8  && \
    conda install -y -n python3.6 statsmodels  && \
    conda install -y -n python3.6 -c bioconda    \
                      pysam   \
                      plink    \
                      gffutils   \
                      genepop   \
                      trimal    \
                      eigensoft   \
                      dendropy   && \
    conda install -y -n python3.6    \
                      simuPOP rpy2 r-base=3.5 r-ggplot2 r-gridextra \
                      pygraphviz simplegeneric \
                      seaborn pexpect pyvcf networkx reportlab  \
                      tzlocal  && \
    conda clean -a  

# /opt/conda/envs/python3.6/bin/R
RUN conda install -y -n python3.6  libiconv  && \
    R -e "source('http://bioconductor.org/biocLite.R') ; biocLite()   " && \
    R -e "install.packages('ggplot2')"  && \
    R -e "install.packages('gridExtra')" 
     
RUN /opt/conda/envs/python3.6/bin/pip install --no-cache-dir --no-clean -v netifaces \
                 jupyterlab pygenomics   && \
    /opt/conda/envs/python3.6/bin/pip uninstall -y enum34 && \
    pip3 install --no-cache-dir --no-clean -v netifaces \
	     jupyterlab	

RUN cd /tmp/ && \
    wget --no-check-certificate  https://jaist.dl.sourceforge.net/project/libpng/zlib/1.2.9/zlib-1.2.9.tar.gz  && \
    tar -xvf zlib-1.2.9.tar.gz && \
    cd zlib-1.2.9   && \
    ./configure &&  make && make install && \
    cd /usr/lib/x86_64-linux-gnu/  && \
    ln -s -f /usr/local/lib/libz.so.1.2.9/lib libz.so.1 && \
    cd /tmp/ && rm -rf zlib-1.2.9

ENV LD_LIBRARY_PATH /usr/local/lib/R/lib/:${LD_LIBRARY_PATH}

#RUN git clone https://github.com/PacktPublishing/Bioinformatics-with-Python-Cookbook-Second-Edition.git
