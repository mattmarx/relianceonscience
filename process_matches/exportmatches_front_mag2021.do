
!cut -f1,2,10,19 scored_front_mag_bestonly2021.tsv > scored_front_mag_bestonly2021short.tsv
import delimited using scored_front_mag_bestonly2021short.tsv, clear delim(tab)
drop if _n==1
rename v1 reftype
*rename __us4484308 magid
rename v3 magid
destring magid, replace force
rename v4 patent
rename v2 confscore
destring confscore, replace force
drop if missing(confscore)
drop if missing(patent)
drop if missing(magid)
//drop if confscore<3
replace confscore = 10 if confscore>10
drop if length(patent)>20
drop if confscore<1
* some cruft, not sure why
drop if length(reftype)>3
replace patent = upper(trim(patent))
replace patent = regexs(1) if regexm(patent, "__(.*)")
replace patent = "US-" + patent if regexm(patent, "^[0-9]")
replace patent = "US-" + patent if regexm(patent, "US([0-9].*)")
// replace reftype = "exm" if !regexm(patent, "US-") & reftype!="app"
replace reftype = "app" if reftype=="oth"
compress reftype
* remove leading zeroes
// replace patent = regexs(1) if regexm(patent, "__us([0-9]*)")
// replace patent = regexs(1) if regexm(patent, "us([0-9]*)")
// replace patent = regexs(1) if regexm(patent, "^0*(.*)")

// replace patent = "__US-PP" + patdigits if length(patdigits)==5 & year>grantyear+3
// replace grantyear = 2020 if length(patdigits)==5 & year>grantyear+3
// replace patent = "__US-H" + patdigits if length(patdigits)==4 & year>grantyear+3
// replace grantyear = 2020 if length(patdigits)==4 & year>grantyear+3
sort patent magid confscore
drop if magid==magid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop
* often get duplicates with different reftype, assume app if we have it
* drop <3, flatten >10
// gen uspto = !regexm(patent, "\-")
compress
sort magid patent confscore
drop if magid==magid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop
// drop year
compress
// drop if confscore<3
save scored_front_mag_bestonlyexport2021, replace
// use scored_front_mag_bestonlyexport, clear
* prepare the full table with all matches + npl line
// export delimited using scored_front_mag_bestonlyexport.tsv, delim(tab) replace
// !cp scored_front_mag_bestonlyexport.tsv ~/sccpc/transfer

