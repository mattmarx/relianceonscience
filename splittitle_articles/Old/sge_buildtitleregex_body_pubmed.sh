#!/bin/bash -l

#$ -t 1800-2019
#$ -j y
#$ -N bt_pm_bd
##$ -hold_jid splittitle_body
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splittitle_articles/buildtitleregex_byyear_body.pl pubmed $SGE_TASK_ID


