#!/bin/bash 
fulltextdirectory=$1
windowdirectory=$2
echo $fulltextdirectory
echo $windowdirectory
TEMPFILE=./slurmfile.slurm
PARAS_ID=10001
for i in $NPL_BASE/nplmatch/inputs/body/$fulltextdirectory/window*
do 
 echo "doing $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p large" >> $TEMPFILE
 echo "#SBATCH -J cleanparas-$PARAS_ID" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "perl $NPL_BASE/nplmatch/grobid/window/onepatperlinewindowjeren.pl < $NPL_BASE/nplmatch/inputs/body/$fulltextdirectory/windows-$PARAS_ID > $NPL_BASE/nplmatch/grobid/window/$windowdirectory/windowscombined-$PARAS_ID">>$TEMPFILE
 ((PARAS_ID++))
 sbatch $TEMPFILE 
 sleep 0.1
done

