#!/bin/bash

### this slurm script scores the output that was created and saved in the year_regex_output_body_ARTICLEDB
### directory. The resulting files will be saved in year_regex_scored_body_ARTICLEDB directory

### Script usage: sh slurm_scoring_body.sh. In order to use different databases, make sure
### to change the ARTICLEDB variable below. The $year variable is obtained from the config.pl
### script that you should have already modified to the current year. If you have not done
### this already, please navigate to $NPL_BASE/nplmatch/config.pl and change the year variable
### to the current year. Not performing this step will result in no matches for the current year.


SPLITTYPE=journal
JOBTYPE=sjbo # sjbm or sjbo
FRONTORBODY=body
ARTICLEDB=oa # mag or oa or wos

year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)

#for ((i=1984; i<=$year; i++))
#for ((i=1800; i<=$year; i++))
for i in 1985 1988 1989 1990 1992 1993 1994 1995 1997 1998 1999 2000 2002 2003 2004 2008 2009 2010
do
 TEMPSLURMFILE=./tempslurm/${JOBTYPE}${i}.slurm
 echo
 echo "doing $i"
 FILESFORYEAR=$(ls -l year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${i}-* | wc -l)
 echo "found $FILESFORYEAR files for $i"
 echo "writing $TEMPSLURMFILE"
 echo "#!/bin/bash -l" > $TEMPSLURMFILE
 echo "" >>$TEMPSLURMFILE
# echo "#SBATCH -p xlarge,small" >> $TEMPSLURMFILE
echo "#SBATCH -p xlarge,small,large" >> $TEMPSLURMFILE
 echo "#SBATCH -t 96:00:00" >> $TEMPSLURMFILE
 echo "#SBATCH -J ${JOBTYPE}${i}" >> $TEMPSLURMFILE
 echo "#SBATCH --array=1-${FILESFORYEAR}" >>$TEMPSLURMFILE
 echo "" >> $TEMPSLURMFILE
 echo "FILE_ID=\$(( (\$SLURM_ARRAY_TASK_ID + 999) ))" >>$TEMPSLURMFILE
 echo "" >> $TEMPSLURMFILE
 echo "module load perl5-libs" >> $TEMPSLURMFILE
 echo "perl $NPL_BASE/nplmatch/process_matches/score_matches.pl $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${i}-\$FILE_ID.txt -body > $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_scored_${FRONTORBODY}_${ARTICLEDB}/year${i}-\$FILE_ID.txt" >>$TEMPSLURMFILE
 echo "chmod 777 $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_scored_${FRONTORBODY}_${ARTICLEDB}/year${i}-\$FILE_ID.txt" >> $TEMPSLURMFILE
 echo "sbatching $TEMPSLURMFILE"
 sbatch $TEMPSLURMFILE
done

