#!/bin/sh

lon=$1
lat=$2
Lmin=1000000
for file in *.txt; do
	L=`echo $lon $lat | mapproject -fg -L$file | awk '{print int($3)}'`
	if [ $L -lt $Lmin ]; then
		Lmin=$L
		target=$file
	fi
done
echo "$target was $Lmin m away"
