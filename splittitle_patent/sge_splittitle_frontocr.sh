#!/bin/bash -l

#$ -t 1799-1979
#$ -j y
#$ -N splittitle_front
#$ -P marxnsf1
#$ -hold_jid terracefront,terracemag,terracepubmed,terracewos
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


$NPL_BASE/nplmatch/splittitle_patent/splittitle_front.pl $SGE_TASK_ID
