#!/bin/bash -l

###$ -t 10004-10039
#SBATCH -a 0-2
###$ -m a
###$ -j y
###$ -N genwindows
#SBATCH -J genwindows
###$ -hold_jid cleanparas
###$ -l h_rt=12:00:00
###$ -P marxnsf1
##
##chmod 664 $SGE_STDOUT_PATH
##chmod 664 $SGE_STDERR_PATH
##
##
##/projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/parajustdumpyearwindowsEPO.pl /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_epo/cleanparas-$SGE_TASK_ID > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_epo/windows-$SGE_TASK_ID
FILE_ID=$(( ($SLURM_ARRAY_TASK_ID + 10000) ))

perl $NPL_BASE//nplmatch/inputs/body/parajustdumpyearwindowsEPO.pl $NPL_BASE//nplmatch/inputs/body/fulltext_epo/cleanparas-$FILE_ID > $NPL_BASE/nplmatch/inputs/body/fulltext_epo/windows-$FILE_ID


