

CURRENT_TIME='date +"%H:%M:%S"'
echo "####start  sh 02_make.sh     `$CURRENT_TIME` ####"


docker build --network=host -t conda.docker.repository.cloudera.com/cdsw/engine:10 . -f  02.01.conda.Dockerfile 

echo "####end  sh 02_make.sh     `$CURRENT_TIME` ####"
