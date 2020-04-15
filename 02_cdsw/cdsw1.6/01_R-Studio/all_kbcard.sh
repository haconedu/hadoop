

SITE_DOMAIN=kbcard.com


 sh 01_make.sh  ${SITE_DOMAIN} && \
 sh 02_make.sh  ${SITE_DOMAIN} && \
 sh save_docker.sh   ${SITE_DOMAIN}  && \
 scp *.tar.gz   goodmit@10.200.101.253:/home/goodmit/repo/kbcard/

