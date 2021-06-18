#!/bin/bash

# this script simply checks whether or not sessions in a directory have been tarred

initials='ZHA'

pwdirectory=$(pwd)
data=$(find $pwdirectory -type d -name "Miniscope*")

for session in $data
do
	cd $session

	ID=$initials${session#*$initials}
	ID=${ID::6}
	date=202${session#*202}; date=${date::10}
	ID=$(echo ${ID}_${date})

	cd ../../
	tar_check=$(find -type f -name "*.tar" | wc -l)

	if (( $tar_check == 0 ))
	then
		echo "MISSING: $session has not been tarred!"
		# tar -cvf "$ID.tar" .
	else
		echo "CHECKED: Already tar-ed $ID in $session"
	fi
done

echo "Done!"
