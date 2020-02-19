#!/bin/sh


CM_SERVER="10.200.101.123"

###############################
# Java 설치
###############################
pssh -h /root/allnodes "yum -y remove java"
pssh -h /root/allnodes "yum -y remove java-1.8.0-openjdk-headless"

pscp -h /root/nodes_exclude_me   /root/jdk-8u161-linux-x64.rpm   /root/

pssh -h /root/allnodes "yum install -y /root/jdk-8u161-linux-x64.rpm"

cat <<EOT >> ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.el7_7.x86_64/jre
export PATH=$JAVA_HOME/bin:$PATH
EOT


cat <<EOT >> ~/.bashrc
export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera
export PATH=$JAVA_HOME/bin:$PATH
EOT



pscp -h /root/nodes_exclude_me  /root/.bashrc /root/.bashrc
source /root/.bashrc

pssh -i -h /root/allnodes "java -version"


###############################
# MariaDB 설치
###############################

# wget https://downloads.mariadb.com/MariaDB/mariadb-5.5.63/yum/rhel/mariadb-5.5.63-rhel-6-x86_64-rpms.tar

yum install -y  mariadb-server 

service mariadb stop

cp /etc/my.cnf   /etc/my.cnf.bak
cp /root/my.cnf   /etc/my.cnf


chkconfig mariadb on

service mariadb start


###############################
# MariaDB JDBC 드라이버 설치
###############################
pssh -h /root/allnodes "mkdir -p /usr/share/java/ "
pscp -h /root/allnodes  /root/mysql-connector-java.jar  /usr/share/java/


###############################
# MariaDB root password 설정
###############################
/usr/bin/mysql_secure_installation

#Enter current password for root (enter for none):
#OK, successfully used password, moving on...
#[...]
#Set root password? [Y/n] y
#New password:
#Re-enter new password:
#Remove anonymous users? [Y/n] Y
#[...]
#Disallow root login remotely? [Y/n] N
#[...]
#Remove test database and access to it [Y/n] Y
#[...]
#Reload privilege tables now? [Y/n] Y
#All done!



###############################
# Database 만들기
###############################
MY_PW=shinhanai12!

ln -s  /mariadb/lib/mysql/mysql.sock  /var/lib/mysql/mysql.sock

mysql -u root -p${MY_PW}   <  /root/create_db.sql 
mysql -u root -p${MY_PW}  -e "show databases"


CREATE USER 'root'@'%' IDENTIFIED BY 'Kobic0110!';
GRANT REPLICATION SLAVE ON *.* TO 'root'@'%' IDENTIFIED BY 'Kobic0110!';
SHOW MASTER STATUS;

MariaDB [(none)]> SHOW MASTER STATUS
    -> ;
+-------------------------+----------+--------------+------------------+
| File                    | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+-------------------------+----------+--------------+------------------+
| mysql_binary_log.000004 | 46624145 |              |                  |
+-------------------------+----------+--------------+------------------+


CHANGE MASTER TO MASTER_HOST='100.3.1.53', MASTER_USER='root', MASTER_PASSWORD='Kobic0110!', 
                 MASTER_PORT=3306, MASTER_LOG_FILE='mysql_binary_log.000004', 
                 MASTER_LOG_POS=46624145, MASTER_CONNECT_RETRY=10;


###############################
# Cloudera Manager Agent 패키지 설치
###############################
pssh -t 0 -h /root/allnodes "yum -y install cloudera-manager-daemons  cloudera-manager-agent "

pssh -i -h /root/allnodes "rpm -qa | grep cloudera"


sed -i "s/server_host=localhost/server_host=${CM_SERVER}/g" /etc/cloudera-scm-agent/config.ini
cat /etc/cloudera-scm-agent/config.ini | grep server_host
pscp -h /root/allnodes  /etc/cloudera-scm-agent/config.ini   /etc/cloudera-scm-agent/


###############################
#Cloudera Manager Server 패키지 설치
###############################
yum install -y cloudera-manager-server

# cm5
/usr/share/cmf/schema/scm_prepare_database.sh mysql scm scm scm
# cm6
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm


###############################
# Cloudera Manager Server 시작!
###############################
pssh -h /root/allnodes "service cloudera-scm-agent start"

service cloudera-scm-server start
sleep 2
tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log


#schematool -dbType mysql -initSchema -passWord hive -userName Hive0110!
  
  
  
  
