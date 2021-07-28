for GREEK in alpha beta delta gamma epsilon zeta theta iota kappa lambda rho sigma upsilon chi omega
do
#cat ../../../mag/txt/Papers.txt | cut -f1,5 | fgrep -f  magwith$GREEK.txt | cut -f2 > mag$GREEKtitles.txt
 join magwith$GREEK.txt ../../../mag/txt/papertitlesorted.txt > magtitle-$GREEK.txt
done

