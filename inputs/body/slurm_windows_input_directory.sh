#!/bin/bash 
directory=$1

echo $directory
TEMPFILE=./slurmfile.slurm
NPARAS=$(ls ./$directory/paras* | wc -l)
echo $NPARAS
PARAS_ID=10001
for i in ./$directory/paras*
do
 echo "doing $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p large" >> $TEMPFILE
 echo "#SBATCH -J $PARAS_ID-genwindows" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "perl $NPL_BASE/nplmatch/inputs/body/parajustdumpyearwindows.pl $NPL_BASE/nplmatch/inputs/body/$directory/cleanparas-$PARAS_ID > $NPL_BASE/nplmatch/inputs/body/$directory/windows-$PARAS_ID">>$TEMPFILE
 ((PARAS_ID++))
 sbatch $TEMPFILE
 sleep 0.1
done







