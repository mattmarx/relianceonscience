cat front2020.tsv | grep [a-zA-Z] |  sort -u | tr [:upper:] [:lower:] | perl screen_npljunk.pl > front2020_clean.tsv
