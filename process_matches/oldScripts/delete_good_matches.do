global mag ~/dropbox/bigdata/mag/dta
global fromscratch 0
global export 1
if ($fromscratch==1) {
 do exportmatches_bodymag2020.do
 do exportmatches_frontmag2020.do
}
use scored_body_mag_bestonlyexport, clear
append using scored_body_mag_bestonlyexport2020
// gen uspto = 1
gen body = 1
append using scored_front_mag_bestonlyexport
append using scored_front_mag_bestonlyexport2020
capture drop uspto
replace body = 0 if missing(body)

gen origpatent = patent
replace patent = upper(patent)
replace patent = regexs(1) if regexm(patent, "US-(US.*)")
replace patent = regexs(1) if regexm(patent, "(US.*[0-9])\-[A-Z]")
replace patent = regexs(1) + regexs(2) if regexm(patent, "(__US)\-(.*)\-.*")
replace patent = "__US-" + regexs(1) if regexm(patent, "(^RE[0-9])")
replace patent = "__US-" + regexs(1) if regexm(patent, "(^PP[0-9])")
replace patent = "__US-" + regexs(1) if regexm(patent, "(^D[0-9])")
replace patent = "__US-" + regexs(1) if regexm(patent, "US(.*)")
replace patent = "__US-" + regexs(1) if regexm(patent, "__US(.*)")
replace patent = "__US-" + regexs(1) if regexm(patent, "US\-\-(.*)")
replace patent = "__US-" + regexs(1) if regexm(patent, "US--(.*)")
replace patent = regexs(1) if regexm(patent, "(.*)__$")
replace patent = regexs(1) if regexm(patent, "^__(.*)")
gen uspto = regexm(patent, "^US")
*remove leading zeroes
replace patent = regexs(1) + "-" + regexs(2) if regexm(patent, "([a-zA-Z]+)\-0+(.*)")
// sort magid patent confscore 
// drop if magid==magid[_n+1] & patent==patent[_n+1] & confscore<=confscore[_n+1]
drop body
drop uspto
gen checkpat = patent
replace checkpat = "good" if regexm(checkpat, "^US\-[1-9][0-9]*$")
replace checkpat = "good" if regexm(checkpat, "^US\-[A-Z][0-9]*$")
replace checkpat = "us suffix" if regexm(checkpat, "^US\-[A-Z][0-9]*\-.*")
replace checkpat = "good" if regexm(checkpat, "^[A-Z][A-Z]\-[1-9][0-9]*\-[A-Z][0-9]$")
replace checkpat = "good" if regexm(checkpat, "^[A-Z][A-Z]\-[1-9][0-9]*\-[A-Z]$")
replace checkpat = "good" if regexm(checkpat, "^US\-RE[0-9]*$")
replace checkpat = "good" if regexm(checkpat, "^US\-PP[0-9]*$")
replace checkpat = "good" if regexm(checkpat, "^EP\-[1-9][0-9]*\-[A-Z][0-9]$")
drop if checkpat == "good"
save remaining_pat, replace
 export delimited using remaining_pat.tsv, replace delim(tab)
