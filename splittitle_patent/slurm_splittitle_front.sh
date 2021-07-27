#!/bin/bash -l

##$ -j y
#SBATCH -o splittitle-%j.out

##$ -N splittitle_front
#SBATCH -J splittitle_front

##$ -l h_rt=96:00:00
#SBATCH -t 96:00:00

##$ -hold_jid terracefront,terracemag,terracepubmed,terracewos
#SBATCH --dependency=singleton --job-name=terracemag --job-name=terracewos --job-name=terracepubmed

##$ -V

#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH

##$ -t 1799-2020
##SBATCH --array=0-2
#SBATCH --array=0-221

YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1799) ))

#$NPL_BASE/nplmatch/splittitle_patent/splittitle_front.pl $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splittitle_patent/splittitle_front.pl $YEAR_ID
