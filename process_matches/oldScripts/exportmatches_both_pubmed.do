global fromscratch 0
if ($fromscratch==1) {
 do exportmatches-bodypubmed.do
 do exportmatches-frontpubmed.do
}
use scored_body_pubmed_bestonlyexport, clear
gen body = 1
append using scored_front_pubmed_bestonlyexport
replace patent = "__US" + patent if !regexm(upper(patent), "[A-Z]")
replace patent = upper(patent)
replace patent = "__US" + regexs(1) if regexm(patent, "__USUS(.*)")
replace uspto = 1 if missing(uspto)
replace body = 0 if missing(body)
bys pmid patent: egen avgbody = mean(body)
gen wherefound = "both"
replace wherefound = "bodyonly" if avgbody==1
replace wherefound = "frontonly" if avgbody==0
drop body
drop avgbody
// duplicates drop
* international patents don't count toward body, not a fair comparison
replace wherefound = "" if regexm(patent, "-")
gen typexm = reftype=="exm"
bys pmid patent: egen evertypexm = max(typexm)
replace reftype = "exm" if evertypexm==1
gen typeapp = reftype=="app"
bys pmid patent: egen evertypeapp = max(typeapp)
replace reftype = "app" if evertypeapp==1
drop typeapp typexm evertype*
// duplicates drop
// drop cpc oecd_field v5
sort pmid patent confscore
drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop
compress
save scored_both_pubmed_bestonlyexport, replace
export delimited using scored_both_pubmed_bestonlyexport.tsv, replace delim(tab)
!cp scored_both_pubmed_bestonlyexport.tsv ~/sccpc/transfer/
keep if uspto==1
drop uspto
save scored_both_pubmed_bestonlyexportUSPTO, replace



// global fromscratch 0
// if ($fromscratch==1) {
//  do exportmatches-bodypubmed.do
//  do exportmatches-pubmedplusintl.do
// }
// use scored_bodypubmed_bestonlyexport, clear
// gen body = 1
// append using scoredpubmed_bestonlyexport
// drop uspto
// replace body = 0 if missing(body)
// bys pmid patent: egen avgbody = mean(body)
// gen wherefound = "both"
// replace wherefound = "bodyonly" if avgbody==1
// replace wherefound = "frontonly" if avgbody==0
// drop body
// drop avgbody
// * international patents don't count toward body, not a fair comparison
// replace wherefound = "" if regexm(patent, "-")
// gen typexm = reftype=="exm"
// bys pmid patent: egen evertypexm = max(typexm)
// replace reftype = "exm" if evertypexm==1
// gen typeapp = reftype=="app"
// bys pmid patent: egen evertypeapp = max(typeapp)
// replace reftype = "app" if evertypeapp==1
// drop typeapp typexm evertype*
// sort pmid patent confscore
// drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
// duplicates drop
// sort pmid patent confscore
// drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
// duplicates drop
// gen uspto = !regexm(patent, "\-")
// save scoredbothpubmed_bestonlyexport, replace
// export delimited using scoredbothpubmed_bestonlyexport.tsv, replace delim(tab)
// !cp scoredbothpubmed_bestonlyexport.tsv ~/sccpc/transfer/
//
