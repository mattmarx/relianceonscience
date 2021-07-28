#$ -t 1800-2019
#$ -m a
#$ -j y
#$ -N terracepubmed
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

cat pubmedoneline.tsv | grep "^$SGE_TASK_ID" | sed -e 's/\\//g' |  sed -e 's/@//g' | sed -e 's/{//g' | sed -e 's/}//g' > pubmedbyyear/pubmed_$SGE_TASK_ID.tsv 

