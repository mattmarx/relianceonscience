global mag /home/fs01/mtm83/dropbox/bigdata/mag/dtafinal
global fromscratch 0
global export 1
if ($fromscratch==1) {
 do exportmatches_bodymag2020.do
 do exportmatches_frontmag2020.do
 do exportmatches_bodymag2021.do
 do exportmatches_frontmag2021.do
}
use scored_body_mag_bestonlyexport, clear
append using scored_body_mag_bestonlyexport2020
append using scored_body_mag_bestonlyexport2021
// gen uspto = 1
gen body = 1
append using scored_front_mag_bestonlyexport
append using scored_front_mag_bestonlyexport2020
append using scored_front_mag_bestonlyexport2021
capture drop uspto
replace body = 0 if missing(body)

* remove duplicate US patent numbers - july 2021 retraction
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
duplicates drop

* world patent organizsation sometimes has buggy patent numbers; get rid of them
gen jpwonumber = "na"
replace jpwonumber = regexs(1) if regexm(patent, "WO([0-9]*\-[A-Z][1-9])")
replace jpwonumber = regexs(1) if regexm(patent, "WO\-([0-9]*\-[A-Z][1-9])")
gsort jpwonumber magid -patent confscore
drop if magid == magid[_n+1] & patent == patent[_n+1] & confscore<=confscore[_n+1]	
drop if jpwonumber==jpwonumber[_n+1] & magid==magid[_n+1] & jpwonumber!="na"
drop jpwonumber


bys magid patent: egen avgbody = mean(body)
gen wherefound = "both"
replace wherefound = "bodyonly" if avgbody==1
replace wherefound = "frontonly" if avgbody==0
drop body
drop avgbody
duplicates drop
// duplicates drop
* international patents don't count toward body, not a fair comparison
// replace wherefound = "" if uspto==0
* if any of the cites say examiner then assume that

replace reftype = "exm" if uspto==0 & reftype!="app"
replace reftype = "app" if uspto==1 & reftype!="exm"

gen origreftype = reftype
gen typexm = origreftype=="exm"
bys magid patent: egen evertypexm = max(typexm)
replace reftype = "exm" if evertypexm==1
* if any of the cites say applicant then assume that, overriding examiner
gen typeapp = origreftype=="app"
bys magid patent: egen evertypeapp = max(typeapp)
replace reftype = "app" if evertypeapp==1
drop typeapp typexm evertype* origreftype
duplicates drop
// duplicates drop
// drop cpc oecd_field v5


compress
save scored_both_mag_bestonlyexport2021, replace
export delimited using scored_both_mag_bestonlyexport2021.tsv, replace delim(tab)
//
// use  score d_both_mag_bestonlyexport, clear
// keep if uspto==1
// drop uspto
// save scored_both_mag_bestonlyexportUSPTO, replace

if ($export==1) {
 * export the final file with DOIs and PMIDs
 use  scored_both_mag_bestonlyexport2021, clear
 joinby magid using $mag/magdoi, unmatched(master)
 drop _merge
//  duplicates drop magid patent, force
 joinby magid using $mag/magpmid, unmatched(master)
 drop _merge
//  duplicates drop magid patent, force
  * deal with duplicate PMIDs by combining
//  sort magid patent pmid
//  gen pmidcombo = pmid
//  replace pmidcombo = pmid[_n-1] + "," + pmid if magid==magid[_n-1] & patent==patent[_n-1]
//  drop if magid==magid[_n+1] & patent==patent[_n+1]
//  drop pmid
//  rename pmidcombo pmids
 compress
//  drop year author
 save scored_both_mag_doi_pmid_bestonlyexport2021, replace
 export delimited using scored_both_mag_doi_pmid_bestonlyexport2021.tsv, replace delim(tab)
//  !cp scored_both_mag_doi_pmid_bestonlyexport.tsv ~/sccpc/transfer/
}
