#!/bin/bash -l

##$ -t 1800-2019
#SBATCH -a 0-220

##$ -j y
#SBATCH -o terracejournal-%j.out

##$ -N terracejournal
#SBATCH -J terracejournal

##$ -P marxnsf1
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#
#cat matchedjournals_magnameNODUPES.tsv | terracenpl.pl $SGE_TASK_ID > journalbyrefyear/journalfront_$SGE_TASK_ID.tsv 
YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

cat matchedjournals_magnameNODUPES.tsv | perl terracenpl.pl $YEAR_ID > journalbyrefyear/journalfront_$YEAR_ID.tsv 
#
#
