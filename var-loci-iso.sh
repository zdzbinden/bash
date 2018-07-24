#!/bin/bash

### USAGE: ./var-loci-iso.sh <file> <min SNPS>

### file should be in the .loci format
### min SNPs is equal to the minimum number of SNPs desired in the returned loci

mkdir var-loci-iso.output
cp var-loci-iso.sh var-loci-iso.output
cp $1 var-loci-iso.output
cd var-loci-iso.output



loci=`tac $1 | sed -r '/\/\// i\!!' | sed -n -r "/\/\/(\s*\*+\s*){"$2",}/,/\!\!/p" | tac | egrep -v '!!' | grep // | wc -l`

echo "We have found  $loci total loci with at least $2 SNPs in the file $1"


#Isolate block of sequences

tac $1 | awk 'BEGIN {x=0; y=0} {if ($0 ~ /\/\/(\s*\*+\s*){'''$2''',}/) {y=y+1; print $0 > y".locus"; x=1} else if (x == 1 && $1 ~ /\>/) {print $0 >> y".locus"} else {(x=0)}}'

#Reverse order of lines in the files created above
locus=`ls | grep .locus | wc -l`

echo "Program check ... The number $loci should be equal to $locus, if not this program is fucking up..."

mkdir $loci.loci.$2.SNPS
mv *.locus $loci.loci.$2.SNPS
cd $loci.loci.$2.SNPS

for i in `seq 1 $locus`; do
	tac $i.locus > $i.loci
done
rm *.locus

cd ..
mv  $loci.loci.$2.SNPS ..
cd ..
rm -r var-loci-iso.output

echo "$loci with $2 snps separated into $loci .loci files and stored in the directory $loci.loci.$2.SNPS in your current directory"


#cat $1 | awk 'BEGIN {FS=""; x=1} {if ($1 ~ />/) {for (i='''$start'''-1; i<=NF; i++) printf "%s%c",$i, (i=='''$start'''-1)?ORS:OFS=" " >> x".txt"} else {x=x+1}}'

#Move isolated loci to a directory called 'loci'

#mkdir loci
#mv *.txt loci
#LOCI=`ls loci | wc -w`
#cd loci
