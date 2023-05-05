global fromscratch 0
if ($fromscratch==1) {
 do exportmatches-bodywos.do
 do exportmatches-frontwos.do
}
use scored_body_wos_bestonlyexport, clear
gen body = 1
append using scored_front_wos_bestonlyexport
drop patnum
drop uspto
replace body = 0 if missing(body)
bys wosid patent: egen avgbody = mean(body)
gen wherefound = "both"
replace wherefound = "bodyonly" if avgbody==1
replace wherefound = "frontonly" if avgbody==0
drop body
drop avgbody
* international patents don't count toward body, not a fair comparison
replace wherefound = "" if regexm(patent, "-")
gen typexm = reftype=="exm"
bys wosid patent: egen evertypexm = max(typexm)
replace reftype = "exm" if evertypexm==1
gen typeapp = reftype=="app"
bys wosid patent: egen evertypeapp = max(typeapp)
replace reftype = "app" if evertypeapp==1
drop typeapp typexm evertype*
replace patent = regexs(1) if regexm(lower(patent), "__us(.*)")
sort wosid patent confscore
drop if wosid==wosid[_n+1] & patent==patent[_n+1] & confscore<=confscore[_n+1]
duplicates drop
gen uspto = !regexm(patent, "-")
save scored_both_wos_bestonlyexport, replace
export delimited using scored_both_wos_bestonlyexport.tsv, replace delim(tab)
!cp scored_both_wos_bestonlyexport.tsv ~/sccpc/

