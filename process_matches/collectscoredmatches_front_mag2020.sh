cat $NPL_BASE/nplmatch/splittitle_articles/year_regex_scored_front_mag_lev/*.txt $NPL_BASE/nplmatch/splitpagevol_articles/year_regex_scored_front_mag_lev/*.txt  $NPL_BASE/nplmatch/splitjournal_articles/year_regex_scored_front_mag/*.txt |   sort -u > $NPL_BASE/nplmatch/process_matches/scored_front_mag2020.tsv
#cat $NPL_BASE/nplmatch/splittitle_articles/year_regex_scored_front_mag_lev/*.txt $NPL_BASE/nplmatch/splitpagevol_articles/year_regex_scored_front_mag_lev/*.txt  $NPL_BASE/nplmatch/splitjournal_articles/year_regex_scored_front_mag/*.txt | sed -e 's/	__us0*/	/' | sed -e 's/	0\+/	/g' | sed -e 's/	us0*/	/' |   sort -u > $NPL_BASE/nplmatch/process_matches/scored_front_mag.tsv


