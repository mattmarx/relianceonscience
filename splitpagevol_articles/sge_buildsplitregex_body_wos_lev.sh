#!/bin/bash -l

##$ -t 2018-2019
#$ -t 1900-2019
#$ -j y
#$ -N bc_ws_bd
#$ -hold_jid splitpagevolbody
#$ -l h_rt=12:00:00
#$ -P marxnsf1
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

$NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_byyear_body_lev.pl wos $SGE_TASK_ID


