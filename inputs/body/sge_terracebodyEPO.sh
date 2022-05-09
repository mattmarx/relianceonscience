#/bin/bash -l

#$ -t 1800-2019
#$ -j y
#$ -N terracebody
#$ -P marxnsf1
#$ -hold_jid assemblebody

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

cat epobodynpl.tsv | ../terracenpl.pl $SGE_TASK_ID  > bodybyrefyear/body_$SGE_TASK_ID.tsv 
