#!/bin/bash 
### #!/bin/bash -l

### #$ -j y
#SBATCH -o splittitle-%j.out


### #$ -N splittitle_body
#SBATCH -J splittitle_body

### #$ -l h_rt=48:00:00
#SBATCH -t 48:00:00

### #$ -hold_jid terracebody,terracewos,terracemag,terracepubmed
###SBATCH --depend=terracebody,terracewos,terracemag,terracepubmed

### #$ -P marxnsf1
#SBATCH --wckey=marxnfs1


### chmod 664 $SGE_STDOUT_PATH
# standard out is current directory unless you change it 
### chmod 664 $SGE_STDERR_PATH
#  standard out is current directory unless you change it 

### #$ -t 1800-2019
#SBATCH --array=0-220
YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

### $NPL_BASE/nplmatch/splittitle_patent/splittitle_body.pl $SGE_TASK_ID
perl $NPL_BASE/nplmatch/splittitle_patent/splittitle_body.pl $YEAR_ID

