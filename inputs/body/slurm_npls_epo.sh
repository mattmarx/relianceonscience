#!/bin/bash -l

##$ -t 10004-10039
#SBATCH -a 0-2

##$ -m a
##$ -j y
#SBATCH -J frankenfilter
##$ -N frankenfilter
##$ -hold_jid genwindows
##$ -l h_rt=12:00:00
##$ -P marxnsf1
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#
#
#/projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/frankenfilterEPO.pl /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_epo/windows-$SGE_TASK_ID > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_epo/filtered-$SGE_TASK_ID 2> /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_epo/skipped-$SGE_TASK_ID
FILE_ID=$(( ($SLURM_ARRAY_TASK_ID + 10000) ))

perl $NPL_BASE/nplmatch/inputs/body/frankenfilterEPO.pl $NPL_BASE/nplmatch/inputs/body/fulltext_epo/windows-$FILE_ID > $NPL_BASE/nplmatch/inputs/body/fulltext_epo/filtered-$FILE_ID 2> $NPL_BASE/nplmatch/inputs/body/fulltext_epo/skipped-$FILE_ID
#
##
