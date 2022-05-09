!cut -f1,2,10,19 scored_front_pubmed_bestonly.tsv > scored_front_pubmed_bestonlyshort.tsv
import delimited using scored_front_pubmed_bestonlyshort.tsv, clear
rename v1 reftype
*rename __us4484308 pmid
rename v3 pmid
destring pmid, replace force
rename v2 confscore
destring confscore, replace force
drop if missing(confscore)
//drop if confscore<3
replace confscore = 10 if confscore>10
rename v4 patent
drop if length(patent)>20
replace patent = lower(trim(patent))
replace patent = regexs(1) if regexm(patent, "__us([0-9]*)")
replace patent = regexs(1) if regexm(patent, "us([0-9]*)")
replace patent = regexs(1) if regexm(patent, "^0*(.*)")
drop if missing(patent)
gen patnum = patent
merge m:1 patnum using ../../patents/googpat/1835-2019patgrantyears, keep(1 3) nogen
merge m:1 patnum using ../../patents/googpat/intlpatappyear, keep(1 3) nogen
replace grantyear = appyear if missing(grantyear)
destring patnum, gen(patint) force
replace grantyear = 2019 if patint>10165721 & patint<10524402
replace grantyear = 2020 if patint>10524402 & !missing(patnum)
drop patnum
merge m:1 pmid using ../../pubmed/overall_dates_2019, keep(1 3) nogen keepusing(year)
drop if year>grantyear+10 & !missing(grantyear) & !missing(year)
drop patint grantyear year
sort patent pmid confscore
drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop
* some cruft, not sure why
drop if length(reftype)>3
replace reftype = "exm" if regexm(patent, "-") & reftype!="app"
replace reftype = "app" if reftype=="oth"
compress reftype
* drop <3, flatten >10
gen uspto = !regexm(patent, "\-")
compress
sort pmid patent confscore
drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
save scored_front_pubmed_bestonlyexportincludeconf12, replace
drop if confscore<3
save scored_front_pubmed_bestonlyexport, replace
use scored_front_pubmed_bestonlyexport, clear
* prepare the full table with all matches + npl line
export delimited using scored_front_pubmed_bestonlyexport.tsv, delim(tab) replace
!cp scored_front_pubmed_bestonlyexport.tsv ~/sccpc/transfer



// !cut -f1,2,10,19 scored_front_pubmed_bestonly.tsv > scored_front_pubmed_bestonlyshort.tsv
// import delimited using scored_front_pubmed_bestonlyshort.tsv, clear
// rename v1 reftype
// rename v3 pmid
// destring pmid, replace force
// rename v2 confscore
// destring confscore, replace force
// drop if missing(confscore)
// drop if confscore<3
// replace confscore = 10 if confscore>10
// rename v4 patent
// drop if length(patent)>20
// replace patent = lower(trim(patent))
// replace patent = regexs(1) if regexm(patent, "__us([0-9]*)")
// replace patent = regexs(1) if regexm(patent, "us([0-9]*)")
// replace patent = regexs(1) if regexm(patent, "^0*(.*)")
// drop if missing(patent)
// sort patent pmid confscore
// drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
// duplicates drop
// * some cruft, not sure why
// drop if length(reftype)>3
// replace reftype = "exm" if regexm(patent, "-") & reftype!="app"
// replace reftype = "app" if reftype=="oth"
// compress reftype
// * drop <3, flatten >10
// gen uspto = !regexm(patent, "\-")
// sort pmid patent confscore
// drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
// compress
// save scored_front_pubmed_bestonlyexport, replace
// use scored_front_pubmed_bestonlyexport, clear
// * prepare the full table with all matches + npl line
// export delimited using scored_front_pubmed_bestonlyexport.tsv, delim(tab) replace
// !cp scored_front_pubmed_bestonlyexport.tsv ~/sccpc/transfer
//
