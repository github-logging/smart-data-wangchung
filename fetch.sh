#!/bin/bash
show_time() {
        h=$1
        yD=8760 # 8760h commonyear
        printf '%dy %dw %dd %dh (%dh total)\n' $((h/yD)) $((h%yD/168)) $((h%168/24)) $((h%24)) $h
}
diskjson() {
	ssh $1 "lsblk -nd -J -o NAME,MODEL" | jq -r '.blockdevices[] | @base64'
}
dump() {
	for row in $(diskjson $1); do
		#echo $row
		_jq() {
			echo ${row} | base64 --decode | jq -r ${1}
		}
		disk=$(_jq '.name')
		file=$(_jq '.model').smart.txt
		#echo $file
		ssh $1 "smartctl --all /dev/$disk" | cat - > $file
		hours=$(cat $file | grep "9 Power" | rev | cut -d ' ' -f 1 | rev)
		commitMessage=$(show_time $hours)
		git add $file
		git commit -a -m "$commitMessage"
	done
}
sed -rn 's/^\s*Host\s+(.*)\s*/\1/ip' ~/.ssh/config |\
while read sshHost; do
	dump $sshHost
done
git push
