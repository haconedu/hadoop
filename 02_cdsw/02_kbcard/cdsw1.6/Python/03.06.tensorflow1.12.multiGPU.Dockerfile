FROM cuda9.nccl.docker.repository.cloudera.com/cdsw/engine:8

# 기본 OS 설정 ODBC, language-pack-ko
RUN cd /tmp/ && \
    apt-get update &&  \
    apt-get install -y --no-install-recommends  \
            language-pack-ko  \
            libssl-dev \
            libmariadb-client-lgpl-dev \
            mysql-client libmysqlclient20 \
            libxml2-dev  libnlopt-dev  \
            unixodbc-dev iodbc libiodbc2  \
            xorg libx11-dev  libglu1-mesa-dev  libfreetype6-dev   \
            libgmp-dev   libblas-dev libblas3 \
            libstdc++6  libcupti-dev openjdk-8-jdk	graphviz  && \
    rm -rf  *.deb && rm -rf /var/lib/apt/lists/*  && \
    mv /etc/default/locale /etc/default/locale.bak  && \
    echo "LANG=\"ko_KR.UTF-8\"" >> /etc/default/locale && \
    echo "LANGUAGE=\"ko_KR:ko\"" >> /etc/default/locale 
  
# 분석패키지 추가
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
	conda install -y -n python3.6 lightfm && \
	conda install -y -n python3.6  -c conda-forge lightgbm  && \
	conda clean -a  

#쥬피터랩 jupyterlab konlpy
RUN /opt/conda/envs/python3.6/bin/pip install --no-cache-dir --no-clean -v netifaces \
                 gputil gym  jupyterlab konlpy JPype1-py3  mglearn boruta && \
    pip3 install --no-cache-dir --no-clean -v netifaces \
	     jupyterlab	

ADD jvm.py  /opt/conda/envs/python3.6/lib/python3.6/site-packages/konlpy/jvm.py

RUN apt-get update &&  \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y gcc-4.9 && \
    apt-get upgrade -y libstdc++6 

RUN /opt/conda/envs/python3.6/bin/pip  install --no-cache-dir --no-clean -v netifaces \
        tensorflow-gpu==1.12.0   Keras==2.1.5   Keras-Applications  keras_preprocessing


