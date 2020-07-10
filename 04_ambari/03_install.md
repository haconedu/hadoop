# 03. Ambari,  HDP, HDF 설치



- open java 설치

```pssh -h /root/allnodes "yum install -y java-1.8.0-openjdk"
pssh -h /root/allnodes "yum install -y java-1.8.0-openjdk"


cat <<EOT >> ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export PATH=\$JAVA_HOME/bin:\$PATH
EOT

pscp -h /root/nodes  /root/.bashrc /root/.bashrc
source /root/.bashrc

pssh -i -h /root/allnodes "java -version"
```



- Mariadb설치 

````
yum install -y  MariaDB-server-10.3.14

service mariadb stop

mv /var/lib/mysql/ib_logfile0 /var/lib/mysql/ib_logfile0_backup
mv /var/lib/mysql/ib_logfile1 /var/lib/mysql/ib_logfile1_backup

systemctl enable mariadb
systemctl start mariadb


/usr/bin/mysql_secure_installation  

pssh -h /root/allnodes "mkdir -p /usr/share/java/"
# wget http://10.200.101.253/hynix/mysql-connector-java-5.1.48/mysql-connector-java-5.1.48-bin.jar  -P /root/ -O mysql-connector-java.jar
pscp -h /root/allnodes  /root/mysql-connector-java.jar  /usr/share/java/

###############################
# DB 생성 
###############################
cat <<EOT >> /root/create_db_ambari.sql
DROP DATABASE IF EXISTS ambari ;
DROP DATABASE IF EXISTS hive ;
DROP DATABASE IF EXISTS oozie ;
DROP DATABASE IF EXISTS ranger ;
DROP DATABASE IF EXISTS rangerkms ;
DROP DATABASE IF EXISTS registry ;
DROP DATABASE IF EXISTS streamline ;
DROP DATABASE IF EXISTS druid ;
DROP DATABASE IF EXISTS superset ;

-- ambari DB
CREATE USER 'ambari'@'localhost' IDENTIFIED BY 'ambari';
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'localhost';
CREATE USER 'ambari'@'%' IDENTIFIED BY 'ambari';
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'%';
CREATE USER 'ambari'@'AMBARI_HOST' IDENTIFIED BY 'ambari';
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'AMBARI_HOST';

CREATE DATABASE ambari;

-- 하이브 
CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'localhost';
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'%';
CREATE USER 'hive'@'AMBARI_HOST' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'AMBARI_HOST';

CREATE DATABASE hive;

-- 우지 
CREATE USER 'oozie'@'%' IDENTIFIED BY 'oozie';
GRANT ALL PRIVILEGES ON *.* TO 'oozie'@'%';

CREATE DATABASE oozie;	

-- ranger
CREATE DATABASE ranger;
CREATE USER 'rangeradmin'@'%' IDENTIFIED BY 'rangeradmin';
CREATE USER 'rangeradmin'@'localhost' IDENTIFIED BY 'rangeradmin';
CREATE USER 'rangeradmin'@'RANGER_ADMIN_HOST' IDENTIFIED BY 'rangeradmin';
GRANT ALL PRIVILEGES ON ranger.* TO 'rangeradmin'@'%';
GRANT ALL PRIVILEGES ON ranger.* TO 'rangeradmin'@'localhost';
GRANT ALL PRIVILEGES ON ranger.* TO 'rangeradmin'@'RANGER_ADMIN_HOST';

-- rangerkms
CREATE USER 'rangerkms'@'%' IDENTIFIED BY 'rangerkms';
CREATE USER 'rangerkms'@'localhost' IDENTIFIED BY 'rangerkms';
CREATE USER 'rangerkms'@'RANGER_ADMIN_HOST' IDENTIFIED BY 'rangerkms';
GRANT ALL PRIVILEGES ON ranger.* TO 'rangerkms'@'%';
GRANT ALL PRIVILEGES ON ranger.* TO 'rangerkms'@'localhost';
GRANT ALL PRIVILEGES ON ranger.* TO 'rangerkms'@'RANGER_ADMIN_HOST';
CREATE DATABASE rangerkms;

-- hdf
create database registry;
create database streamline;

CREATE USER 'registry'@'%' IDENTIFIED BY 'registry';
CREATE USER 'streamline'@'%' IDENTIFIED BY 'streamline';

GRANT ALL PRIVILEGES ON registry.* TO 'registry'@'%' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON streamline.* TO 'streamline'@'%' WITH GRANT OPTION ;

-- druid
CREATE DATABASE druid DEFAULT CHARACTER SET utf8;
CREATE DATABASE superset DEFAULT CHARACTER SET utf8;

CREATE USER 'druid'@'%' IDENTIFIED BY 'druid';
CREATE USER 'superset'@'%' IDENTIFIED BY 'superset';
GRANT ALL PRIVILEGES ON *.* TO 'druid'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'superset'@'%' WITH GRANT OPTION;

flush privileges;

EOT


AMBARI_HOST=`hostname`
RANGER_ADMIN_HOST=`hostname`

sed -i "s/AMBARI_HOST/${AMBARI_HOST}/g"             /root/create_db_ambari.sql
sed -i "s/RANGER_ADMIN_HOST/${RANGER_ADMIN_HOST}/g" /root/create_db_ambari.sql

MY_PW=cloudera!
mysql -u root -p${MY_PW}   <  /root/create_db_ambari.sql
mysql -u root -p${MY_PW}  -e "show databases"
mysql -u root -p${MY_PW}  -e "SHOW GRANTS FOR 'ambari'@'%';"
````



- Ambari 설치 

```
yum install -y ambari-server

ambari-server setup

# 1. 일시적으로 selinux를 해지하지 않은겨우 경고가 나타남	> y (기본값)
# 2. Customize user account for ambari-server daemon   > n(기본값 - root / 선택) 
#                                                      > 다른 사용자로 진행하려면 y > 사용자 작성
# 3. iptable을 비활성화 하지 않은 경우 경고	> y(기본값 / 선택) 
# 4. 다운로드 할 jdk 버전 선택	> 1 (Oracle JDK 1.8)	> 라이센스 승인
#                             > 2 (사용자 정의 jdk 설치)	> 수동으로 경로 지정( /usr/lib/jvm/jre-1.8.0-openjdk )
# 5. LZO 압축 라이브러리를 다운로드하고 설치합니다 	> n
# 6. Enter advanced database configuration	> n (암바리 내장 postgreSQL 사용)
#                                           > y ( 이후 mariadb 선택 )
# 7. Proceed with configuring remote database connection properties	> y 


mysql -uambari -pambari -Dambari  <  /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql

ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar

# HDF설치시
wget -P /tmp/  http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.4.1.1/tars/hdf_ambari_mp/hdf-ambari-mpack-3.4.1.1-4.tar.gz 
ambari-server install-mpack \
  --mpack=/tmp/hdf-ambari-mpack-3.4.1.1-4.tar.gz \
  --verbose

ambari-server start
ambari-server status

# ssh 키 확인
cat /root/.ssh/id_rsa

# 접속 확인
# http://<your.ambari.server>:8080

#클러스터 인스톨과정은 아래 링크 참조
https://docs.cloudera.com/HDPDocuments/Ambari-2.7.3.0/bk_ambari-installation/content/launching_the_ambari_install_wizard.html
```

