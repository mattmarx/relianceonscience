#!/bin/bash -l

#$ -t 1900-2018
#$ -j y
#$ -N bc_ws_ft
#$ -l h_rt=12:00:00
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitpagevol_articles/buildsplitregex_byyear_front.pl wos $SGE_TASK_ID


