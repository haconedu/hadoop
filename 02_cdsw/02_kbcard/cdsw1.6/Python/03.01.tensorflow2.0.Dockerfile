FROM  conda.cuda10.docker.repository.cloudera.com/cdsw/engine:8

#RUN /opt/conda/envs/python3.6/bin/pip  install --no-cache-dir --no-clean -v netifaces \
#        tensorflow-gpu==2.0  Keras 

RUN cd /tmp && git clone https://github.com/monatis/mobilenetv2-tf2.git  && \
    conda activate python3.6  && \
	cd mobilenetv2-tf2  && \
    python -m pip install -r requirements.gpu.txt  && \
	cd .. && rm -rf mobilenetv2-tf2