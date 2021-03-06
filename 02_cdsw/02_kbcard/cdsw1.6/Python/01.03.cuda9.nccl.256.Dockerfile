FROM  docker.repository.cloudera.com/cdsw/engine:8

#RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
#    NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
#    apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
#    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
#    echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
#    echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list

#RUN release="ubuntu"$(lsb_release -sr | sed -e "s/\.//g") && \
RUN release="ubuntu1604" && \
    echo $release &&  \
    apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/"$release"/x86_64/7fa2af80.pub && \
    echo "deb http://developer.download.nvidia.com/compute/cuda/repos/$release/x86_64 /" > /etc/apt/sources.list.d/cuda.list  && \
    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/$release/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDA_VERSION 9.0.176
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

ENV CUDA_PKG_VERSION 9-0_$CUDA_VERSION-1
RUN apt-get update &&  \
    apt-get install -y --no-install-recommends  \
            cuda-cudart-9-0 cuda-cublas-9-0  cuda-cufft-9-0 cuda-curand-9-0 cuda-cusolver-9-0 cuda-cusparse-9-0  && \
    ln -s cuda-9.0 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf && \
    ldconfig

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64


ENV CUDNN_VERSION 7.5.1.10
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda9.0 && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

#RUN cd /tmp && \
#    wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libnccl2_2.4.8-1+cuda9.0_amd64.deb && \
#    wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libnccl-dev_2.4.8-1+cuda9.0_amd64.deb && \
#    apt-get update && \
#    dpkg -i  *.deb && \
#    rm -rf /var/lib/apt/lists/* && \
#    rm -f *.deb 


RUN apt-get update && \
    cd /tmp/ && wget  https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb   && \
    dpkg -i *.deb && \
    rm -f *.deb && \
    apt-get install -y libnccl2=2.4.8-1+cuda9.0 libnccl-dev=2.4.8-1+cuda9.0  && \
    rm -rf /var/lib/apt/lists/*  



