#!/bin/bash
function show_time () {
	h=$1
	yD=8760 # 8760h commonyear
	printf '%dy %dw %dd %dh (%dh total)\n' $((h/yD)) $((h%yD/168)) $((h%168/24)) $((h%24)) $h
}

for file in *.smart.txt; do
	id=$(echo $file | cut -d'.' -f 1)
	hours=$(cat $file | grep "9 Power" | rev | cut -d ' ' -f 1 | rev)
	echo -n "$id has "
	show_time $hours
done
