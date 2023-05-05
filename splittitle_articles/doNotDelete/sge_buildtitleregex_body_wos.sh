#!/bin/bash -l

#$ -t 1900-2017
#$ -j y
#$ -N bt_ws_bd
##$ -hold_jid splittitle_body
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splittitle_articles/buildtitleregex_byyear_body.pl wos $SGE_TASK_ID


