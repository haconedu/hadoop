# KBCARD용 CDSW 도커 이미지 만들기


## 도커 이미지 구조
![](docker_arch.jpg)


## 참조 자료
- R / R-Studio 참고 자료 
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_editors_browser.html

- DeepLearning( GPU )용 참고 자료   
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_gpu.html

- Conda / Python용 참고 자료
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_install_pkg_lib.html

## R용 도커 이미지 

- R-Studio 기능 추가  
  - [01.rstudio.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/R/01.rstudio.Dockerfile) 

- R패키지 추가( 290개 정도 ) 
  - [02.R_LIB.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/R/02.R_LIB.Dockerfile)


- 빌드 방법
  - sh  01_make.sh  kbcard.com  :  01.rstudio.Dockerfile 빌드 
  - sh  02_make.sh  kbcard.com  :  02.R_LIB.Dockerfile 빌드
  - sh  save_docker.sh  kbcard.com : 생성된 도커이미지를 파일로 추출 
  - sh  all_kbcard.sh : 위의 3가지 단계를 한번에 처리
  
- 생성된 최종 이미지명 
  - rstudio.kbcard.com/cdsw/engine:8
  
## Python/Deeplearning용 도커 이미지 

- CUDA 설정
  - [01.01.cuda9.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/01.01.cuda9.Dockerfile)
  - [01.02.cuda10.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/01.02.cuda10.Dockerfile)

- conda/파이션 패치지 설정 
  - [02.01.conda.cuda9.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/02.01.conda.cuda9.Dockerfile)
  - [02.02.conda.cuda10.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/02.02.conda.cuda10.Dockerfile)

- Deeplearning용 패키지 설정
  - [03.01.tensorflow2.0.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.01.tensorflow2.0.Dockerfile)
  - [03.02.tensorflow1.12.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.02.tensorflow1.12.Dockerfile)
  - [03.02.tensorflow1.12.NoneGpu.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.02.tensorflow1.12.NoneGpu.Dockerfile)
  - [03.03.pytorch1.3.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.03.pytorch1.3.Dockerfile)
  - [03.04.tensorflow1.15.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.04.tensorflow1.15.Dockerfile)
  - [03.05.mobilenet.Dockerfile](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.05.mobilenet.Dockerfile)



- 빌드 방법 
  - sh 01_make.sh kbcard.com :  
  - sh 02_make.sh kbcard.com : 
  - sh 03_01_make.sh kbcard.com : Tensorflow 2.x  빌드 
  - sh 03_02_make.sh kbcard.com : Tensorflow 1.12  빌드   
  - sh 03_03_make.sh kbcard.com : pytorch 1.3  빌드 
  - sh 03_04_make.sh kbcard.com : Tensorflow 1.15  빌드 
  - sh 03_05_make.sh kbcard.com : Tensorflow 2.0 + [mobilenet V2](https://github.com/monatis/mobilenetv2-tf2.gi)  빌드 
  - sh save_docker.sh kbcard.com :  파일로 추출
  - sh [check_pkg.sh](https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/check_pkg.sh) kbcard.com  : 설치한 패키지를 import 가 되는지 확인   
  - sh  all_kbcard.sh : 위의 단계를 한번에 처리
  

##  도커 이미지 관리 도구 : Portainer 
- https://www.portainer.io/

- 설치 및 실행 
```
# 설치 
docker volume create portainer_data

# 실행
docker run -d -p 9002:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --restart=always portainer/portainer

# 파일로 추출 
docker save  portainer/portainer:latest  | gzip > portainer.portainer.tar.gz 

```

- WebUI 접속
  - http://cdsw.kbcard.com:9002
  
  
  
  ## XAI 모듈 추가
  
  ```
  # XAI
      /opt/conda/envs/python3.6/bin/pip install --no-cache-dir --no-clean  \
            pdpbox lime ipywidgets shap 
  ```
  
  
  
  
  
  
  
  
  
  
