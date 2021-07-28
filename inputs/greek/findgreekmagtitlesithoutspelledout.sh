for GREEK in alpha beta delta gamma epsilon zeta theta iota kappa lambda rho sigma upsilon chi omega
do
 cat magtitle-$GREEK.txt | grep -v $GREEK > magtitlewithoutspelledout-$GREEK.txt
done

