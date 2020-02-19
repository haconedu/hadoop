#!/bin/sh


###############################
# # pssh를 rpm 버전으로 설치하면, pscp는 pscp.pssh 이렇게 실행시켜야 함.
###############################
PSCP_OUT=`which pscp.pssh`

if [[ "$PSCP_OUT" = *"pscp.pssh"* ]]; then
   echo ${PSCP_OUT}
   
   echo "alias pscp=\"pscp.pssh\" " >>  ~/.bashrc
   source ~/.bashrc
   
   cat ~/.bashrc
fi

source ~/.bashrc

###############################
# 호스트 파일에 IP와 도메인 등록 
###############################
echo "add IPs and Domain names in hosts."

cat <<EOT >> /etc/hosts

10.10.1.145  big01.goodmit.co.kr  big01
10.10.1.146  big02.goodmit.co.kr  big02
10.10.1.147  big03.goodmit.co.kr  big03
10.10.1.148  cdsw.goodmit.co.kr   cdsw

EOT


cat <<EOT >> /etc/hosts

172.16.31.130  rhel900.gitcluster.co.kr  rhel900
172.16.31.131  rhel901.gitcluster.co.kr  rhel901
172.16.31.132  rhel902.gitcluster.co.kr  rhel902
EOT


cat /etc/hosts

###############################
# ssh-keygen
###############################
echo "ssh-keygen"

yes '' | ssh-keygen -N ""

ls -al ~/.ssh

###############################
# ssh-copy-id 와 allhost 파일 생성
###############################
echo "ssh-copy-id and create allhost file"

rm -f  /root/allnodes
rm -f  /root/nodes_exclude_me

#ROOT_PW='Goodmit0802!'
#ROOT_PW='cloudera'
MY_HOST_NAME=`hostname`
while read IP FQDN DOMAIN
do   
    if [ "$FQDN" == "" ] ;then
        continue     
    fi  
    
    if [ "$FQDN" == "localhost" ] ;then
        continue
    fi

    ssh-copy-id -i ~/.ssh/id_rsa.pub  ${DOMAIN}
    
    echo ${DOMAIN} >> /root/allnodes
    
    if [ "$FQDN" == "$MY_HOST_NAME" ] ;then
        continue
    fi
    
    echo ${DOMAIN} >> /root/nodes_exclude_me
    
done < /etc/hosts


cat /root/allnodes

cat /root/nodes_exclude_me

pssh -h /root/allnodes ls 

###############################
# /etc/hosts 파일을 모든 노드에 복사
###############################
pscp -h /root/allnodes   /etc/hosts   /etc/hosts  

pssh -i -h /root/allnodes   "cat /etc/hosts"

