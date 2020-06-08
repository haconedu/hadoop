
SITE_DOMAIN=kbcard.com
CURRENT_DATE='date +"%Y%m%d"'

 sh 01_make.sh  && \
 sh 02_make.sh  && \
 sh 03_01_make.sh ${SITE_DOMAIN} ${CURRENT_DATE}  && \
 sh 03_02_make.sh ${SITE_DOMAIN} ${CURRENT_DATE}  && \
 sh 03_03_make.sh ${SITE_DOMAIN} ${CURRENT_DATE}  && \
 sh 03_04_make.sh ${SITE_DOMAIN} ${CURRENT_DATE}  && \
 sh 03_05_make.sh ${SITE_DOMAIN} ${CURRENT_DATE}  && \
# sh save_docker.sh  ${SITE_DOMAIN} ${CURRENT_DATE} 
# mv  *.tar.gz  ~/repo/

# sshpass -pgit08021! scp -o StrictHostKeyChecking=no  \
#      /home/goodmit/repo/kbcard/.tar.gz  \
#	  admin@10.200.101.14:/volume1/Bigdata_AI/kbcard/  
 
 sh check_pkg.sh  ${SITE_DOMAIN} 

