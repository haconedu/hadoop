FROM  cuda10.docker.repository.cloudera.com/cdsw/engine:10

RUN /opt/conda/envs/python3.6/bin/pip  install --no-cache-dir --no-clean -v netifaces \
        tensorflow-gpu==2.3  Keras

	
