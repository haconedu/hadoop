# CDSW용  도커 이미지 만들기

- R / R-Studio 참고 자료 
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_editors_browser.html

- DeepLearning( GPU )용 참고 자료   
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_gpu.html

- Conda / Python용 참고 자료
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_install_pkg_lib.html




## 1. R/R-Studio를 사용하는 도커 이미지 만들기 


- rstudio.<<company domain>>.Dockerfile
```
#Dockerfile Naming Rule : rstudio.<<company domain>>:/cdsw/engine:8 
#                                 회사의 도메인명                  cdsw의 engine v8에서 생성을 의미
# 예시  :  rstudio.kbcard.com:/cdsw/engine:8
#        rstudio.kt.com:/cdsw/engine:8
#        rstudio.shinhan.com:/cdsw/engine:8

FROM docker.repository.cloudera.com/cdsw/engine:8

WORKDIR /tmp

#The RUN commands that install an editor
#For example: RUN apt-get install myeditor

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
            libclang-dev \
            lsb-release \
            psmisc \
            libapparmor1 \
            sudo libssl-dev \
            libmariadb-client-lgpl-dev \
            mysql-client libmysqlclient20 \
            libxml2-dev  libnlopt-dev  \
            unixodbc-dev iodbc libiodbc2  \
            xorg libx11-dev  libglu1-mesa-dev  libfreetype6-dev   \
            libgmp-dev   libblas-dev libblas3

RUN wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.1335-amd64.deb && \
    dpkg -i rstudio-server-1.2.1335-amd64.deb

COPY rserver.conf /etc/rstudio/rserver.conf

COPY rstudio-cdsw /usr/local/bin/rstudio-cdsw

RUN chmod +x /usr/local/bin/rstudio-cdsw

## 필요한 R 패키지 설치
ENV REPO_URL  https://cran.seoul.go.kr/
RUN R -e "install.packages('패키지명01', repos='${REPO_URL}') " && \
    R -e "install.packages('패키지명02', repos='${REPO_URL}') " && \ 
    R -e "install.packages('패키지명03', repos='${REPO_URL}') " 

```



