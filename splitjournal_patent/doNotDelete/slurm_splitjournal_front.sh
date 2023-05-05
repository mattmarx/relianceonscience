#!/bin/bash -l

##$ -t 1800-2019
#SBATCH --array=0-220

#SBATCH -p large

##$ -j y
#SBATCH -o splitjournal-%j.out

##$ -N splitjournal_front
#SBATCH -J splitjournal_front

##$ -l h_rt=12:00:00
#SBATCH -t 12:00:00

##$ -P marxnsf1
##$ -hold_jid terracefront,terracejournal
#SBATCH --dependency=singleton --job-name=terracemag

##$ -V

#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH


YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

#$NPL_BASE/nplmatch/splitjournal_patent/splitjournal_front.pl $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splitjournal_patent/splitjournal_front.pl $YEAR_ID
