#!/bin/bash -l

TEMPFILE=./slurmFile.slurm

for year in {1800..2021}
 do
 printf "doing $year\n"

 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p large" >> $TEMPFILE
 echo "#SBATCH -J jou-${year}" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "cat matchedjournals_magnameNODUPES.tsv | perl terracenpl.pl $year > journalbyrefyear_j/journalfront_$year.tsv" >> $TEMPFILE
 sbatch $TEMPFILE
done





##$ -t 1800-2019
#SBATCH -a 0-220

##$ -j y
#SBATCH -o terracejournal-%j.out

##$ -N terracejournal
#SBATCH -J terracejournal

##$ -P marxnsf1
#
#chmod 664 $SGE_STDOUT_PATH
#chmod 664 $SGE_STDERR_PATH
#
#cat matchedjournals_magnameNODUPES.tsv | terracenpl.pl $SGE_TASK_ID > journalbyrefyear/journalfront_$SGE_TASK_ID.tsv
#YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))
#
#cat matchedjournals_magnameNODUPES.tsv | perl terracenpl.pl $YEAR_ID > journalbyrefyear_j/journalfront_$YEAR_ID.tsv

