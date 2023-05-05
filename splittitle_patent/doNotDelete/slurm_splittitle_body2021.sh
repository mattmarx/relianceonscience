#!/bin/bash

### $NPL_BASE/nplmatch/splittitle_patent/splittitle_body.pl $SGE_TASK_ID
#perl $NPL_BASE/nplmatch/splittitle_patent/splittitle_body.pl $YEAR_ID

TEMPFILE=./2021body/slurmTitle.slurm
NYRS=$(ls $NPL_BASE/nplmatch/inputs/body/fulltext_2021j/bodybyrefyear/*.tsv | wc -l)
PAT_ID=$(seq -f "%02g" 1800 $((NYRS+1800)))
array=($PAT_ID)
a=0
FIL_ID=1800

for i in $NPL_BASE/nplmatch/inputs/body/fulltext_2021j/bodybyrefyear/*.tsv
 do
  echo "doing $i"
  echo "#!/bin/bash" > $TEMPFILE
  echo "#SBATCH -p large" >> $TEMPFILE
  echo "#SBATCH -J bd_${array[${a}]}" >> $TEMPFILE
  echo "#SBATCH -t 12:00:00" >> $TEMPFILE
  echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
  echo "" >> $TEMPFILE
  echo "module load perl5-libs" >>$TEMPFILE
  echo "perl $NPL_BASE/nplmatch/splittitle_patent/splittitle_body.pl $FIL_ID" >> $TEMPFILE
  ((FIL_ID++))
  ((a++))
  sbatch $TEMPFILE
  sleep 0.1
 done
