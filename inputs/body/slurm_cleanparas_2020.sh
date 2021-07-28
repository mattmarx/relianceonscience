#!/bin/bash -l

##$ -t 10001-10783
##SBATCH -a 1-10
#SBATCH -a 1-10
##$ -j y
##$ -N cleanparas
#SBATCH -J cleanparas

##$ -P marxnsf1
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#
#
#/projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/cleanparas.pl /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_u20052019/paras-$SGE_TASK_ID > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_u20052019/cleanparas-$SGE_TASK_ID
FILE_ID=$(( ($SLURM_ARRAY_TASK_ID + 10000) ))

perl $NPL_BASE/nplmatch/inputs/body/cleanparas.pl $NPL_BASE/nplmatch/inputs/body/fulltext_2020/paras-$FILE_ID > $NPL_BASE/nplmatch/inputs/body/fulltext_2020/cleanparas-$FILE_ID


