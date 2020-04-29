# KBCARD용 CDSW 도커 이미지 만들기


## 도커 이미지 구조
![](docker_arch.jpg)


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


https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/01.01.cuda9.Dockerfile
https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/01.02.cuda10.Dockerfile

https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/02.01.conda.cuda9.Dockerfile
https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/02.02.conda.cuda10.Dockerfile

https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.01.tensorflow2.0.Dockerfile
https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.02.tensorflow1.12.Dockerfile
https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.02.tensorflow1.12.NoneGpu.Dockerfile
https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.03.pytorch1.3.Dockerfile
https://github.com/braveji18/hadoop/blob/master/02_cdsw/02_kbcard/cdsw1.6/Python/03.04.tensorflow1.15.Dockerfile





