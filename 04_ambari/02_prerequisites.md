# 02. 설치전 요구 사항



-  hostname 등록  및 pssh 설치

```
yum install  -y  libtirpc  libtirpc-devel  scp  curl  unzip  tar   wget  gcc* 

###############################
# hostname 등록
###############################
cat <<EOT >> /etc/hosts 

10.200.101.191 hdp01.goodmit.co.kr  hdp01
10.200.101.192 hdp02.goodmit.co.kr  hdp02
10.200.101.193 hdp03.goodmit.co.kr  hdp03

EOT

###############################
# pssh 설치
###############################
# 사내망에서 
#wget http://10.200.101.253/hynix/pssh/pssh-2.3.1-7.el7.nux.noarch.rpm
#yum install -y pssh*.rpm

# 인터넷환경일때
#rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y pssh

PSCP_OUT=`which pscp.pssh`
if [[ "$PSCP_OUT" = *"pscp.pssh"* ]]; then
   echo ${PSCP_OUT}
   
   echo "alias pscp=\"pscp.pssh\" " >>  ~/.bashrc
   source ~/.bashrc
   
   cat ~/.bashrc
fi

source ~/.bashrc

###############################
# ssh nopasswd 설정
###############################
echo "ssh-keygen"

yes '' | ssh-keygen -N ""

ls -al ~/.ssh

ssh-copy-id -i ~/.ssh/id_rsa.pub  hdp01
ssh-copy-id -i ~/.ssh/id_rsa.pub  hdp02
ssh-copy-id -i ~/.ssh/id_rsa.pub  hdp03

cat <<EOT >>  /root/allnodes
hdp01
hdp02
hdp03
EOT

cat <<EOT >>  /root/nodes
hdp02
hdp03
EOT

pscp -h /root/allnodes   /etc/hosts   /etc/hosts  
pssh -i -h /root/allnodes   "cat /etc/hosts"

```



- OS 설정

```
###############################
# OS 패키지 설치 
###############################
pssh -h allnodes "yum install  -y  libtirpc  libtirpc-devel  scp  curl  unzip  tar   wget  gcc* "

###############################
# timezone 변경 
###############################
pssh -h /root/allnodes "timedatectl set-timezone Asia/Seoul"
pssh -i -h /root/allnodes "date | grep KST "

###############################
# SELinux 비활성화
###############################
pssh -h /root/allnodes "sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config"
pssh -h /root/allnodes "setenforce 0"

###############################
# Linux Firewall 비활성화
###############################
pssh -h /root/allnodes "service iptables stop; chkconfig iptables off; service ip6tables stop; chkconfig ip6tables off"
pssh -h /root/allnodes "systemctl stop firewalld ; systemctl disable firewalld"

###############################
# Disable unneeded services
###############################
pssh -h /root/allnodes "service cups stop && chkconfig cups off "
pssh -h /root/allnodes "service postfix stop && chkconfig postfix off"

###############################
# ulimit 설정
###############################
pssh -h /root/allnodes "sed -i '$ a\root soft nofile 1048576' /etc/security/limits.conf"
pssh -h /root/allnodes "sed -i '$ a\root hard nofile 1048576' /etc/security/limits.conf"
pssh -h /root/allnodes "sed -i '$ a\root soft nproc  65536' /etc/security/limits.conf"
pssh -h /root/allnodes "sed -i '$ a\root hard nproc  65536' /etc/security/limits.conf"

pssh -i -h /root/allnodes "cat /etc/security/limits.conf | grep -i root "


###############################
# NTP 설정
###############################
pssh -h /root/allnodes "systemctl disable chronyd"
pssh -h /root/allnodes "systemctl stop chronyd"
pssh -h /root/allnodes "yum install -y ntp --nogpgcheck"

cp /etc/ntp.conf   /etc/ntp.conf.bak
cp /etc/ntp.conf   /root/ntp.conf
sed -i '/centos.pool.ntp.org/d' /etc/ntp.conf 
sed -i '/centos.pool.ntp.org/d' /root/ntp.conf 

cat <<EOT >> /etc/ntp.conf
server 127.127.1.0
fudge 127.127.1.0 stratum 10
EOT

cat <<EOT >> /root/ntp.conf
server 10.200.101.191
EOT

pscp -h /root/allnodes   /root/ntp.conf   /etc/ntp.conf
pssh -h /root/allnodes "systemctl start ntpd"
pssh -h /root/allnodes "systemctl enable ntpd"

#timedatectl set-time "2020-01-20 16:47:00"

pssh -i -h /root/allnodes "hwclock --systohc"  # Synchronize the system clock
pssh -i -h /root/allnodes "ntpq -pn"

###############################
# 전체 노드 재부팅 
###############################
pssh -h /root/nodes  "shutdown -r now"
sleep 1
shutdown -r now

```



