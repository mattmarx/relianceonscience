! cut -f10,11,16,19 scored_front_mag_bestonly.tsv > scored_front_mag_yearauthorpatent.tsv

import delimited using ../grobid/patauthoryearonly.tsv, clear
rename v1 patent
replace patent = trim(patent)
replace patent = regexs(1) if regexm(patent, "^__US(.*)")
replace patent = regexs(1) if regexm(patent, "^0+(.*)")
rename v2 author
drop if length(author)>50
recast str50 author
replace author = trim(author)
replace author = lower(author)
rename v3 year
duplicates drop
save grobidpatauthoryearonly, replace

import delimited using scored_front_mag_yearauthorpatent.tsv, clear
rename v1 magid
destring magid, replace
rename v2 year
destring year, replace force
drop if missing(year)
rename v3 author
replace author = regexs(1) if regexm(author, "(.*),.*")
replace author = trim(author)
rename v4 patent
joinby year author patent using grobidpatauthoryearonly
duplicates drop
gen reftype = "app"
gen confscore = 9
compress
replace patent = "__us" + patent
save grobidauthoryearalsofront, replace



