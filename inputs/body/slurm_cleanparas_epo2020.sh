#!/bin/bash
#SBATCH -p large
#!/bin/bash -l

##$ -j y

#SBATCH -J cleanparas
###$ -N cleanparas

#SBATCH --wckey=marxnfs1
###$ -P marxnsf1

### chmod 664 $SGE_STDOUT_PATH
### chmod 664 $SGE_STDERR_PATH

#SBATCH --array=0-2
PARAS_ID=$(( ($SLURM_ARRAY_TASK_ID + 10001) ))
##$ -t 10001-10783

perl $NPL_BASE/nplmatch/inputs/body/cleanepoparas.pl $NPL_BASE/nplmatch/inputs/body/epo_2020/paras-$PARAS_ID > $NPL_BASE/nplmatch/inputs/body/epo_2020/cleanparas-$PARAS_ID
