#!/bin/bash

SPLITTYPE=journal
JOBTYPE=sjbm
FRONTORBODY=body
ARTICLEDB=mag

#for YEAR in {2017..2017}
for YEAR in {1800..2021}
do
 TEMPSLURMFILE=./tempslurm/${JOBTYPE}${YEAR}.slurm
 rm -f $TEMPSLURMFILE
 echo
 echo "doing $YEAR."
 FILESFORYEAR=$(ls -l year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${YEAR}-* | wc -l)
 echo "found $FILESFORYEAR files for $YEAR."
 echo "writing $TEMPSLURMFILE"
 echo "#!/bin/bash -l" > $TEMPSLURMFILE
 echo "" >>$TEMPSLURMFILE
 echo "#SBATCH -p small" >> $TEMPSLURMFILE
 #echo "#SBATCH -t 96:00:00" >> $TEMPSLURMFILE
 echo "#SBATCH -J ${JOBTYPE}${YEAR}" >> $TEMPSLURMFILE
 echo "#SBATCH --array=1-${FILESFORYEAR}" >>$TEMPSLURMFILE
 echo "" >> $TEMPSLURMFILE
 echo "FILE_ID=\$(( (\$SLURM_ARRAY_TASK_ID + 999) ))" >>$TEMPSLURMFILE
 #echo "#SBATCH -o $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${YEAR}-\$FILE_ID.txt" >>$TEMPSLURMFILE
 echo "" >> $TEMPSLURMFILE
 echo "perl $NPL_BASE/nplmatch/process_matches/score_matches.pl $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${YEAR}-\$FILE_ID.txt -body > $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_scored_${FRONTORBODY}_${ARTICLEDB}/year${YEAR}-\$FILE_ID.txt" >>$TEMPSLURMFILE
 echo "sbatching $TEMPSLURMFILE"
 chmod a+w $TEMPSLURMFILE
 sbatch $TEMPSLURMFILE
done

