#!/bin/bash -l

##$ -t 1800-2019
#SBATCH --array=0-4

#SBATCH -p large

##$ -j y

##$ -N bt_mg_ft
#SBATCH -J bt_mg_ft

##$ -hold_jid splittitle_article_front
#SBATCH --dependency=singleton --job-name splittitle_patent_front

###$ -l h_rt=96:00:00
#SBATCH -t 96:00:00

##$ -V
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#
#
FILE_ID=$(( ($SLURM_ARRAY_TASK_ID + 1000) ))

#SBATCH -o $NPL_BASE/splittitle_articles/year_regex_output_mag_lev/year1980-$FILE_ID.txt
#$NPL_BASE/nplmatch/splittitle_articles/buildtitleregex_byyear_front_lev.pl mag $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splittitle_articles/year_regex_scripts_mag_lev/year1980-$FILE_ID.pl


