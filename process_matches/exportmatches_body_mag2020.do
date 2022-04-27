!cut -f1,2,10,19 scored_body_mag_bestonly2020.tsv > scored_body_mag_bestonly2020short.tsv
import delimited using scored_body_mag_bestonly2020short.tsv, clear delim(tab)

capture rename ref v1 
capture rename conf v2 
capture rename code v3 
capture rename pat v4 

rename v1 reftype
drop if length(reftype)>3
// replace reftype = "app" if reftype!="exm"
compress reftype
rename v2 confscore
rename v3 magid
rename v4 patent
replace patent = upper(patent)
gen uspto = regexm(patent, "__US")
replace patent = regexs(1) if regexm(patent, "^__(.*)")
// replace patent = "__US" + patent if !regexm(patent, "__US")
*drop if confscore<3
destring confscore, replace force
drop if missing(confscore)
replace confscore = 10 if confscore>10
replace patent = lower(trim(patent))
drop if missing(patent)
compress
* downweight cites where paper is far in the future
*remove leading zeroes
replace patent = regexs(1) + regexs(2) if regexm(patent, "(__[a-zA-Z]+)0+(.*)")
* downweight cites where it is a really unusual cpc/oecd mapping and confidence is low
drop if confscore<1
drop if missing(patent)
drop if missing(magid)
duplicates drop
compress
destring magid, replace
save scored_body_mag_bestonlyexport2020, replace
/*
use scored_body_mag_bestonlyexport, clear
export delimited using scored_body_mag_bestonlyexport.tsv, replace delim(tab)
!cp scored_body_mag_bestonlyexport.tsv ~/sccpc/



