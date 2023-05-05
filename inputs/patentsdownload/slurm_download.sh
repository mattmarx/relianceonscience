#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### This script passes the windows- files to the frankenfilter.pl script in order to reduce the
### size of the windows. The config.pl is utilized to extract the year and determine how many
### subdirectories are present for the given year. The full path to the required files is
### programatically configured and the output files permissions are set for all user to have
### access. If the below command structure is unfamiliar to you, refer to RSP-Technical Document
### section 2.2.1 How to Download USPTO Patent Data for instructions

### Command structure: sh slurm_download.sh Patents-a7297052339d.json <front or body> startdate enddate


### extract front or intext from the pwd; this will be utilized to construct the full directory paths
### in following steps
directory=$(pwd)

TEMPFILE=./slurmfile.slurm

echo "Downloading $2 from Google"

echo "#!/bin/bash" > $TEMPFILE
echo "#SBATCH -p xlarge" >> $TEMPFILE
echo "#SBATCH -J ${2}Pats" >> $TEMPFILE
echo "#SBATCH -t 14-0" >> $TEMPFILE
echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
echo "module load perl5-libs" >> $TEMPFILE
echo "python3 downloadAppDates.py $1 $2 $3 $4" >> $TEMPFILE

sbatch $TEMPFILE
sleep 0.1
