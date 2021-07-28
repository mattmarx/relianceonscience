
for x in {10001..10410}
do
 echo "DOING gocr $x"
 python ../multi_proc_prog.py fulltext_gocr/grobidfulltextinput-$x fulltext_gocrOUT/grobidfulltextoutput-$x
done


for x in {10001..10410}
do
 echo "DOING g19762004 $x"
 python ../multi_proc_prog.py fulltext_g19762004/grobidfulltextinput-$x fulltext_g19762004OUT/grobidfulltextoutput-$x
done

for x in {10001..10783}
do
 echo "DOING u20052019 $x"
 python ../multi_proc_prog.py fulltext_u20052019/grobidfulltextinput-$x fulltext_u20052019OUT/grobidfulltextoutput-$x
done
