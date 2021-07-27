#!/bin/bash -l

##$ -j y
#SBATCH -o splitpagevol_front-%j.out

#SBATCH -p large

##$ -N bc_mg_ft
#SBATCH -J bc_mg_ft

##$ -hold_jid splitpagevol_front
#SBATCH --dependency=singleton --job-name=splitpagevol_front

##$ -l h_rt=96:00:00
#SBATCH -t 96:00:00

##$ -V
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#
#$NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_1799_front_lev.pl mag
perl $NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_1799_front_lev.pl mag


