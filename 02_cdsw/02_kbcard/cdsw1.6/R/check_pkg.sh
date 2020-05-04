SITE_DOMAIN=$1

echo "SITE_DOMAIN=$SITE_DOMAIN"

if [ "$SITE_DOMAIN"  == "" ]; then

   echo "example : $0  goodmit.com "
   exit 1

fi


COMMON_PKG="\
R -e 'library(abind)' \
R -e 'library(acepack)' \
R -e 'library(adabag)' \
R -e 'library(ade4)' \
R -e 'library(ape)' \
R -e 'library(assertthat)' \
R -e 'library(backports)' \
R -e 'library(base64enc)' \
R -e 'library(BH)' \
R -e 'library(bindr)' \
R -e 'library(bindrcpp)' \
R -e 'library(bipartite)' \
R -e 'library(bit)' \
R -e 'library(bit64)' \
R -e 'library(bitops)' \
R -e 'library(blob)' \
R -e 'library(broom)' \
R -e 'library(callr)' \
R -e 'library(car)' \
R -e 'library(caret)' \
R -e 'library(caTools)' \
R -e 'library(cellranger)' \
R -e 'library(checkmate)' \
R -e 'library(cli)' \
R -e 'library(clipr)' \
R -e 'library(clue)' \
R -e 'library(ClusterR)' \
R -e 'library(clv)' \
R -e 'library(colorspace)' \
R -e 'library(corrplot)' \
R -e 'library(covr)' \
R -e 'library(crayon)' \
R -e 'library(curl)' \
R -e 'library(data.table)' \
R -e 'library(DBI)' \
R -e 'library(DBItest)' \
R -e 'library(dbplyr)' \
R -e 'library(DEoptimR)' \
R -e 'library(dichromat)' \
R -e 'library(digest)' \
R -e 'library(diptest)' \
R -e 'library(doBy)' \
R -e 'library(doMC)' \
R -e 'library(doParallel)' \
R -e 'library(doRNG)' \
R -e 'library(doSNOW)' \
R -e 'library(dplyr)' \
R -e 'library(dtw)' \
R -e 'library(e1071)' \
R -e 'library(elasticnet)' \
R -e 'library(evaluate)' \
R -e 'library(FD)' \
R -e 'library(fda)' \
R -e 'library(fdapace)' \
R -e 'library(fda.usc)' \
R -e 'library(fields)' \
R -e 'library(flashClust)' \
R -e 'library(flexclust)' \
R -e 'library(flexmix)' \
R -e 'library(forcats)' \
R -e 'library(foreach)' \
R -e 'library(forecast)' \
R -e 'library(Formula)' \
R -e 'library(fpc)' \
R -e 'library(fracdiff)' \
R -e 'library(futile.logger)' \
R -e 'library(futile.options)' \
R -e 'library(gbm)' \
R -e 'library(gdata)' \
R -e 'library(geometry)' \
R -e 'library(ggplot2)' \
R -e 'library(glmnet)' \
R -e 'library(glue)' \
R -e 'library(gmp)' \
R -e 'library(GPFDA)' \
R -e 'library(GPfit)' \
R -e 'library(gplots)' \
R -e 'library(gridBase)' \
R -e 'library(gridExtra)' \
R -e 'library(gtable)' \
R -e 'library(gtools)' \
R -e 'library(haven)' \
R -e 'library(highr)' \
R -e 'library(Hmisc)' \
R -e 'library(hms)' \
R -e 'library(htmlTable)' \
R -e 'library(htmltools)' \
R -e 'library(htmlwidgets)' \
R -e 'library(httpuv)' \
R -e 'library(httr)' \
R -e 'library(ifultools)' \
R -e 'library(igraph)' \
R -e 'library(implyr)' \
R -e 'library(imputeTS)' \
R -e 'library(inum)' \
R -e 'library(ipred)' \
R -e 'library(irlba)' \
R -e 'library(iterators)' \
R -e 'library(itertools)' \
R -e 'library(jpeg)' \
R -e 'library(jsonlite)' \
R -e 'library(kernlab)' \
R -e 'library(kml)' \
R -e 'library(kml3d)' \
R -e 'library(knitr)' \
R -e 'library(kohonen)' \
R -e 'library(labeling)' \
R -e 'library(lambda.r)' \
R -e 'library(lars)' \
R -e 'library(latticeExtra)' \
R -e 'library(lava)' \
R -e 'library(lazyeval)' \
R -e 'library(lhs)' \
R -e 'library(libcoin)' \
R -e 'library(lme4)' \
R -e 'library(lmtest)' \
R -e 'library(locpol)' \
R -e 'library(longitudinalData)' \
R -e 'library(lubridate)' \
R -e 'library(magic)' \
R -e 'library(magrittr)' \
R -e 'library(maps)' \
R -e 'library(markdown)' \
R -e 'library(MASS)' \
R -e 'library(MatrixModels)' \
R -e 'library(mclust)' \
R -e 'library(mime)' \
R -e 'library(miniCRAN)' \
R -e 'library(minqa)' \
R -e 'library(misc3d)' \
R -e 'library(mlbench)' \
R -e 'library(mnormt)' \
R -e 'library(ModelMetrics)' \
R -e 'library(modelr)' \
R -e 'library(modeltools)' \
R -e 'library(munsell)' \
R -e 'library(mvtnorm)' \
R -e 'library(NbClust)' \
R -e 'library(ncvreg)' \
R -e 'library(network)' \
R -e 'library(NeuralNetTools)' \
R -e 'library(nloptr)' \
R -e 'library(nnet)' \
R -e 'library(numDeriv)' \
R -e 'library(odbc)' \
R -e 'library(OpenImageR)' \
R -e 'library(openssl)' \
R -e 'library(partykit)' \
R -e 'library(pbkrtest)' \
R -e 'library(pdc)' \
R -e 'library(permute)' \
R -e 'library(pillar)' \
R -e 'library(pkgconfig)' \
R -e 'library(pkgmaker)' \
R -e 'library(plogr)' \
R -e 'library(pls)' \
R -e 'library(plsRglm)' \
R -e 'library(plyr)' \
R -e 'library(png)' \
R -e 'library(prabclus)' \
R -e 'library(pracma)' \
R -e 'library(praise)' \
R -e 'library(prodlim)' \
R -e 'library(proxy)' \
R -e 'library(pryr)' \
R -e 'library(psych)' \
R -e 'library(purrr)' \
R -e 'library(qdapRegex)' \
R -e 'library(quadprog)' \
R -e 'library(quantmod)' \
R -e 'library(quantreg)' \
R -e 'library(R6)' \
R -e 'library(randomForest)' \
R -e 'library(RcmdrMisc)' \
R -e 'library(RColorBrewer)' \
R -e 'library(Rcpp)' \
R -e 'library(RcppArmadillo)' \
R -e 'library(RcppEigen)' \
R -e 'library(readr)' \
R -e 'library(readxl)' \
R -e 'library(registry)' \
R -e 'library(relimp)' \
R -e 'library(rematch)' \
R -e 'library(reprex)' \
R -e 'library(reshape2)' \
R -e 'library(reticulate)' \
R -e 'library(rex)' \
R -e 'library(rgl)' \
R -e 'library(rJava)' \
R -e 'library(RJDBC)' \
R -e 'library(RJSONIO)' \
R -e 'library(rlang)' \
R -e 'library(rmarkdown)' \
R -e 'library(RMySQL)' \
R -e 'library(rngtools)' \
R -e 'library(robustbase)' \
R -e 'library(ROCR)' \
R -e 'library(RODBC)' \
R -e 'library(rowr)' \
R -e 'library(rpart)' \
R -e 'library(rprojroot)' \
R -e 'library(rstudioapi)' \
R -e 'library(rvest)' \
R -e 'library(sandwich)' \
R -e 'library(scales)' \
R -e 'library(scatterplot3d)' \
R -e 'library(selectr)' \
R -e 'library(shapes)' \
R -e 'library(shiny)' \
R -e 'library(sna)' \
R -e 'library(snow)' \
R -e 'library(som)' \
R -e 'library(sourcetools)' \
R -e 'library(spam)' \
R -e 'library(SparseM)' \
R -e 'library(splitstackshape)' \
R -e 'library(splus2R)' \
R -e 'library(statnet.common)' \
R -e 'library(stinepack)' \
R -e 'library(stringi)' \
R -e 'library(stringr)' \
R -e 'library(strucchange)' \
R -e 'library(testthat)' \
R -e 'library(tibble)' \
R -e 'library(tidyr)' \
R -e 'library(tidyselect)' \
R -e 'library(tidyverse)' \
R -e 'library(tiff)' \
R -e 'library(timeDate)' \
R -e 'library(trimcluster)' \
R -e 'library(TSclust)' \
R -e 'library(tseries)' \
R -e 'library(TTR)' \
R -e 'library(urca)' \
R -e 'library(utf8)' \
R -e 'library(vars)' \
R -e 'library(vegan)' \
R -e 'library(viridis)' \
R -e 'library(viridisLite)' \
R -e 'library(whisker)' \
R -e 'library(withr)' \
R -e 'library(wmtsa)' \
R -e 'library(XML)' \
R -e 'library(xml2)' \
R -e 'library(xtable)' \
R -e 'library(xts)' \
R -e 'library(yaml)' \
R -e 'library(YieldCurve)' \
R -e 'library(ykmeans)' \
R -e 'library(zoo)' \
R -e 'library(seasonal)' \
R -e 'library(h2o)' \
"

echo "#### check R packages  ####"
docker run -it --rm --net=host --pid=host \
       rstudio.${SITE_DOMAIN}/cdsw/engine:8  \
       /bin/bash 	\
	   -c " ${COMMON_PKG} "