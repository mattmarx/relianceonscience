#/bin/bash -l

#$ -t 1800-2019
#$ -m a
#$ -j y
#$ -N terrace
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

cat frontpage19472019usintl.tsv | grep "[ ,;:\(\[\{\]$SGE_TASK_ID[ ,:;\)\}\n]"  > nplbyrefyear/nplc_$SGE_TASK_ID.tsv 


