#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### Command structure: sh slurm_sorted.sh <front or body> <oa or mag> <annual or batch>


### set the file directory and set the year variable from the config.pl file
dir=$(pwd)

TEMPFILE=./slurmfile.slurm

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
 echo "You are missing a user input. The command structure is: sh slurm_sorted.sh <front or body> <oa or mag> <annual or batch>"

else
 echo "Sorting the $1 patents"

 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p large" >> $TEMPFILE
 echo "#SBATCH -J ${1}" >> $TEMPFILE
 echo "#SBATCH -t 14-0" >> $TEMPFILE
 echo "#SBATCH -n 100" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >> $TEMPFILE
 echo "sh $dir/sort_scored.sh $1 $2 $3" >> $TEMPFILE

 sbatch $TEMPFILE
 sleep 0.1

fi
