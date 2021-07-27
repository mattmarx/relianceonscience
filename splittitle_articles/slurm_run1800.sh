#!/bin/bash -l

#####SBATCH --array=0-0

#SBATCH -p large

##SBATCH -o ./year_regex_output_mag_lev/year1800-1000.txt
####SBATCH -o ./year_regex_output_mag_lev/year1800-$FILE_ID.txt
######SBATCH -o $NPL_BASE/splittitle_articles/year_regex_output_mag_lev/year1800-$FILE_ID.txt

##FILE_ID=$(( ($SLURM_ARRAY_TASK_ID + 1000) ))

#$NPL_BASE/nplmatch/splittitle_articles/buildtitleregex_byyear_front_lev.pl mag $SGE_TASK_ID
#perl $NPL_BASE/nplmatch/splittitle_articles/year_regex_scripts_mag_lev/year1800-$FILE_ID.pl
perl $NPL_BASE/nplmatch/splittitle_articles/year_regex_scripts_front_mag_lev/year1803-1000.pl
#perl $NPL_BASE/nplmatch/splittitle_articles/year_regex_scripts_mag_lev/year1800-$FILE_ID.pl > $NPL_BASE/nplmatch/splittitle_articles/year_regex_output_mag_lev/year1800-$FILEID.txt


