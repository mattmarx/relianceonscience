# clean paragraphs
# sge tag is "cleanparas"
rm -f fulltext_*/cleanparas-* 
sbatch slurm_cleanparas_ft2020.sh

# generate windows
# sge tag is "genwindow"
rm -f fulltext_*/windows-*
sbatch slurm_windows_ft2020

#frankenfilter
#sge tag is "frankenfilter"
rm -f fulltext_*/filtered-*
sbatch slurm_npls_ft2020.sh

# assemble
sbatch -J assemblebody --depend=frankenfilter assemblebody.sh

# terrace
rm -f bodybyrefyear/*.tsv
sbatch slurm_terracebody.sh

