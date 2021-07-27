#!/bin/bash -l

#$ -t 1799-2019
##$ -t 1800-2019
#$ -j y
#$ -l h_rt=96:00:00
#$ -N splitpagevol_front
#$ -P marxnsf1
#$ -hold_jid terracefront,terracewos,terracemag,terracepubmed
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


$NPL_BASE/nplmatch/splitpagevol_patent/splitpagevol_front.pl $SGE_TASK_ID


