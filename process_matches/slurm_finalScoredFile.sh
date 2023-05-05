#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### Command structure: sh slurm_parawindows.sh


year=2021

### set the file directory
dir=$(pwd)
filedir="$dir/scoredresults"

cat $filedir/scored_body_*_bestonlyexport*.tsv >> $filedir/scored_body_mag_bestonlyexportcombined${year}.tsv
cat $filedir/scored_front_*_bestonlyexport*.tsv >> $filedir/scored_front_mag_bestonlyexportcombined${year}.tsv
chmod 777 $filedir/scored*combined${year}.tsv



#TEMPFILE=./slurmfile.slurm
#NCLNPARAS=$(ls $fullpath/cleanparas-* | wc -l)
#CLNPARAS_ID=10001
#echo ""
#echo "The number of cleanparas- files to process is $NCLNPARAS"
#
#for i in $fullpath/cleanparas-*
#do
# s=$(eval echo ${i:65:20} | sed -e "s/\///")
# echo "doing $s"
# echo "#!/bin/bash" > $TEMPFILE
# echo "#SBATCH -p small" >> $TEMPFILE
# echo "#SBATCH -J win$CLNPARAS_ID" >> $TEMPFILE
# echo "#SBATCH -t 12:00:00" >> $TEMPFILE
# echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
# echo "module load perl5-libs" >> $TEMPFILE
# echo "perl $directory/patentscripts/$frontorintext/parajustdumpyearwindows.pl $fullpath/cleanparas-$CLNPARAS_ID > $fullpath/windows-$CLNPARAS_ID" >> $TEMPFILE
# echo "chmod 777 $fullpath/windows-$CLNPARAS_ID" >> $TEMPFILE
# ((CLNPARAS_ID++))
# sbatch $TEMPFILE
# sleep 0.1
#done
