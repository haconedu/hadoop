
CURRENT_TIME='date +"%H:%M:%S"'

echo "####start  sh 01_make.sh     `$CURRENT_TIME` ####"

docker build --network=host -t biopython.cloudera.com/cdsw/engine:8 . -f  01.bio.Dockerfile 

echo "####end  sh 01_make.sh     `$CURRENT_TIME` ####"
