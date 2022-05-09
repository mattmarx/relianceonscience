#!/bin/bash 
#SBATCH -p large
### #!/bin/bash -l



### #$ -m a

### #$ -j y

#SBATCH -J frankenfilter
### #$ -N frankenfilter

## #SBATCH --depend=genwindows
### #$ -hold_jid genwindows

#SBATCH -t 12:00:00
### #$ -l h_rt=12:00:00

#SBATCH --wckey=marxnfs1
### #$ -P marxnsf1

### chmod 664 $SGE_STDOUT_PATH
### chmod 664 $SGE_STDERR_PATH


#SBATCH --array=0-409
PARAS_ID=$(( ($SLURM_ARRAY_TASK_ID + 10001) ))
### #$ -t 10001-10410

perl $NPL_BASE/nplmatch/inputs/body/frankenfilter_jeren.pl $NPL_BASE/nplmatch/inputs/body/fulltext_g19762004/windows-$PARAS_ID > $NPL_BASE/nplmatch/inputs/body/fulltext_g19762004/filtered-$PARAS_ID 2> $NPL_BASE/nplmatch/inputs/body/fulltext_g19762004/skipped-$PARAS_ID
### /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/frankenfilter.pl /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_g19762004/windows-$SGE_TASK_ID > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_g19762004/filtered-$SGE_TASK_ID 2> /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_g19762004/skipped-$SGE_TASK_ID

