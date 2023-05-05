#!/bin/bash

for ((i=1800; i<=2022; i++))
do

 TEMPFILE=./slurmfile.slurm
 echo "doing the year $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge,large" >> $TEMPFILE
 echo "#SBATCH -J OaTr$i" >> $TEMPFILE
 echo "#SBATCH -t 14-00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "grep '^$i' openalexoneline.tsv > openalexbyyear/oa_$i.tsv" >> $TEMPFILE
 echo "chmod 777 openalexbyyear/oa_$i.tsv" >> $TEMPFILE
sbatch $TEMPFILE
sleep 0.1
done
