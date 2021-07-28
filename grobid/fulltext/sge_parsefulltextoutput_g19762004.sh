#!/bin/bash -l

#$ -t 10001-10410
#$ -j y
#$ -N parsegrobid
#$ -l h_rt=12:00:00
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


/projectnb/marxnsf1/dropbox/bigdata/nplmatch/grobid/parsegrobidoutput.pl /projectnb/marxnsf1/dropbox/bigdata/nplmatch/grobid/fulltext/fulltext_g19762004OUT/grobidfulltextoutput-$SGE_TASK_ID > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/grobid/fulltext/fulltext_g19762004PARSED/grobidfulltextparsed-$SGE_TASK_ID


