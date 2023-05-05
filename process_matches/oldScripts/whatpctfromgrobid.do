import delimited using scored_body_mag_bestonly.tsv, clear delim(tab)
rename v2 conf
rename v10 magid
rename v19 patent
rename v20 line

gen grobid = regexm(line, "__zqxGROBIDzqx__")
