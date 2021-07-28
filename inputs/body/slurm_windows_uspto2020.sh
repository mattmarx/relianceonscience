#!/bin/bash
#SBATCH -p large
### #!/bin/bash -l

### #$ -m a

### #$ -j y

#SBATCH -J genwindows
### #$ -N genwindows

#SBATCH --depend=cleanparas
### #$ -hold_jid cleanparas

#SBATCH -t 12:00:00
### #$ -l h_rt=12:00:00

#SBATCH --wckey=marxnfs1
### #$ -P marxnsf1

### chmod 664 $SGE_STDOUT_PATH
### chmod 664 $SGE_STDERR_PATH

#SBATCH --array=0-12
PARAS_ID=$(( ($SLURM_ARRAY_TASK_ID + 10001) ))
### #$ -t 10001-10410

perl $NPL_BASE/nplmatch/inputs/body/parajustdumpyearwindows.pl < $NPL_BASE/nplmatch/inputs/body/uspto_2020/cleanparas-$PARAS_ID > $NPL_BASE/nplmatch/inputs/body/uspto_2020/windows-$PARAS_ID
### /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/parajustdumpyearwindows.pl /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_g19762004/cleanparas-$SGE_TASK_ID > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_g19762004/windows-$SGE_TASK_ID
