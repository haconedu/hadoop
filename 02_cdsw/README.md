# CDSW용  도커 이미지 만들기

- R / R-Studio 참고 자료 
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_editors_browser.html

- DeepLearning( GPU )용 참고 자료   
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_gpu.html

- Conda / Python용 참고 자료
   - https://docs.cloudera.com/documentation/data-science-workbench/1-6-x/topics/cdsw_install_pkg_lib.html




## 1. R/R-Studio를 사용하는 도커 이미지 만들기 


- rstudio.{company domain}.Dockerfile
```
#Dockerfile Naming Rule : rstudio.{company domain}.Dockerfile
#                                    회사의 도메인명                
# 예시  :  rstudio.kbcard.com.Dockerfile
#       rstudio.kt.com.Dockerfile

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
#   .... 

```


- rserver.conf
```
# Must match CDSW_APP_PORT
www-port=8090
server-app-armor-enabled=0
server-daemonize=0
www-address=127.0.0.1
auth-none=1
auth-validate-users=0
```

- rstudio-cdsw
```
#!/bin/bash

# This saves RStudio's user runtime information to /tmp, which ensures several
# RStudio sessions can run in the same project simultaneously
mkdir -p /tmp/rstudio/sessions/active
mkdir -p /home/cdsw/.rstudio/sessions
if [ -d /home/cdsw/.rstudio/sessions/active ]; then rm -rf /home/cdsw/.rstudio/sessions/active; fi
ln -s /tmp/rstudio/sessions/active /home/cdsw/.rstudio/sessions/active

# This ensures RStudio picks up the environment. This may not be necessary if
# you are installing RStudio Professional. See
# https://docs.rstudio.com/ide/server-pro/r-sessions.html#customizing-session-launches.
# SPARK_DIST_CLASSPATH is treated as a special case to workaround a bug in R
# with very long environment variables.
env | grep -v ^SPARK_DIST_CLASSPATH >> /usr/local/lib/R/etc/Renviron.site
echo "Sys.setenv(\"SPARK_DIST_CLASSPATH\"=\"${SPARK_DIST_CLASSPATH}\")" >> /usr/local/lib/R/etc/Rprofile.site

# Now start RStudio
/usr/sbin/rstudio-server start
```

- Dockerfile 빌드 방법
```
MY_COMPANY=goodmit.com

# Docker images Naming Rule   : rstudio.{company domain}:/cdsw/engine:8 
#                                 회사의 도메인명                cdsw의 engine v8에서 생성을 의미
# 예시  :  rstudio.kbcard.com:/cdsw/engine:8
#        rstudio.kt.com:/cdsw/engine:8
#        rstudio.shinhan.com:/cdsw/engine:8

docker build --network=host  -t rstudio.${MY_COMPANY}:/cdsw/engine:8 . -f rstudio.${MY_COMPANY}.Dockerfile

```

- Docker image를 파일로 추출
```
MY_COMPANY=goodmit.com
TODAY=`date "+%y%m%d"`

docker save  rstudio.${MY_COMPANY}/cdsw/engine:8  | gzip > rstudio.${MY_COMPANY}_${TODAY}.tar.gz 
```

- rstudio.${MY_COMPANY}_${TODAY}.tar.gz  파일을 전달

 
















