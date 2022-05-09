cat front2021.tsv | grep [a-zA-Z] |  sort -u | tr [:upper:] [:lower:] | perl screen_npljunk.pl > front2021_clean.tsv
