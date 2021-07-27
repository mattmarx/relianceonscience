#!/bin/bash -l

#$ -t 1900-2019
#$ -j y
#$ -N bj_ws_ft
#$ -P marxnsf1
#$ -hold_jid splitjournal
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


$NPL_BASE/nplmatch/splitjournal_articles/buildjournalregex_byyear_front.pl wos $SGE_TASK_ID


