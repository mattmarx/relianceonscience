#!/bin/bash -l

##$ -t 1800-2019
#SBATCH --array=0-220

YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

#SBATCH -p large

#SBATCH -o splitjournal_body-%j.out

#SBATCH -J bjbm$YEAR_ID

#SBATCH --dependency=singleton --job-name splitjournal_body

#SBATCH -t 96:00:00


#$NPL_BASE/nplmatch/splitjournal_articles/buildsplitregex_byyear_body_lev.pl mag $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splitjournal_articles/buildjournalregex_byyear_body.pl mag $YEAR_ID


