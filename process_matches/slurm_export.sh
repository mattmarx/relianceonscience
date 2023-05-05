#!/bin/bash

### Author: Joshua Chu
### Date: March 23, 2023

### Command structure: sh slurm_sorted.sh <front or body>


### set the file directory
dir=$(pwd)

TEMPFILE=./slurmfile.slurm

if [ -z "$1" ]
then
 echo "You are missing a user input. The command structure is: sh slurm_export.sh <front or body>"

else
 echo "Processing $1 patents"

 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p large" >> $TEMPFILE
 echo "#SBATCH -J ${1}" >> $TEMPFILE
 echo "#SBATCH -t 14-0" >> $TEMPFILE
 echo "#SBATCH -n 100" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >> $TEMPFILE
 echo "python3 $dir/exportmatches.py $1" >> $TEMPFILE

 sbatch $TEMPFILE
 sleep 0.1

fi
