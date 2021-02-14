#!/bin/bash

pwdirectory=$(pwd)

echo "Now un-taring"
data2=$(find $pwdirectory -type f -name "*.tar*")

for file in $data2
do
	cd "$(find $file -printf '%h' -quit)"
	tar -xjvf "$file"
	echo "untarring $file"
done

echo "Done untarring!"
