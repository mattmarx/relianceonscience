#!/bin/bash -l

#SBATCH --export=ALL

#SBATCH -p large

##$ -j y
#SBATCH -o ./outputthingy
###SBATCH -o buildtitleregex1799-%j.out

##$ -N bt_mg_ft
#SBATCH -J bt_mg_ft

##$ -hold_jid splittitle_front
#SBATCH --dependency=singleton --job-name splittitle

##$ -l h_rt=96:00:00
#SBATCH -t 96:00:00

##$ -V
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#
#$NPL_BASE/nplmatch/splittitle_articles/buildtitleregex_1799_front_lev.pl mag
perl $NPL_BASE/nplmatch/splittitle_articles/year_regex_scripts_front_mag_lev/year1803-1000.pl


