global mag /home/fs01/mtm83/dropbox/bigdata/mag/dta
global patent /home/fs01/mtm83/dropbox/bigdata/patents/ 

!cut -f1,2,10,19 scored_front_magOCR.tsv > scored_front_magOCRshort.tsv
import delimited using scored_front_magOCRshort.tsv, clear delim(tab)
rename v4 patent 
replace patent = regexs(1) if regexm(patent, "__us(.*)")
replace patent = regexs(1) if regexm(patent, "us\-(.*)")
replace patent = "us-" + patent
duplicates drop
save scored_front_magOCR, replace

!cut -f1,2,10,19 scored_front_mag_bestonly.tsv > scored_front_mag_bestonlyshort.tsv
import delimited using scored_front_mag_bestonlyshort.tsv, clear
append using scored_front_magOCR
rename referencesource reftype
*rename __us4484308 magid
rename code magid
destring magid, replace force
rename confidence confscore
destring confscore, replace force
drop if missing(confscore)
//drop if confscore<3
replace confscore = 10 if confscore>10
rename patentid patent
drop if length(patent)>20
replace patent = upper(trim(patent))
// replace patent = regexs(1) if regexm(patent, "__us([0-9]*)")
// replace patent = regexs(1) if regexm(patent, "us([0-9]*)")
// replace patent = regexs(1) if regexm(patent, "^0*(.*)")
drop if missing(patent)
gen patnum = patent
replace patnum = regexs(1) if regexm(patent, "__(.*)__")
replace patnum = regexs(1) if regexm(patent, "US-([0-9]*)")
merge m:1 patnum using $patent/googpat/1835-2019patgrantyears, keep(1 3) nogen
merge m:1 patnum using $patent/googpat/intlpatappyear, keep(1 3) nogen
replace grantyear = appyear if missing(grantyear)
destring patnum, gen(patint) force
replace grantyear = 2019 if patint>10165721 & patint<10524402
replace grantyear = 2020 if patint>10524402 & !missing(patnum)
drop patnum
merge m:1 magid using $mag/magyear, keep(1 3) nogen
gen patdigits = regexs(1) if regexm(patent, "^__US-([0-9]+)")
* for now, move [postfix PP/H/D to start of patnum to match body.
* someday when we are pulling body & front from google, don't do any of this b/c they will match
replace patent = "__US-PP" + regexs(1) if regexm(patent, "^__US\-([0-9]+)\-P")
replace patent = "__US-H" + regexs(1) if regexm(patent, "^__US\-([0-9]+)\-H")
replace patent = "__US-D" + regexs(1) if regexm(patent, "^__US\-([0-9]+)\-D")
// replace patent = "__US-PP" + patdigits if length(patdigits)==5 & year>grantyear+3
// replace grantyear = 2020 if length(patdigits)==5 & year>grantyear+3
// replace patent = "__US-H" + patdigits if length(patdigits)==4 & year>grantyear+3
// replace grantyear = 2020 if length(patdigits)==4 & year>grantyear+3
replace confscore = confscore - 3 if year>grantyear+10 & !missing(grantyear) & !missing(year)
drop  grantyear year
replace patent = regexs(1) if regexm(patent, "^(__US-.*)-.*")
sort patent magid confscore
drop if magid==magid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop
drop if confscore<1
* some cruft, not sure why
drop if length(reftype)>3
// replace reftype = "exm" if regexm(patent, "-") & reftype!="app"
replace reftype = "app" if reftype=="oth"
compress reftype
* drop <3, flatten >10
// gen uspto = !regexm(patent, "\-")
compress
sort magid patent confscore
drop if magid==magid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop
drop appyear
drop patdigits patint
// drop year
compress
// save scored_front_mag_bestonlyexportincludeconf12, replace
// drop if confscore<3
save scored_front_mag_bestonlyexport, replace
// use scored_front_mag_bestonlyexport, clear
* prepare the full table with all matches + npl line
// export delimited using scored_front_mag_bestonlyexport.tsv, delim(tab) replace
// !cp scored_front_mag_bestonlyexport.tsv ~/sccpc/transfer

