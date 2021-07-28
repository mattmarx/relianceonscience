#$ -t 1900-2019
#$ -m a
#$ -j y
#$ -N terracewos
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

cat wosplpubinfo1955-2017_filteredISS.txt | grep "^$SGE_TASK_ID" | sed -e 's/\\//g' |  sed -e 's/@//g' | sed -e 's/{//g' | sed -e 's/}//g' > wosbyyear/wos_$SGE_TASK_ID.tsv 

