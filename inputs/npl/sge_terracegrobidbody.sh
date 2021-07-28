#/bin/bash -l

#$ -t 1800-2019
#$ -m a
#$ -j y
#$ -N terracegrobid
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

cat grobidwindowfulltextparsed_lc.txt | sed -e 's/^_*us//' | sed -e 's/^0*//' | grep "[ ,;:\(\[\{\]$SGE_TASK_ID[ ,:;\)\}\n]"  > nplbyrefyear/nplc_$SGE_TASK_ID.tsv 


