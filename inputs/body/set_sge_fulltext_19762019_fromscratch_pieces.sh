#!/bin/bash

mkdir fulltext_19762019_fromscratch_pieces/old
mv fulltext_19762019_fromscratch_pieces/*FILTERED fulltext_19762019_fromscratch_pieces/old
for filename in fulltext_19762019_fromscratch_pieces/*WINDOWS; do
 echo "doing $filename"
 qsub -N ext$year -o ${filename}FILTERED ./frankenfilter.pl "$filename" 
done


