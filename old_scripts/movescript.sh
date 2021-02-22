#!/bin/bash

initials='ZHA'

pwdirectory=$(pwd)
data=$(find $pwdirectory -type d -name "Miniscope" -o -name "Miniscope_2")

#for session in $data
#do
#	echo $session
#done

#echo "${!data[@]}"




session=$(sed -n 1p <<< "$data")

splits=$(echo $session | sed -e 's/\/.*\///g')

#echo $session
echo $splits
