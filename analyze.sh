#!/bin/bash
file=$1
git log --format=%H --reverse | while read hash; do
	v=$(git show $hash:$1 2> /dev/null | grep "231 SSD_Life_Left")
	if echo $v | grep -q "231"; then
		d=$(git show -s --format=%ct $hash 2> /dev/null)
		vv=$(echo $v|rev|cut -d ' ' -f 1 | rev)
		echo "$d,$vv"
	fi
done
