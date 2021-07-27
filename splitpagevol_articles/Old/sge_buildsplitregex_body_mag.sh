#!/bin/bash -l

#$ -t 1800-2019
#$ -j y
#$ -N bc_mg_bd
#$ -hold_jid splitpagevolbody
#$ -l h_rt=12:00:00
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitpagevol_articles/buildsplitregex_byyear_body.pl mag $SGE_TASK_ID


