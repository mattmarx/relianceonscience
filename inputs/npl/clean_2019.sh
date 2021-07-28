cat npls.2019.tsv | grep [a-zA-Z] |  sort -u | tr [:upper:] [:lower:] | perl screen_npljunk.pl > npls.2019_clean.tsv
