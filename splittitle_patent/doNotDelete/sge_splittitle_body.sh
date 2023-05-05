#!/bin/bash -l

#$ -t 1800-2019
#$ -j y
#$ -N splittitle_body
#$ -l h_rt=48:00:00
#$ -hold_jid terracebody,terracewos,terracemag,terracepubmed
#$ -P marxnsf1
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


$NPL_BASE/nplmatch/splittitle_patent/splittitle_body.pl $SGE_TASK_ID
