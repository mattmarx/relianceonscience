!cut -f1,2,10,19 scored_front_wosOCR.tsv > scored_front_wosOCRshort.tsv
import delimited using scored_front_wosOCRshort.tsv, clear delim(tab)
replace patent = regexs(1) if regexm(patent, "__us(.*)")
replace patent = regexs(1) if regexm(patent, "us\-(.*)")
replace patent = "us-" + patent
duplicates drop
save scored_front_wosOCR, replace

!cut -f1,2,10,19 scored_front_wos_bestonly.tsv > scored_front_wos_bestonlyshort.tsv
import delimited using scored_front_wos_bestonlyshort.tsv, clear varnames(nonames)
append using scored_front_wosOCR
replace patent = upper(patent)
rename v1 reftype
*rename __us4484308 wosid
rename v3 wosid
rename v2 confscore
destring confscore, replace force
drop if missing(confscore)
drop if confscore<3
replace confscore = 10 if confscore>10
rename v4 patent
drop if length(patent)>20
replace patent = lower(trim(patent))
// replace patent = regexs(1) if regexm(patent, "__us([0-9]*)")
// replace patent = regexs(1) if regexm(patent, "us([0-9]*)")
// replace patent = regexs(1) if regexm(patent, "^0*(.*)")
replace patnum = regexs(1) if regexm(patent, "__(.*)__")
replace patnum = regexs(1) if regexm(patent, "US-([0-9]*)")

drop if missing(patent)
sort patent wosid confscore
drop if wosid==wosid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop
* some cruft, not sure why
drop if length(reftype)>3
replace reftype = "exm" if regexm(patent, "-") & reftype!="app"
replace reftype = "app" if reftype=="oth"
compress reftype
* drop <3, flatten >10
gen uspto = !regexm(patent, "US")
compress
save scored_front_wos_bestonlyexport, replace
use scored_front_wos_bestonlyexport, clear
* prepare the full table with all matches + npl line
export delimited using scored_front_wos_bestonlyexport.tsv, delim(tab) replace
!cp scored_front_wos_bestonlyexport.tsv ~/sccpc

