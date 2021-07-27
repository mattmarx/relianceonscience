#!/bin/bash -l

#$ -t 1900-2017
#$ -m ea
#$ -j y
#$ -N titlenpl
#$ -l h_rt=24:00:00
#$ -P marxnsf1

/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splittitle/year_regex_scripts/year$SGE_TASK_ID.pl > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/splittitle/year_regex_output/year$SGE_TASK_ID.txt


