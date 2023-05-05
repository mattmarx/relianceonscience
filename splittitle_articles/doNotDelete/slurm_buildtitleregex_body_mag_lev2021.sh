#!/bin/bash -l

#SBATCH -p large

#SBATCH -o buildtitleregex-%j.out

#SBATCH -J btbm$YEAR_ID

### #SBATCH --dependency=singleton --job-name splittitle_patent_front

#SBATCH -t 96:00:00

#SBATCH --array=0-221
YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

#$NPL_BASE/nplmatch/splittitle_articles/buildtitleregex_byyear_body_lev.pl mag $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splittitle_articles/buildtitleregex_byyear_body_lev.pl mag $YEAR_ID


