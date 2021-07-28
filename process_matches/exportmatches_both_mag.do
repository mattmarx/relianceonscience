global mag ~/dropbox/bigdata/mag/dta
global fromscratch 0
global export 1
if ($fromscratch==1) {
 do exportmatches_bodymag.do
 do exportmatches_frontmag.do
}
use scored_body_mag_bestonlyexport, clear
// gen uspto = 1
gen body = 1
append using scored_front_mag_bestonlyexport
capture drop uspto
replace body = 0 if missing(body)
replace patent = regexs(1) + regexs(2) if regexm(patent, "(__US)\-(.*)\-.*")
replace patent = "__US-" + regexs(1) if regexm(patent, "US(.*)")
replace patent = "__US-" + regexs(1) if regexm(patent, "__US(.*)")
replace patent = "__US-" + regexs(1) if regexm(patent, "US\-\-(.*)")
replace patent = "__US-" + regexs(1) if regexm(patent, "US--(.*)")
replace patent = regexs(1) if regexm(patent, "(.*)__$")
replace patent = regexs(1) if regexm(patent, "^__(.*)")
replace patent = upper(patent)
gen uspto = regexm(patent, "^US")
// gen patdigits = regexs(1) if regexm(patent, "US-([0-9]+)")
// replace patent = "US-PP" + patdigits if length(patdigits)==5 & year>grantyear+3
// replace grantyear = 2020 if length(patdigits)==5 & year>grantyear+3
// replace patent = "US-H" + patdigits if length(patdigits)==4 & year>grantyear+3
// replace grantyear = 2020 if length(patdigits)==4 & year>grantyear+3
// drop patdigits
// replace patent = "__US" + patent if uspto==1 & !regexm(patent, "__US")
// replace patent = "__US" + regexs(1) if regexm(patent, "__USUS(.*)")
bys magid patent: egen avgbody = mean(body)
gen wherefound = "both"
replace wherefound = "bodyonly" if avgbody==1
replace wherefound = "frontonly" if avgbody==0
drop body
drop avgbody
// duplicates drop
* international patents don't count toward body, not a fair comparison
// replace wherefound = "" if uspto==0
* if any of the cites say examiner then assume that
gen typexm = reftype=="exm"
bys magid patent: egen evertypexm = max(typexm)
replace reftype = "exm" if evertypexm==1
* if any of the cites say applicant then assume that
gen typeapp = reftype=="app"
bys magid patent: egen evertypeapp = max(typeapp)
replace reftype = "app" if evertypeapp==1
drop typeapp typexm evertype*
// duplicates drop
// drop cpc oecd_field v5
sort magid patent confscore
drop if magid==magid[_n+1] & patent==patent[_n+1] & confscore<=confscore[_n+1]
duplicates drop
compress
save scored_both_mag_bestonlyexport, replace
use  scored_both_mag_bestonlyexport, clear
keep if uspto==1
drop uspto
save scored_both_mag_bestonlyexportUSPTO, replace

if ($export==1) {
 * export the final file with DOIs and PMIDs
 use  scored_both_mag_bestonlyexport, clear
 joinby magid using $mag/magdoi, unmatched(master)
 drop _merge
 duplicates drop magid patent, force
 joinby magid using $mag/xwalkmagidpmid, unmatched(master)
 drop _merge
 duplicates drop magid patent, force
  * deal with duplicate PMIDs by combining
//  sort magid patent pmid
//  gen pmidcombo = pmid
//  replace pmidcombo = pmid[_n-1] + "," + pmid if magid==magid[_n-1] & patent==patent[_n-1]
//  drop if magid==magid[_n+1] & patent==patent[_n+1]
//  drop pmid
//  rename pmidcombo pmids
 compress
//  drop year author
 save scored_both_mag_doi_pmid_bestonlyexport, replace
 export delimited using scored_both_mag_doi_pmid_bestonlyexport.tsv, replace delim(tab)
 *!cp scored_both_mag_doi_pmid_bestonlyexport.tsv ~/sccpc/transfer/
}
