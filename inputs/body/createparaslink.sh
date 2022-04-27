#!/bin/bash
directory=$1
echo $directory
t=10001
for i in ./$directory/*.txt
do 
ln $i ./$directory/paras-$t;
((t+=1));
echo $t
done
