# 01. 설치 파일 다운로드 및 로컬 레포지토리 생성 



- ambari.repo 생성

```
cat <<EOT >> /etc/yum.repos.d/ambari.repo
#VERSION_NUMBER=2.7.3.0-139
[ambari-2.7.3.0]
#json.url = http://public-repo-1.hortonworks.com/HDP/hdp_urlinfo.json
name=ambari Version - ambari-2.7.3.0
baseurl=http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.7.3.0
gpgcheck=1
gpgkey=http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.7.3.0/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1

EOT
```

- hdp_3.1.0.0.repo 생성 

```
cat <<EOT >> /etc/yum.repos.d/hdp_3.1.0.0.repo
#VERSION_NUMBER=3.1.0.0-78
[HDP-3.1.0.0]
name=HDP Version - HDP-3.1.0.0
baseurl=http://public-repo-1.hortonworks.com/HDP/centos7/3.x/updates/3.1.0.0
gpgcheck=1
gpgkey=http://public-repo-1.hortonworks.com/HDP/centos7/3.x/updates/3.1.0.0/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1


[HDP-UTILS-1.1.0.22]
name=HDP-UTILS Version - HDP-UTILS-1.1.0.22
baseurl=http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.22/repos/centos7
gpgcheck=1
gpgkey=http://public-repo-1.hortonworks.com/HDP/centos7/3.x/updates/3.1.0.0/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1

EOT

```

- hdf.repo 생성 

```
cat <<EOT >> /etc/yum.repos.d/hdf.repo
#VERSION_NUMBER=3.4.1.1-4
[HDF-3.4.1.1]
name=HDF Version - HDF-3.4.1.1
baseurl=http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.4.1.1
gpgcheck=1
gpgkey=http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.4.1.1/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1


[HDP-UTILS-1.1.0.22]
name=HDP-UTILS Version - HDP-UTILS-1.1.0.22
baseurl=http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.22/repos/centos7
gpgcheck=1
gpgkey=http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.4.1.1/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1

EOT


```



- MariaDB.repo 생성

```
cat <<EOT >> /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB-10.3.14
#baseurl=http://yum.mariadb.org/10.3.14/centos7-amd64
baseurl=http://archive.mariadb.org/mariadb-10.3.14/yum/centos7-amd64
gpgcheck=0

EOT
```



- 각각의 레포지토리 확인

```
yum repolist all
```



- rpm 파일 다운로드 및 로컬 레포지토리 생성

```
mkdir -p  /etc/yum.repos.d/bak

mv /etc/yum.repos.d/CentOS*  /etc/yum.repos.d/bak
yum repolist all

mkdir -p  /var/www/html
reposync --download_path=/var/www/html 

wget -P /var/www/html/HDF-3.4.1.1/  http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.4.1.1/tars/hdf_ambari_mp/hdf-ambari-mpack-3.4.1.1-4.tar.gz 


# /var/www/html 다운받은 파일들을 로컬레포지토리를 생성할 서버로 카피

createrepo /var/www/html/ambari-2.7.3.0/
createrepo /var/www/html/HDP-3.1.0.0/
createrepo /var/www/html/HDF-3.4.1.1/
createrepo /var/www/html/HDP-UTILS-1.1.0.22/
createrepo /var/www/html/mariadb
```



- 로컬 레포지토리 생성

```
# 로컬 레포지토리서버의 IP가 10.200.101.253 일때

cat <<EOT >> /etc/yum.repos.d/ambari.repo
[ambari-2.7.3.0]
name=ambari Version - ambari-2.7.3.0
baseurl=http://10.200.101.253/ambari-2.7.3.0
gpgcheck=0
enabled=1

EOT

cat <<EOT >> /etc/yum.repos.d/hdp_3.1.0.0.repo
[HDP-3.1.0.0]
name=HDP Version - HDP-3.1.0.0
baseurl=http://10.200.101.253/HDP-3.1.0.0
gpgcheck=0
enabled=1


[HDP-UTILS-1.1.0.22]
name=HDP-UTILS Version - HDP-UTILS-1.1.0.22
baseurl=http://10.200.101.253/HDP-UTILS-1.1.0.22/
gpgcheck=0
enabled=1

EOT


cat <<EOT >> /etc/yum.repos.d/hdf.repo
[HDF-3.4.1.1]
name=HDF Version - HDF-3.4.1.1
baseurl=http://10.200.101.253/HDF-3.4.1.1
gpgcheck=0
enabled=1

EOT

cat <<EOT >> /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB-10.3.14
baseurl=http://10.200.101.253/mariadb
gpgcheck=0
enabled=1

EOT

# 확인
yum repolist all
```











