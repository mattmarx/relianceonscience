#!/bin/bash 
#SBATCH -p large
### #!/bin/bash -l

### #$ -j y

#SBATCH -J cleanparas
### #$ -N cleanparas

#SBATCH -t 12:00:00
### #$ -l h_rt=12:00:00

#SBATCH --wckey=marxnfs1
### #$ -P marxnsf1

### chmod 664 $SGE_STDOUT_PATH
### chmod 664 $SGE_STDERR_PATH

#SBATCH --array=0-790
PARAS_ID=$(( ($SLURM_ARRAY_TASK_ID + 10001) ))
### #$ -t 10001-10410

perl $NPL_BASE/nplmatch/inputs/body/cleanparas.pl < $NPL_BASE/nplmatch/inputs/body/fulltext_u20052019/paras-$PARAS_ID > $NPL_BASE/nplmatch/inputs/body/fulltext_u20052019/cleanparas-$PARAS_ID

