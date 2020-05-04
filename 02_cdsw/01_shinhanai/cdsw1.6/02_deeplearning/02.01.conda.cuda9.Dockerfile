FROM  cuda9.docker.repository.cloudera.com/cdsw/engine:8

RUN cd /tmp/ && \
    apt-get update &&  \
    apt-get install -y --no-install-recommends  \
            libssl-dev \
            libmariadb-client-lgpl-dev \
            mysql-client libmysqlclient20 \
            libxml2-dev  libnlopt-dev  \
            unixodbc-dev iodbc libiodbc2  \
            xorg libx11-dev  libglu1-mesa-dev  libfreetype6-dev   \
            libgmp-dev   libblas-dev libblas3 \
            libstdc++6  libcupti-dev openjdk-8-jdk	&& \
    wget -O impala.deb --no-check-certificate https://downloads.cloudera.com/connectors/impala_odbc_2.5.41.1029/Debian/clouderaimpalaodbc_2.5.41.1029-2_amd64.deb && \
    wget -O hive.deb --no-check-certificate  https://downloads.cloudera.com/connectors/ClouderaHive_ODBC_2.6.4.1004/Debian/clouderahiveodbc_2.6.4.1004-2_amd64.deb && \
    dpkg -i  impala.deb hive.deb  && \
    rm -rf  *.deb && rm -rf /var/lib/apt/lists/* 
  

RUN mkdir -p /opt/conda/envs/python3.6  && \
    conda install -y nbconvert python=3.6.8 -n python3.6 && \
    conda install -y -n python3.6 numpy==1.17.5  && \
    conda install -y -n python3.6 bokeh  && \
    conda install -y -n python3.6 gensim  && \
    conda install -y -n python3.6 glob2  && \
    conda install -y -n python3.6 h5py  && \
    conda install -y -n python3.6 joblib  && \
    conda install -y -n python3.6 mpi4py  && \
    conda install -y -n python3.6 multiprocess  && \
    conda install -y -n python3.6 nltk  && \
    conda install -y -n python3.6 pandas  && \
    conda install -y -n python3.6 pymysql  && \
    conda install -y -n python3.6 pyodbc  && \
    conda install -y -n python3.6 scipy  && \
    conda install -y -n python3.6 statsmodels  && \
    conda install -y -n python3.6 statsd  && \
    conda install -y -n python3.6 tqdm  && \
    conda install -y -n python3.6 seaborn  && \
    conda install -y -n python3.6 matplotlib  && \
    conda install -y -n python3.6 scikit-learn  && \
    conda install -y -n python3.6 numba  && \
    conda install -y -n python3.6  -c anaconda py-xgboost-gpu   && \
	conda install -y -n python3.6 lightfm && \
	conda install -y -n python3.6  -c conda-forge lightgbm && \
	conda clean -a 
     
RUN /opt/conda/envs/python3.6/bin/pip install --no-cache-dir --no-clean -v netifaces \
                 gputil gym  jupyterlab konlpy JPype1-py3  mglearn boruta && \
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
 
# m4, autoconf , automake
RUN cd /tmp && wget http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz && \
    tar xvfz m4-1.4.18.tar.gz && \
	cd m4-1.4.18 && \
    ./configure --prefix=/usr && make && make install && \
	cd /tmp  && rm -rf m4-1.4.18 && \
    wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz  &&  \
    gunzip autoconf-2.69.tar.gz  &&  \
    tar xvf autoconf-2.69.tar  &&  \
    cd autoconf-2.69 && ./configure &&  make &&  make install  &&  \
	cd /tmp &&  rm -rf  autoconf-2.69  &&  \
    curl -LO http://ftpmirror.gnu.org/automake/automake-1.11.tar.gz  &&  \
    tar -zxvf automake-1.11.tar.gz  &&  \
    cd automake-1.11  &&  \
    ./configure  &&  make  &&  make install  &&  \
    cd /tmp &&  rm -rf automake-1.11  && rm -f *.tar.gz
 
# install mecab-ko, mecab-ko-dic, mecab-python
RUN cd /tmp  && \
    curl -LO https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.1.tar.gz  && \
    tar zxfv mecab-0.996-ko-0.9.1.tar.gz  && \
    cd mecab-0.996-ko-0.9.1  && \
    ./configure  && make  && make check  && make install  && ldconfig  && \
    cd /tmp &&  rm -rf mecab-0.996-ko-0.9.1 && rm -f *.tar.gz
	
RUN curl -LO https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.1-20150920.tar.gz  && \
    tar -zxvf mecab-ko-dic-2.0.1-20150920.tar.gz  && \
    cd mecab-ko-dic-2.0.1-20150920 && \
	./autogen.sh && ./configure && make  && make install  && ldconfig  && \
    sh -c 'echo "dicdir=/usr/local/lib/mecab/dic/mecab-ko-dic" > /usr/local/etc/mecabrc'  && \
    make install  && \
    cd /tmp  && rm -rf mecab-ko-dic-2.0.1-20150920 && rm -f *.tar.gz
	
RUN git clone https://bitbucket.org/eunjeon/mecab-python-0.996.git   && \
    cd mecab-python-0.996   && \
    /opt/conda/envs/python3.6/bin/python setup.py build     && \
    /opt/conda/envs/python3.6/bin/python setup.py install   && \
    cd /tmp  && rm -rf mecab-python-0.996  && rm -f *.tar.gz


ADD jvm.py  /opt/conda/envs/python3.6/lib/python3.6/site-packages/konlpy/jvm.py

# add packages
RUN conda install -y -n python3.6  -c udst pandana urbanaccess && \
    conda install -y -n python3.6 geometric  networkx  geopandas geojson shapely && \
	conda install -y -n python3.6 pysal   && \
	conda install -y -n python3.6 tslearn   && \
	conda install -y -n python3.6 folium   && \
	conda install -y -n python3.6 plotnine pil && \
    conda clean -a && \
    /opt/conda/envs/python3.6/bin/pip install --no-cache-dir --no-clean -v netifaces \
          gower PyKomoran pydotplus graphviz
