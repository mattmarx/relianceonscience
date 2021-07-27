#!/bin/bash -l

#SBATCH -p large

##$ -j y
#SBATCH -o splitpagevol_front-%j.out

##$ -N bc_mg_ft
#SBATCH -J bc_mg_ft

##$ -hold_jid splitpagevol_front
#SBATCH --dependency=singleton --job-name splitpagevol_front

##$ -l h_rt=96:00:00
#SBATCH -t 96:00:00

##$ -V
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#

##$ -t 1800-2019
#SBATCH --array=0-220
YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

#$NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_byyear_front_lev.pl mag $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_byyear_front_lev.pl mag $YEAR_ID


