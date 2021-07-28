#!/bin/bash -l

##$ -t 1800-2020
#SBATCH -a 0-220

##$ -j y
#SBATCH -o terrace-%j.out

##$ -N terrace
#SBATCH -J terrace

#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH

#cat magoneline.tsv | grep "^$SGE_TASK_ID" | sed -e 's/\\//g' |  sed -e 's/@//g' | sed -e 's/{//g' | sed -e 's/}//g' > magbyyear/mag_$SGE_TASK_ID.tsv 
YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))
cat magoneline.tsv | grep "^$YEAR_ID" | sed -e 's/\\//g' |  sed -e 's/@//g' | sed -e 's/{//g' | sed -e 's/}//g' > magbyyear/mag_$YEAR_ID.tsv 


