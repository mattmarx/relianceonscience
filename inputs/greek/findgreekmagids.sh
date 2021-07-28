#for GREEK in lambda
for GREEK in alpha beta delta gamma epsilon zeta theta iota kappa lambda rho sigma upsilon chi omega
do
cat ../../recall/scoredmag20190428_bestonly.tsv | cut -f2,10,20 | grep "^10" | cut -f2,3 | grep -P "\W$GREEK\W" | cut -f1 | sort -u > magwith$GREEK.txt
done

