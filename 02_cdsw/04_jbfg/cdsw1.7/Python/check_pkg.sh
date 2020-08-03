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



COMMON_PKG="\
import numpy ; \
import bokeh ; \
import gensim ; \
import glob2 ; \
import h5py ; \
import joblib ; \
import mpi4py ; \
import multiprocess ; \
import nltk ; \
import pandas ; \
import pymysql ; \
import pyodbc ; \
import scipy ; \
import statsmodels ; \
import statsd ; \
import tqdm ; \
import seaborn ; \
import numba ; \
import lightfm ; \
import pydotplus ; \
import sklearn  ; \
import lightgbm ; \
import gym ; \
import konlpy ; \
import mglearn ; \
import boruta ; \
import geometric ; \
import networkx ; \
import geopandas ; \
import geojson ; \
import shapely ; \
import pysal ; \
import tslearn ; \
import folium ; \
import plotnine ; \
import gower ; \
import PyKomoran ; \
from konlpy.tag import Mecab ; \
"
echo "#### COMMON_PKG  ####"
docker run -it --rm --net=host --pid=host \
       conda.${SITE_DOMAIN}/cdsw/engine:10.${CURRENT_DATE}  \
       /bin/bash 	\
	   -c "/opt/conda/envs/python3.6/bin/python -c \"$COMMON_PKG  \"  "


echo "#### check tensorflow2.0  ####"
MY_PKG="\
import tensorflow ; \
import keras ; \
"
docker run -it --rm --net=host --pid=host \
       tensorflow2.3.${SITE_DOMAIN}/cdsw/engine:10.${CURRENT_DATE}  \
       /bin/bash 	\
	   -c "/opt/conda/envs/python3.6/bin/python -c \"$MY_PKG  \"   "	   

echo "#### check tensorflow1.15  ####"	   
MY_PKG="\
import keras ; \
import tensorflow ; \
"
docker run -it --rm --net=host --pid=host \
       tensorflow1.15.${SITE_DOMAIN}/cdsw/engine:10.${CURRENT_DATE}  \
       /bin/bash 	\
	   -c "/opt/conda/envs/python3.6/bin/python -c \"$MY_PKG  \"   "

echo "#### check pytorch1.3  ####"	   
MY_PKG="\
import torch ; \
import torchvision ; \
import transformers ; \
import kobert ; \
import mxnet ; \
import gluonnlp ; \
import sentencepiece ; \
"
docker run -it --rm --net=host --pid=host \
       pytorch1.3.${SITE_DOMAIN}/cdsw/engine:10.${CURRENT_DATE}  \
       /bin/bash 	\
	   -c "/opt/conda/envs/python3.6/bin/python -c \"$MY_PKG  \"
