
SITE_DOMAIN=$1

echo "SITE_DOMAIN=$SITE_DOMAIN"

if [ "$SITE_DOMAIN"  == "" ]; then

   echo "example : $0  goodmit.com "
   exit 1

fi

CURRENT_DATE=$2
if [ "$CURRENT_DATE"  == "" ]; then

    CURRENT_DATE=`date +"%Y%m%d"`
fi


CURRENT_TIME='date +"%H:%M:%S"'
echo "####start  sh 03_05_make.sh     `$CURRENT_TIME` ####"

docker build --network=host -t mobilenet.${SITE_DOMAIN}/cdsw/engine:8.${CURRENT_DATE} . -f  03.05.mobilenet.Dockerfile

echo "####end  sh 03_05_make.sh     `$CURRENT_TIME` ####"
