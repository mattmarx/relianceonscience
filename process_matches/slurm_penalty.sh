#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### Command structure: sh slurm_penalty.sh <front or body> <annual or batch>


### set the file directory and set the year variable from the config.pl file
dir=$(pwd)
year=$(perl $NPL_BASE/nplmatch/config.pl)

TEMPFILE=./slurmfile.slurm

if [ -z "$1" ] || [ -z "$2" ]
then
 echo "You are missing a user input. The command structure is: sh slurm_penalty.sh <front or body> <annual or batch>"

else
 echo "Comparing Patent and Publications years"

 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p large" >> $TEMPFILE
 echo "#SBATCH -J ${1}" >> $TEMPFILE
 echo "#SBATCH -t 14-0" >> $TEMPFILE
 echo "#SBATCH -n 100" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >> $TEMPFILE
 echo "python3 $dir/matches_penalty.py $1 $year $2" >> $TEMPFILE

 sbatch $TEMPFILE
 sleep 0.1

fi
