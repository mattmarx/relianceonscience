#!/bin/bash -l

#$ -t 1800-2019
#$ -j y
#$ -N splitjournalbody
#$ -l h_rt=12:00:00
#$ -P marxnsf1
#$ -hold_jid terracejournal
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


$NPL_BASE/nplmatch/splitjournal_patent/splitjournal_body.pl $SGE_TASK_ID
