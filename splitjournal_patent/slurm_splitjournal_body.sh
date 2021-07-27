#!/bin/bash 
### #!/bin/bash -l

#SBATCH -o splitjournal-%j.out
### #$ -j y

#SBATCH -J splitjournalbody
### #$ -N splitjournalbody

#SBATCH -t 12:00:00
### #$ -l h_rt=12:00:00

#SBATCH --wckey=marxnfs1
### #$ -P marxnsf1

#SBATCH --depend=terracejournal
### #$ -hold_jid terracejournal

#SBATCH --export=ALL
### #$ -V

### chmod 664 $SGE_STDOUT_PATH
# standard out is current directory unless you change it 
### chmod 664 $SGE_STDERR_PATH
#  standard out is current directory unless you change it 

#SBATCH --array=0-220
YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))
### #$ -t 1800-2019

perl $NPL_BASE/nplmatch/splitjournal_patent/splitjournal_body.pl $YEAR_ID
### $NPL_BASE/nplmatch/splitjournal_patent/splitjournal_body.pl $SGE_TASK_ID
