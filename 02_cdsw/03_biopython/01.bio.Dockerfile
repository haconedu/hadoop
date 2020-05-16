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
            graphviz libgraphviz-dev pkg-config  \
            swig  libx11-dev libgsl0-dev libopenblas-dev liblapacke-dev && \
    rm -rf  *.deb && rm -rf /var/lib/apt/lists/* 


RUN R -e "source('http://bioconductor.org/biocLite.R') ; biocLite()   " && \
    R -e "install.packages('ggplot2')"  && \
    R -e "install.packages('gridExtra')" 

RUN mkdir -p /opt/conda/envs/python3.6  && \
    conda install -y  -n python3.6  biopython=1.70   python=3.6.8 && \
    conda install -y - n python3.6 statsmodels pysam plink gffutils genepop trimal  && \
    conda install -y - n python3.6 simuPOP rpy2 r-ggplot2 r-gridextra && \
    conda install -y - n python3.6 pygraphviz eigensoft && \
    conda install -y - n python3.6 seaborn pexpect pyvcf dendropy networkx reportlabi && \
    conda install -y - n python3.6 tzlocal  && \
    conda clean -a 
     
RUN /opt/conda/envs/python3.6/bin/pip install --no-cache-dir --no-clean -v netifaces \
                 jupyterlab pygenomics   && \
    pip3 install --no-cache-dir --no-clean -v netifaces \
	     jupyterlab	

RUN git clone https://github.com/PacktPublishing/Bioinformatics-with-Python-Cookbook-Second-Edition.git
