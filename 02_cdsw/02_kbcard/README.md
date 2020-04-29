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