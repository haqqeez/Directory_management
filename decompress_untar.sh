#!/bin/bash

pwdirectory=$(pwd)

untar="true"


data=$(find $pwdirectory -type f -name "*.tar.bz2")

for session in $data
do
	bzip2 -vd $session
	echo "extracted data from $session"
done

echo "Done decompression!"


if [ "$untar" == "true" ]
then
	echo "Now un-taring"
	data2=$(find $pwdirectory -type f -name "*.tar")
	for file in $data2
	do
		cd "$(find $file -printf '%h' -quit)"
		tar -xvf "$file"
		echo "untarring $file"
	done
	echo "Done untarring!"
fi
