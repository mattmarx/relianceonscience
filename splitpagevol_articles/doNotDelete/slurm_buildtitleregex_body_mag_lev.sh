#!/bin/bash -l

#SBATCH --array=0-220

#SBATCH -p large

#SBATCH -o splitpagevol_body-%j.out

#SBATCH -J bcbm$YEAR_ID

#SBATCH --dependency=singleton --job-name splitpagevol_body

#SBATCH -t 96:00:00

##$ -t 1800-2019
#SBATCH --array=0-220

YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

#$NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_byyear_body_lev.pl mag $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_byyear_body_lev.pl mag $YEAR_ID


