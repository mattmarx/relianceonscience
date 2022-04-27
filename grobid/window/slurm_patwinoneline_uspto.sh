#!/bin/bash
directory_grobid=$1
directory_input=$2

echo $directory_grobid
echo $directory_input
TEMPFILE=./slurmfile.slurm
NPARAS=$(ls  ../../inputs/body/$directory_input/windows-* | wc -l)
echo $NPARAS
PARAS_ID=10001
for i in  ../../inputs/body/$directory_input/windows-*
do
 echo "doing $PARAS_ID"
 echo "#SBATCH -p large" >> $TEMPFILE
 echo "#SBATCH -J $PARAS_ID" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "perl $NPL_BASE/nplmatch/grobid/window/onepatperlinewindowjeren.pl < $NPL_BASE/nplmatch/inputs/body/$directory_input/windows-$PARAS_ID > $NPL_BASE/nplmatch/grobid/window/directory_grobid/windowscombined-$PARAS_ID" >> $TEMPFILE
 ((PARAS_ID++))
 sbatch $TEMPFILE
 sleep 0.1

done
