#!/bin/bash -l

##$ -t 1799-2019
##$ -t 1800-2019
#SBATCH --array=0-221
##SBATCH --array=0-2

##$ -j y
#SBATCH -o splitpagevol-%j.out

##$ -l h_rt=96:00:00
#SBATCH -t 96:00:00

##$ -N splitpagevol_front
#SBATCH -J splitpagevol_front

##$ -hold_jid terracefront,terracewos,terracemag,terracepubmed
#SBATCH --dependency=singleton --job-name=terracemag --job-name=terracewos --job-name=terracepubmed

##$ -V

#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH

#SBATCH -p large

YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1799) ))

#$NPL_BASE/nplmatch/splitpagevol_patent/splitpagevol_front.pl $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splitpagevol_patent/splitpagevol_front.pl $YEAR_ID


