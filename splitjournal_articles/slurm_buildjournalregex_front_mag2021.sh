#!/bin/bash -l

##$ -t 1800-2019
#SBATCH --array=0-221

YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

#SBATCH -p large

#SBATCH -o splitjournal_front-%j.out

#SBATCH -J bjfm$YEAR_ID

##$ -hold_jid splitjournal_front
#SBATCH --dependency=singleton --job-name splitjournal_front

##$ -l h_rt=96:00:00
#SBATCH -t 96:00:00

##$ -V
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#

#$NPL_BASE/nplmatch/splitjournal_articles/buildsplitregex_byyear_front_lev.pl mag $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splitjournal_articles/buildjournalregex_byyear_front.pl mag $YEAR_ID


