#!/bin/bash -l

#$ -t 1800-1979
#$ -j y
#$ -N bc_mg_ft
#$ -hold_jid splitpagevol_front
#$ -P marxnsf1
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

$NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_byyear_front_lev.pl mag $SGE_TASK_ID


