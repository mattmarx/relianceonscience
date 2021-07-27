#!/bin/bash
#$ -P marxnsf1
#$ -j y
#$ -t 1800-2019
#$ -N splitpagevol_body
#$ -hold_jid terracebody,terracemag,terracepubmed,terracewos
#$ -V

$NPL_BASE/nplmatch/splitpagevol_patent/splitpagevol_body.pl $SGE_TASK_ID
chmod 664 $SGE_STDOUT_PATH
