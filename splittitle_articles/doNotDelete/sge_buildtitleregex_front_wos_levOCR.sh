#!/bin/bash -l

#$ -t 1900-1979
#$ -m a
#$ -j y
#$ -N bt_ws_ft
#$ -hold_jid splittitle_front
#$ -P marxnsf1
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


$NPL_BASE/nplmatch/splittitle_articles/buildtitleregex_byyear_front_lev.pl wos $SGE_TASK_ID


