#!/bin/sh
##USAGE: sh ./wgs.sh <numthread> <pair1> <pair2> <sample_name>

numthread=$1
pair1=$2
pair2=$3
sample_name=$4


bwa mem -t $numthread <path_to_folder>/Gmax_275_v2.0.fa $pair1 $pair2 > out.sam &&


java -jar <path_to_folder>/picard.jar SortSam I=out.sam O=sorted.bam SORT_ORDER=coordinate &&
java -jar <path_to_folder>/picard.jar FixMateInformation I=sorted.bam O=fixmate.bam &&
java -jar <path_to_folder>/picard.jar MarkDuplicates I=fixmate.bam O=${sample_name}.bam M=metrics &
